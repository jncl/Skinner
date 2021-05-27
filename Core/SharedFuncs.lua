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
	classic_beta = {"2.5.1", 38757},
	classic_ptr  = {"2.5.1", 38757},
	classic_bc   = {"2.5.1", 38741},
	classic      = {"1.13.7", 38704},
	retail_beta  = {"10.0.0", 99999},
	retail_ptr   = {"9.1.0", 38802}, 
	retail       = {"9.0.5", 38556},
	curr         = {_G.GetBuildInfo()},
}
function aObj:checkVersion()

	local agentUID = _G.GetCVar("agentUID")
	-- aObj:Debug("agentUID: [%s, %s, %s, %s, %s]", agentUID, _G.GetBuildInfo())
	-- check to see which WoW version we are running on
	self.isClscBeta = agentUID == "wow_classic_beta" and true
	self.isClscPTR  = agentUID == "wow_classic_ptr" and true
	self.isClscBC   = agentUID == "wow_classic" and true
	self.isClsc     = agentUID == "wow_classic_era" and true
	self.isRetBeta  = agentUID == "wow_beta" and true
	self.isRetPTR   = agentUID == "wow_ptr" and true
	self.isRet      = agentUID == "wow" and true

	-- aObj:Debug("checkVersion: [%s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClscBC, self.isClsc, self.isRetBeta, self.isRetPTR, self.isRet)

	-- check current build number against Classic Beta, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscBeta and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.classic_beta[2])
	-- check current build number against Classic PTR, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscPTR and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.classic_ptr[2])
	-- check current build number against Classic BC, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClscBC and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.classic_bc[2])
	-- check current build number against Classic, if greater then it's a patch
	self.isPatch = self.isPatch or self.isClsc and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.classic[2])
	-- check current build number against Retail Beta, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRetBeta and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.retail_beta[2])
	-- check current build number against Retail PTR, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRetPTR and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.retail_ptr[2])
	-- check current build number against Retail, if greater then it's a patch
	self.isPatch = self.isPatch or self.isRet and _G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo.retail[2])

	--@alpha@
	local vType = self.isClscBeta and "Classic_Beta" or self.isClscPTR and "Classic_PTR" or self.isClscBC and "Classic_BC" or self.isClsc and "Classic" or self.isRetBeta and "Retail_Beta" or self.isRetPTR and "Retail_PTR" or "Retail"
	self:Printf("%s, %d, %s, %d, %s, %d, %s", buildInfo[vType:lower()][1], buildInfo[vType:lower()][2], buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	vType = self.isPatch and vType .. " (Patched)" or vType
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	vType = nil
	--@end-alpha@
	agentUID = nil

	-- indicate we're on ClassicPTR if on Classic Beta
	self.isClscPTR = self.isClscPTR or self.isClscBeta
	-- indicate we're on ClassicBC if on Classic Beta
	self.isClscBC  = self.isClscBC or self.isClscPTR or self.isClscBeta
	-- indicate we're on Classic if on Classic BC
	self.isClsc    = self.isClsc or self.isClscBC
	-- handle Beta changes in PTR or Live
	self.isClscBeta = self.isClscBeta or self.isClscPTR and buildInfo.curr[1] > buildInfo.classic_ptr[1]
	self.isRetBeta = self.isRetBeta or self.isRetPTR and buildInfo.curr[1] > buildInfo.retail_ptr[1]
	-- handle PTR changes going Live
	self.isClscPTR = self.isClscPTR or self.isPatch and self.isClscBC and buildInfo.curr[1] > buildInfo.classic_bc[1]
	self.isRetPTR  = self.isRetPTR or self.isPatch and self.isRet and buildInfo.curr[1] > buildInfo.retail[1]

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
