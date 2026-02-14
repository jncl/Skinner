local aName, aObj = ...

local _G = _G

local buildInfo = {
	-- _anniversary_
	-- wow_classic_beta    = {"MOP Classic Beta",          "5.5.0",  62071},
	wow_beta            	= {"Midnight Beta",             "12.0.1", 65893},
	wow_classic_ptr     	= {"PTR (MoP Classic)",			"5.5.3",  64794},
	wow_classic_era_ptr 	= {"PTR (Classic Era)",         "2.5.5",  65295},
	wow_ptr             	= {"PTR (Midnight)",			"12.0.0", 65614},
	wow_ptr_x           	= {"PTR (Midnight 12.0.1)",     "12.0.1", 65769},
	wow_classic_anniversary	= {"BC Anniversary", 			"2.5.5",  65895},
	wow_classic_era     	= {"World of Warcraft Classic", "1.15.8", 65888},
	wow_classic         	= {"Mists of Panderia Classic", "5.5.3",  65890},
	wow                 	= {"World of Warcraft",         "12.0.1", 65893},
	curr                	= {"curr", _G.GetBuildInfo()},
}

local function getTOCVer(ver)
	local n1, n2, n3 = _G.string.match(buildInfo[ver][2], "(%d+).(%d+).(%d)")
	return n1 * 10000 + n2 * 100 + n3
end
local function compareBuildInfo(ver1, ver2, exact)
	if exact then
		--@debug@
		aObj:Debug("cBI#1: [%s, %s, %d, %d, %d, %d]", ver1, ver2, getTOCVer(ver1), getTOCVer(ver2), _G.tonumber(buildInfo[ver1][3]), _G.tonumber(buildInfo[ver2][3]))
		--@end-debug@
		return (getTOCVer(ver1) == getTOCVer(ver2) and _G.tonumber(buildInfo[ver1][3]) == _G.tonumber(buildInfo[ver2][3]))
	else
		--@debug@
		aObj:Debug("cBI#2: [%s, %s, %d, %d, %d, %d]", ver1, ver2, getTOCVer(ver1), getTOCVer(ver2), _G.tonumber(buildInfo[ver1][3]), _G.tonumber(buildInfo[ver2][3]))
		--@end-debug@
		return (getTOCVer(ver1) >= getTOCVer(ver2) and _G.tonumber(buildInfo[ver1][3]) >= _G.tonumber(buildInfo[ver2][3]))
	end
end
function aObj:checkWoWVersion()

	local agentUID = _G.C_CVar.GetCVar("agentUID")
	--@debug@
	-- aObj:Debug("agentUID: [%s, %s]", agentUID)
	--@end-debug@

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
	self:Debug("checkVersion #1: [%s, %d, %d, %s, %d, %s, %d]", agentUID, _G.WOW_PROJECT_ID, _G.LE_EXPANSION_LEVEL_CURRENT, _G.GetBuildInfo())
	--@end-debug@

	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClsc       = agentUID == "wow_classic" and true
	self.isClscBCA    = agentUID == "wow_classic_anniversary" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isClscERA    = agentUID == "wow_classic_era" and true
	self.isMnlnBeta   = agentUID == "wow_beta" and true
	self.isMnlnPTR    = agentUID == "wow_ptr" and true
	self.isMnlnPTRX   = agentUID == "wow_ptr_x" and true
	self.isMnln       = agentUID == "wow" and true

	--@debug@
	self:Debug("checkVersion #2: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isClscBCA, self.isMnlnBeta, self.isMnlnPTR, self.isMnlnPTRX, self.isMnln)
	--@end-debug@

	-- handle PTR and Beta versions
	self.isClscPTR    = self.isClscPTR or self.isClscBeta
	self.isClsc       = self.isClsc or self.isClscPTR
	self.isClscERA    = self.isClscERA  or self.isClscERAPTR or self.isClscBCA
	self.isMnlnPTR    = self.isMnlnPTR or self.isMnlnBeta
	self.isMnln       = self.isMnln or self.isMnlnPTR or self.isMnlnPTRX

	self.isPatch = not compareBuildInfo(agentUID, "curr", true)
	if self.isPatch then
		if self.isMnln then
			self.isMnlnPTR = compareBuildInfo("curr", "wow_ptr",false)
			self.isMnlnPTRX = compareBuildInfo("curr", "wow_ptr_x", false)
		elseif self.isClsc then
			self.isClscPTR = compareBuildInfo("curr", "wow_classic_ptr", false)
		elseif self.isClscERA then
			self.isClscERAPTR = compareBuildInfo("curr", "wow_classic_era_ptr", false)
		end
	end

	--@debug@
	self:Debug("checkVersion #3: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isClscBCA, self.isMnlnBeta, self.isMnlnPTR, self.isMnlnPTRX, self.isMnln, self.isPatch)

	self:Printf("%s, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][2], buildInfo[agentUID][3], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4], buildInfo.curr[5] , agentUID)

	_G.DEFAULT_CHAT_FRAME:AddMessage(_G.strjoin(": ", aName , "Game version is", buildInfo[agentUID][1]), 0.75, 0.5, 0.25, nil, true)
	--@end-debug@

	-- --[===[@non-debug@
	-- self.isRtl = self.isMnln
	-- --@end-non-debug@]===]

end

function aObj.checkLibraries(_, extraLibs)

	if not _G.assert(_G.LibStub, aName .. " requires LibStub") then return false end

	local lTab = {"AceAddon-3.0", "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigDialog-3.0", "AceConfigRegistry-3.0", "AceConsole-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceEvent-3.0", "AceGUI-3.0", "AceHook-3.0", "AceLocale-3.0", "CallbackHandler-1.0", "LibDataBroker-1.1"}
	_G.tAppendAll(lTab, extraLibs)

	local hasError
	for _, lib in _G.pairs(lTab) do
		hasError = not _G.assert(_G.LibStub:GetLibrary(lib, true), aName .. " requires " .. lib)
	end

	return not hasError

end

function aObj:createAddOn(makeGlobal)

	_G.LibStub:GetLibrary("AceAddon-3.0"):NewAddon(self, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
	-- add to Global namespace if required
	if makeGlobal then
		_G[aName] = self
	end

	-- setup callback registry
	self.callbacks = _G.LibStub:GetLibrary("CallbackHandler-1.0", true):New(self)

	self:checkWoWVersion()

	if self.isMnln then
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

		_G.setmetatable(self, mt)
	end

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
		if obj.IsForbidden then
			return ("<%s:%s:%s>"):format(_G.tostring(obj), not obj:IsForbidden() and obj.GetObjectType and obj:GetObjectType() or _G.type(obj), not obj:IsForbidden() and obj.GetDebugName and obj:GetDebugName() or "(Forbidden)")
		else
			return ("<%s:%s:%s>"):format(_G.tostring(obj), obj.GetObjectType and obj:GetObjectType() or _G.type(obj), obj.GetDebugName and obj:GetDebugName() or "(Anon)")
		end
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

function aObj:handleProfileChanges()

	_G.StaticPopupDialogs[aName .. "_Reload_UI"] = {
		text = aObj.L["Confirm reload of UI to activate profile changes"],
		button1 = _G.OKAY,
		button2 = _G.CANCEL,
		OnAccept = function(_)
			_G.C_UI.Reload()
		end,
		OnCancel = function(_, _, reason)
			if reason == "timeout"
			or reason == "clicked"
			then
				aObj:CustomPrint(1, 1, 0, aObj.L["The profile"] .. " '" .. aObj.db:GetCurrentProfile() .. "' " .. aObj.L["will be activated next time you Login or Reload the UI"])
				_G.UIErrorsFrame:AddMessage(aObj.L["The profile"] .. " '" .. aObj.db:GetCurrentProfile() .. "' " .. aObj.L["will be activated next time you Login or Reload the UI"], 1, 1, 0)
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
	local function reloadAddon()
		-- setup defaults for new profile
		if aName == "Skinner" then
			aObj:checkAndRun("SetupDefaults", "opt", false, true)
		else
			aObj:SetupDefaults()
		end
		-- store shortcut
		aObj.prdb = aObj.db.profile
		-- prompt for reload
		_G.StaticPopup_Show(aName .. "_Reload_UI")
	end
	self.db:RegisterCallback("OnProfileChanged", reloadAddon)
	self.db:RegisterCallback("OnProfileCopied", reloadAddon)
	self.db:RegisterCallback("OnProfileReset", reloadAddon)

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

function aObj:checkLocaleStrings()

	self.localeStrings = _G[aName .. "LocaleStrings"] or {}
	local missingLocaleMessage = false
	_G.setmetatable(_G.LibStub:GetLibrary("AceLocale-3.0").apps[aName], {
		__index = function(t, k)
			-- ensure error only reported once
			_G.rawset(t, k, k)
			-- report if not in Master localisations table
			if not aObj.locale_enUS[k] then
				_G.print(aName, _G.WrapTextInColorCode(" >> Locale entry missing: ", "ffff0000"),  k)
				if not missingLocaleMessage then
					_G.SetBasicMessageDialogText(aName .. ": Missing Locale entry, please add to Locales/enUS_Locale_Strings.lua and then import them")
					missingLocaleMessage = true
				end
				aObj.localeStrings[k] = true
			end
			return k
		end
	})

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
		_G.Settings.OpenToCategory(aObj.L[aName])
	end
end
