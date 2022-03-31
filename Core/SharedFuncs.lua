local aName, aObj = ...

local _G = _G

function aObj:add2Table(table, value) -- luacheck: ignore self
	--@alpha@
	_G.assert(table, "Unknown table add2Table\n" .. _G.debugstack(2, 3, 2))
	_G.assert(value, "Missing value add2Table\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	table[#table + 1] = value

end

local buildInfo = {
	-- Testing
	wow_classic_beta    = {"3.0.0",  99999, "Classic TBC Beta"},
	wow_classic_ptr     = {"2.5.4",  42940, "Classic TBC PTR"},
	wow_classic_era_ptr = {"1.14.3", 42926, "Classic Era PTR"}, -- a.k.a. Season of Mastery Beta
	wow_beta            = {"10.0.0", 99999, "Retail Beta"},
	wow_ptr             = {"9.2.5",  42850, "Retail PTR"},
	-- Live
	wow_classic         = {"2.5.4",  42940, "Classic TBC"},
	wow_classic_era     = {"1.14.2", 42597, "Classic Era"},
	wow                 = {"9.2.0",  42979, "Retail"},
	-- Currently playing
	curr                = {_G.GetBuildInfo()},
}
function aObj:checkVersion()

	local agentUID = _G.C_CVar.GetCVar("agentUID")
	-- self:Debug("checkVersion#0: [%s, %s, %s, %s, %s, %s, %s]", agentUID, _G.WOW_PROJECT_ID, _G.GetBuildInfo())
	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isRtlBeta    = agentUID == "wow_beta" and true
	self.isRtlPTR     = agentUID == "wow_ptr" and true
	self.isClscBC     = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC and true
	self.isClscERA    = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC and true
	self.isRtl        = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE and true

	-- self:Debug("checkVersion#1: [%s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtl)

	-- handle different country versions, e.g. wow_enus
	if not buildInfo[agentUID] then
		if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
			agentUID = "wow"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC then
			agentUID = "wow_classic_era"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
			agentUID = "wow_classic"
		end
	end

	-- check current build number against wow version build number, if greater then it's a patch
	self.isPatch = _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo[agentUID][2])

	--@alpha@
	self:Printf("%s, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][1], buildInfo[agentUID][2], buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	local vType = self.isPatch and buildInfo[agentUID][3] .. " (Patched)" or buildInfo[agentUID][3]
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	self:Debug(vType .. " detected")
	--@end-alpha@

	-- indicate we're on ClassicPTR if on Classic Beta
	self.isClscPTR    = self.isClscPTR or self.isClscBeta
	-- indicate we're on Classic BC (required for skin checks)
	self.isClscBC     = self.isClscBC or self.isClscPTR
	-- indicate we're on ClassicERA if on Classic ERA PTR
	self.isClscERA    = self.isClscERA  or self.isClscERAPTR
	-- indicate we're on Classic if on Classic BC or Classic ERA
	self.isClsc       = self.isClscBC or self.isClscERA
	-- handle Beta changes in PTR or Live
	self.isClscBeta   = self.isClscBeta or self.isClscPTR and buildInfo.curr[1] > buildInfo.wow_classic_ptr[1]
	self.isRtlBeta    = self.isRtlBeta or self.isRtlPTR and buildInfo.curr[1] > buildInfo.wow_ptr[1]
	-- handle PTR changes going Live
	self.isClscPTR    = self.isClscPTR or self.isPatch and self.isClscBC and buildInfo.curr[1] > buildInfo.wow_classic[1]
	self.isClscERAPTR = self.isClscERAPTR or self.isPatch and self.isClscERA and buildInfo.curr[1] > buildInfo.wow_classic_era[1]
	self.isRtlPTR     = self.isRtlPTR or self.isPatch and self.isRtl and buildInfo.curr[1] > buildInfo.wow[1]

	-- self:Debug("checkVersion#2: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClscBC, self.isClscERAPTR, self.isClscERA, self.isClsc, self.isRtlBeta, self.isRtlPTR, self.isRtl, self.isPatch)

	buildInfo = nil

end

local function makeString(obj)
	if _G.type(obj) == "table" then
		if _G.type(_G.rawget(obj, 0)) == "userdata"
		and _G.type(obj.GetObjectType) == "function"
		then
			return ("<%s:%s:%s>"):format(_G.tostring(obj), obj:GetObjectType(), obj:GetName() or "(Anon)")
		end
	end
	return _G.tostring(obj)
end
local function makeText(fStr, ...)
	local tmpTab = {}
	local output = ""
	if fStr
	and fStr.find
	and fStr:find("%%")
	and _G.select('#', ...) >= 1
	then
		for i = 1, _G.select('#', ...) do
			tmpTab[i] = makeString(_G.select(i, ...))
		end
		 -- handle missing variables
		local varCnt = _G.select(2, fStr:gsub("%%", ""))
		for i = #tmpTab, varCnt do
			tmpTab[i + 1] = "nil"
		end
		output = _G.string.join(" ", fStr:format(_G.unpack(tmpTab)))
	else
		tmpTab[1] = output
		tmpTab[2] = fStr and _G.type(fStr) == "table" and makeString(fStr) or fStr or ""
		for i = 1, _G.select('#', ...) do
			tmpTab[i + 2] = makeString(_G.select(i, ...))
		end
		output = _G.table.concat(tmpTab, " ")
	end
	return output
end
local function printIt(text, frame, r, g, b)
	(frame or _G.DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b)
end
function aObj:CustomPrint(r, g, b, ...) -- luacheck: ignore self

	printIt(_G.WrapTextInColorCode(aName, "ffffff78") .. " " .. makeText(...), nil, r, g, b)

end

--@debug@
aObj.debugFrame = _G.ChatFrame10
function aObj:Debug(...)

	local output = ("(DBG) %s:[%s.%03d]"):format(aName, _G.date("%H:%M:%S"), (_G.GetTime() % 1) * 1000)
	printIt(_G.WrapTextInColorCode(output, "ff7fff7f") .. " " .. makeText(...), self.debugFrame)

end
local dbg2Flag = false
function aObj:Debug2(...)

	if dbg2Flag then
		printIt("dbg2: " .. makeText(...), self.debugFrame)
	end

end
function aObj:Debug3(...)
	-- used by showCmds function
	printIt("dbg3: " .. makeText(...), self.debugFrame)

end
--@end-debug@
--[===[@non-debug@
aObj.Debug = _G.nop
aObj.Debug2 = _G.nop
aObj.Debug3 = _G.nop
--@end-non-debug@]===]
