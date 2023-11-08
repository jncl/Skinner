local aName, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

local buildInfo = {
	-- Testing
	-- wow_classic_beta    = {"3.4.0",  46158, "Classic Beta"},
	-- wow_beta            = {"11.0.0", nnnnn, "Retail Beta"}, -- a.k.a. ?
	wow_classic_ptr     = {"3.4.3",  51943, "Classic PTR"},
	wow_classic_era_ptr = {"1.14.4", 51146, "Classic Era PTR"},
	wow_ptr_x           = {"10.2.0", 52068, "Retail PTRX"}, -- [wowxptr]
	wow_ptr             = {"10.2.0", 52038, "Retail PTR"},
	-- Live
	wow_classic         = {"3.4.3",  51943, "Classic"}, -- a.k.a. Wrath of the Lich King Classic
	wow_classic_era     = {"1.14.4", 51829, "Classic Era"},
	wow                 = {"10.2.0", 52068, "Retail"},
	-- Currently playing
	curr                = {_G.GetBuildInfo()},
}

local function getTOCVer(ver)
	local n1, n2, n3 = _G.string.match(buildInfo[ver][1], "(%d+).(%d+).(%d)")
	return n1 * 10000 + n2 * 100 + n3
end
function aObj:checkVersion()

	local agentUID = _G.C_CVar.GetCVar("agentUID")
	-- handle different country versions, e.g. wow_enus
	-- WOW_PROJECT_BURNING_CRUSADE_CLASSIC [Unused ?]
	if not buildInfo[agentUID] then
		if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
			agentUID = "wow"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC then
			agentUID = "wow_classic_era"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_WRATH_CLASSIC then
			agentUID = "wow_classic"
		end
	end
	--@debug@
	self:Debug("checkVersion#0: [%s, %s, %s, %d, %s, %d, %s]", agentUID, _G.WOW_PROJECT_ID, _G.GetBuildInfo())
	--@end-debug@

	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClsc       = agentUID == "wow_classic" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isClscERA    = agentUID == "wow_classic_era" and true
	self.isRtlBeta    = agentUID == "wow_beta" and true
	self.isRtlPTR     = agentUID == "wow_ptr" and true
	self.isRtlPTRX    = agentUID == "wow_ptr_x" and true
	self.isRtl        = agentUID == "wow" and true
	--@debug@
	self:Debug("checkVersion#1: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtlPTRX, self.isRtl, self.isPatch)
	--@end-debug@

	self.tocVer = getTOCVer(agentUID)
	-- check current version or build number against current wow version info, if greater then it's a patch
	self.isPatch = (buildInfo.curr[4] > self.tocVer) or (_G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo[agentUID][2]))

	--@alpha@
	self:Printf("%s, %d, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][1], buildInfo[agentUID][2], self.tocVer, buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	local vType = self.isPatch and buildInfo[agentUID][3] .. " (Patched)" or buildInfo[agentUID][3]
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	--@debug@
	self:Debug(vType .. " detected, ")
	--@end-debug@
	--@end-alpha@

	-- handle Beta changes in PTR or Live
	self.isClscBeta   = self.isClscBeta or self.isClscPTR and self.isPatch
	-- indicate we're on ClassicPTR if on Classic Beta
	self.isClscPTR    = self.isClscPTR or self.isClscBeta
	-- indicate we're on Classic if on Classic PTR
	self.isClsc       = self.isClsc or self.isClscPTR
	-- indicate we're on ClassicERA if on Classic ERA PTR
	self.isClscERA    = self.isClscERA  or self.isClscERAPTR
	-- handle Beta changes in PTR or Live
	self.isRtlBeta    = self.isRtlBeta or self.isRtlPTR and self.isPatch
	-- indicate we're on Retail PTR if on Retail Beta
	self.isRtlPTR     = self.isRtlPTR or self.isRtlBeta
	-- indicate we're on Retail if on Retail PTR
	self.isRtl        = self.isRtl or self.isRtlPTR or self.isRtlPTRX
	-- handle PTR changes going Live
	self.isClscPTR    = self.isClscPTR or self.isClsc and self.isPatch
	self.isClscERAPTR = self.isClscERAPTR or self.isClscERA and self.isPatch
	self.isRtlPTR     = self.isRtlPTR or self.isRtl and self.isPatch
	self.isRtlPTRX    = self.isRtlPTRX or self.isRtl and self.isPatch
	--@debug@
	self:Debug("checkVersion#2: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtlPTRX, self.isRtl, self.isPatch)
	--@end-debug@

end

function aObj:add2Table(table, value) -- luacheck: ignore 212 (unused argument)
	--@alpha@
	_G.assert(table, "Unknown table add2Table\n" .. _G.debugstack(2, 3, 2))
	_G.assert(value, "Missing value add2Table\n" .. _G.debugstack(2, 3, 2))
	--@end-alpha@

	table[#table + 1] = value

end
function aObj:setupOptions(optNames, optIgnore, preLoadFunc, postLoadFunc)
	local _
	local db = self.db.profile
	local dflts = self.db.defaults.profile
	local acdObj = self.ACD
	-- N.B. use existing hooked function, created in Ace3 skin, if it exists
	if self.hooks
	and self.ACD
	and self.hooks[self.ACD]
	and self.hooks[self.ACD].AddToBlizOptions
	then
		acdObj = self.hooks[self.ACD]
	end

	-- add DB profile options
	self.optTables.Profiles = _G.LibStub:GetLibrary("AceDBOptions-3.0", true):GetOptionsTable(self.db)
	self:add2Table(optNames, "Profiles")
	self:add2Table(optIgnore, "Profiles")

	self.optionsFrames = {}
	-- register the options tables and add them to the blizzard frame
	self.ACR:RegisterOptionsTable(aName, self.optTables.General)
	self.optionsFrames[aName], _ = self.ACD:AddToBlizOptions(aName, self.L[aName]) -- N.B. display localised name
	self.optionsFrames[aName].OnDefault = function()
		for name, _ in _G.pairs(aObj.optTables.General.args) do
			db[name] = dflts[name]
		end
		aObj.ACR:NotifyChange(aName)
	end

	self.optCheck = {}
	for _, oName in _G.pairs(optNames) do
		self.optCheck[oName:lower()] = oName -- store option name in table
	end
	-- only setup the options if the AddOn's Options panel/subpanel is chosen
	local optTitle
	local function setupOptionPanels()
		for _, oName in _G.ipairs(optNames) do
			optTitle = _G.strjoin("_", aName, oName)
			aObj.ACR:RegisterOptionsTable(optTitle, aObj.optTables[oName])
			aObj.optionsFrames[oName], _ = acdObj.AddToBlizOptions(aObj.ACD, optTitle, aObj.L[oName], aObj.L[aName]) -- N.B. use localised name
			if not _G.tContains(optIgnore, oName) then
				aObj.optionsFrames[oName].OnDefault = function()
					for name, _ in _G.pairs(aObj.optTables[oName].args) do
						db[name] = dflts[name]
					end
					aObj.ACR:NotifyChange(optTitle)
				end
			end
		end
	end
	local function categorySelected()
		if preLoadFunc then
			preLoadFunc()
		end
		setupOptionPanels()
		if postLoadFunc then
			postLoadFunc()
		end
		-- toggle tabs to force refresh of Categories
		_G.SettingsPanel.tabsGroup:SelectAtIndex(1)
		_G.SettingsPanel.tabsGroup:SelectAtIndex(2)
		-- prevent function from running again as it has two different triggers
		categorySelected = _G.nop
	end
	self.RegisterCallback(aName, "Options_Selected", function()
		categorySelected()
		self.UnregisterCallback(aName, "Options_Selected")
	end)
	local function onCategorySelected(_, category)
		if category.name == aName then
			categorySelected()
			_G.SettingsPanel:GetCategoryList():UnregisterCallback(_G.SettingsCategoryListMixin.Event.OnCategorySelected, aObj)
		end
	end
	_G.SettingsPanel:GetCategoryList():RegisterCallback(_G.SettingsCategoryListMixin.Event.OnCategorySelected, onCategorySelected, self)

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
		output = _G.strjoin(" ", fStr:format(_G.unpack(tmpTab)))
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
function aObj:CustomPrint(r, g, b, ...) -- luacheck: ignore 212 (unused argument)

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

-- Addon Compartment (Retail only)
if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
	_G[aName .. "_OnAddonCompartmentClick"] = function(addonName, _, _)
		aObj.callbacks:Fire("Options_Selected")
		_G.Settings.OpenToCategory(addonName)
	end
end
