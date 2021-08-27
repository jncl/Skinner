local aName, aObj = ...

local _G = _G

function aObj:add2Table(table, value)
	--@alpha@
	_G.assert(table, "Unknown table add2Table\n" .. _G.debugstack(2, 3, 2))
	_G.assert(value, "Missing value add2Table\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	table[#table + 1] = value

end

local buildInfo = {
	-- Development
	wow_classic_beta    = {"2.5.1", 39170, "Classic BC Beta"},
	wow_classic_ptr     = {"2.5.2", 39926, "Classic BC PTR"},
	wow_classic_era_ptr = {"1.13.7", 39605, "Classic Era PTR"},
	wow_beta            = {"10.0.0", 99999, "Retail Beta"},
	wow_ptr             = {"9.1.0", 39804, "Retail PTR"},
	-- Live
	wow_classic         = {"2.5.1", 39640, "Classic BC"},
	wow_classic_era     = {"1.13.7", 39692, "Classic Era"},
	wow                 = {"9.1.0", 39804, "Retail"},
	-- Currently playing
	curr                = {_G.GetBuildInfo()},
}
function aObj:checkVersion()

	local agentUID = _G.GetCVar("agentUID")
	-- aObj:Debug("agentUID: [%s, %s, %s, %s, %s]", agentUID, _G.GetBuildInfo())
	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClscBC     = agentUID == "wow_classic" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isClscERA    = agentUID == "wow_classic_era" and true
	self.isRtlBeta    = agentUID == "wow_beta" and true
	self.isRtlPTR     = agentUID == "wow_ptr" and true
	self.isRtl        = agentUID == "wow" and true

	-- aObj:Debug("checkVersion#1: [%s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtl)

	-- check current build number against Classic Beta, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscBCBeta and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_classic_beta[2])
	-- check current build number against Classic BC PTR, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscPTR and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_classic_ptr[2])
	-- check current build number against Classic BC, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscBC and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_classic[2])
	-- check current build number against Classic BC PTR, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscERAPTR and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_classic_era_ptr[2])
	-- check current build number against Classic, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscERA and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_classic_era[2])
	-- check current build number against Retail Beta, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRtlBeta and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_beta[2])
	-- check current build number against Retail PTR, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRtlPTR and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow_ptr[2])
	-- check current build number against Retail, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRtl and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.wow[2])

	--@alpha@
	self:Printf("%s, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][1], buildInfo[agentUID][2], buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	local vType = self.isPatch and buildInfo[agentUID][3] .. " (Patched)" or buildInfo[agentUID][3]
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	self:Debug(vType .. " detected")
	vType = nil
	--@end-alpha@
	agentUID = nil

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

	-- aObj:Debug("checkVersion#2: [%s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClscBC, self.isClscERAPTR, self.isClscERA, self.isClsc, self.isRtlBeta, self.isRtlPTR, self.isRtl)

	buildInfo = nil

end

local tmpTab, tmpTab2 = {}, {}
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
    _G.wipe(tmpTab)
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
		varCnt = nil
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
function aObj:CustomPrint(r, g, b, fStr, ...)

	printIt( _G.WrapTextInColorCode(aName, "ffffff78") .. " " .. makeText(fStr, ...), nil, r, g, b)

end

--@debug@
-- specify where debug messages go & increase buffer size
aObj.debugFrame = _G.ChatFrame10
function aObj:Debug(fStr, ...)

	local output = ("(DBG) %s:[%s.%03d]"):format(aName, _G.date("%H:%M:%S"), (_G.GetTime() % 1) * 1000)
	printIt(_G.WrapTextInColorCode(output, "ff7fff7f") .. " " .. makeText(fStr, ...), self.debugFrame)
	output = nil

end

function aObj:Debug2(fStr, ...)
	-- self:Debug(fStr, ...)
end

function aObj:Debug3(fStr, ...)
	
	printIt("dbg: " .. makeText(fStr, ...), self.debugFrame)
	
end
--@end-debug@
--[===[@non-debug@
aObj.debugFrame = nil
aObj.Debug = _G.nop
aObj.Debug2 = _G.nop
aObj.Debug3 = _G.nop
--@end-non-debug@]===]
