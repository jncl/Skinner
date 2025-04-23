local aName, aObj = ...

local _G = _G

local buildInfo = {
	-- wow_classic_beta    = {"4.4.0",  54737, "Cataclysm Classic Beta"},
	-- wow_beta            = {"11.0.2", 56263, "The War Within Beta"},
	wow_classic_ptr     = {"4.4.2",  59185, "PTR (Cataclysm Classic)"},
	wow_classic_era_ptr = {"1.15.7", 60141, "PTR (Classic Era)"},
	wow_ptr             = {"11.1.5", 60428, "PTR (TWW 11.1.5"},
	wow_ptr_x           = {"11.1.0", 59347, "PTR (TWW 11.1.0)"},
	wow_classic_era     = {"1.15.7", 60277, "World of Warcraft Classic"},
	wow_classic         = {"4.4.2",  60192, "Cataclysm Classic"},
	wow                 = {"11.1.5", 60428, "World of Warcraft"},
	curr                = {_G.GetBuildInfo()},
}

local function getTOCVer(ver)
	local n1, n2, n3 = _G.string.match(buildInfo[ver][1], "(%d+).(%d+).(%d)")
	return n1 * 10000 + n2 * 100 + n3
end
local function compareBuildInfo(ver1, ver2, exact)
	if exact then
		--@debug@
		aObj:Debug("cBI#1: [%s, %s, %d, %d, %d, %d]", ver1, ver2, getTOCVer(ver1), getTOCVer(ver2), _G.tonumber(buildInfo[ver1][2]), _G.tonumber(buildInfo[ver2][2]))
		--@end-debug@
		return (getTOCVer(ver1) == getTOCVer(ver2) and _G.tonumber(buildInfo[ver1][2]) == _G.tonumber(buildInfo[ver2][2]))
	else
		--@debug@
		aObj:Debug("cBI#2: [%s, %s, %d, %d, %d, %d]", ver1, ver2, getTOCVer(ver1), getTOCVer(ver2), _G.tonumber(buildInfo[ver1][2]), _G.tonumber(buildInfo[ver2][2]))
		--@end-debug@
		return (getTOCVer(ver1) >= getTOCVer(ver2) and _G.tonumber(buildInfo[ver1][2]) >= _G.tonumber(buildInfo[ver2][2]))
	end
end
function aObj:checkWoWVersion()

	local agentUID = _G.C_CVar.GetCVar("agentUID")
	-- handle different country versions, e.g. wow_enus
	if not buildInfo[agentUID] then
		if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
			agentUID = "wow"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC then
			agentUID = "wow_classic_era"
		else
			agentUID = "wow_classic"
		end
	end
	--@debug@
	self:Debug("checkVersion#1: [%s, %d, %d, %s, %d, %s, %d]", agentUID, _G.WOW_PROJECT_ID, _G.LE_EXPANSION_LEVEL_CURRENT, _G.GetBuildInfo())
	--@end-debug@

	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClsc       = agentUID == "wow_classic" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isClscERA    = agentUID == "wow_classic_era" and true
	self.isMnlnBeta    = agentUID == "wow_beta" and true
	self.isMnlnPTR     = agentUID == "wow_ptr" and true
	self.isMnlnPTRX    = agentUID == "wow_ptr_x" and true
	self.isMnln        = agentUID == "wow" and true
	--@debug@
	self:Debug("checkVersion#2: [%s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isMnlnBeta, self.isMnlnPTR, self.isMnlnPTRX, self.isMnln)
	--@end-debug@

	-- handle PTR and Beta versions
	self.isClscPTR    = self.isClscPTR or self.isClscBeta
	self.isClsc       = self.isClsc or self.isClscPTR
	self.isClscERA    = self.isClscERA  or self.isClscERAPTR
	self.isMnlnPTR     = self.isMnlnPTR or self.isMnlnBeta
	self.isMnln        = self.isMnln or self.isMnlnPTR or self.isMnlnPTRX

	self.isPatch = not compareBuildInfo(agentUID, "curr", true)
	if self.isPatch then
		if self.isMnln then
			self.isMnlnPTR = compareBuildInfo(agentUID, "wow_ptr",false)
			self.isMnlnPTRX = compareBuildInfo(agentUID, "wow_ptr_x", false)
		elseif self.isClsc then
			self.isClscPTR = compareBuildInfo(agentUID, "wow_classic_ptr", false)
		elseif self.isClscERA then
			self.isClscERAPTR = compareBuildInfo(agentUID, "wow_classic_era_ptr", false)
		end
	end

	--@debug@
	self:Debug("checkVersion#3: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isMnlnBeta, self.isMnlnPTR, self.isMnlnPTRX, self.isMnln, self.isPatch)
	--@end-debug@

	--@debug@
	self:Printf("%s, %d, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][1], buildInfo[agentUID][2], self.tocVer, buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	_G.DEFAULT_CHAT_FRAME:AddMessage(_G.strjoin(" ", aName, ": Game version is:", buildInfo[agentUID][3]), 0.75, 0.5, 0.25, nil, true)
	--@end-debug@

	-- --[===[@non-debug@
	-- self.isRtl = self.isMnln
	-- --@end-non-debug@]===]

end

function aObj.checkLibraries(_, extraLibs)

	if not _G.assert(_G.LibStub, aName .. " requires LibStub") then return false end

	local lTab = {"AceAddon-3.0", "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigDialog-3.0", "AceConfigRegistry-3.0", "AceConsole-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceEvent-3.0", "AceGUI-3.0", "AceHook-3.0", "AceLocale-3.0", "CallbackHandler-1.0", "LibDataBroker-1.1"}
	for _, lib in _G.pairs(extraLibs) do
		lTab[#lTab + 1] = lib
	end

	local hasError
	for _, lib in _G.pairs(lTab) do
		hasError = not _G.assert(_G.LibStub:GetLibrary(lib, true), aName .. " requires " .. lib)
	end

	return not hasError

end

function aObj.createAddOn(_, makeGlobal)
	_G.LibStub:GetLibrary("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
	-- add to Global namespace if required
	if makeGlobal then
		_G[aName] = aObj
	end

	-- setup callback registry
	aObj.callbacks = _G.LibStub:GetLibrary("CallbackHandler-1.0", true):New(aObj)

	aObj:checkWoWVersion()

	-- metatable added to track AddOn skin usage of renamed variable
	local mt = {}
	mt.__index = function(table, key)
		if key == "isRtl" then
			--@debug@
			_G.assert(false, "Using old variable (isRtl)\n" .. _G.debugstack(2, 3, 2))
			--@end-debug@
			return _G.rawget(table, "isMnln")
		else
			return _G.rawget(table, key)
		end
	end
	-- protect the metatable
	mt.__metatable = true

	_G.setmetatable(aObj, mt)

end

function aObj.add2Table(_, tab, val)
	--@debug@
	_G.assert(tab, "Unknown table add2Table\n" .. _G.debugstack(2, 3, 2))
	_G.assert(val, "Missing value add2Table\n" .. _G.debugstack(2, 3, 2))
	--@end-debug@

	tab[#tab + 1] = val

end

function aObj.makeBoolean(_, var)

	return not not var

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
		return ("<%s:%s:%s>"):format(_G.tostring(obj), obj.GetObjectType and obj:GetObjectType() or _G.type(obj), obj.GetName and obj:GetName() or "(Anon)")
	elseif _G.type(obj) ~= "string" then
		return _G.tostring(obj)
	else
		return obj
	end
end
local function makeText(fStr, ...)
	local tmpTab = {}
	local output
	if fStr
	and _G.type(fStr) == "string"
	and fStr:find("%%")
	and _G.select('#', ...) >= 1
	then
		for _, str in _G.ipairs{...} do
			tmpTab[#tmpTab + 1] = makeString(str)
		end
		 -- handle missing variables
		local varCnt = _G.select(2, fStr:gsub("%%", ""))
		for i = #tmpTab, varCnt do
			tmpTab[i + 1] = "nil"
		end
		output = _G.strjoin(" ", fStr:format(_G.unpack(tmpTab)))
	else
		tmpTab[1] = fStr and makeString(fStr) or ""
		for _, str in _G.ipairs{...} do
			tmpTab[#tmpTab + 1] = makeString(str)
		end
		output = _G.table.concat(tmpTab, " ")
	end
	return output
end
local function printIt(text, frame, r, g, b)
	(frame or _G.DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b)
end
function aObj.CustomPrint(_, r, g, b, ...)

	printIt(_G.strjoin(" ", _G.WrapTextInColorCode(aName, "ffffff78"), makeText(...)), nil, r, g, b)

end

--@debug@
aObj.debugFrame = _G.ChatFrame10
function aObj:Debug(...)

	local output = ("(DBG) %s:[%s.%03d]"):format(aName, _G.date("%H:%M:%S"), (_G.GetTime() % 1) * 1000)
	printIt(_G.strjoin(" ", _G.WrapTextInColorCode(output, "ff7fff7f"), makeText(...)), self.debugFrame)

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
