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
	wow_classic_beta    = {"3.4.0",  45854, "Classic Beta"},
	wow_classic_ptr     = {"3.4.0",  45942, "Classic PTR"},
	wow_classic_era_ptr = {"1.14.3", 44834, "Classic Era PTR"}, -- a.k.a. Season of Mastery PTR
	wow_beta            = {"10.0.2", 45779, "Retail Beta"}, -- a.k.a. Dragonflight
	wow_ptr             = {"10.0.0", 45697, "Retail PTR"},
	-- Live
	wow_classic         = {"3.4.0",  45942, "Classic"}, -- a.k.a. Wrath of the Lich King Classic
	wow_classic_era     = {"1.14.3", 44834, "Classic Era"},
	wow                 = {"9.2.7",  45745, "Retail"},
	-- Currently playing
	curr                = {_G.GetBuildInfo()},
}
function aObj:checkVersion()

	local agentUID = _G.C_CVar.GetCVar("agentUID")
	-- handle different country versions, e.g. wow_enus
	if not buildInfo[agentUID] then
		if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
			agentUID = "wow"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC then
			agentUID = "wow_classic_era"
		elseif _G.WOW_PROJECT_ID == _G.WOW_PROJECT_WRATH_CLASSIC then
			agentUID = "wow_classic"
		end
	end
	-- self:Debug("checkVersion#0: [%s, %s, %s, %s, %s, %s, %s]", agentUID, _G.WOW_PROJECT_ID, _G.GetBuildInfo())

	-- check to see which WoW version we are running on
	self.isClscBeta   = agentUID == "wow_classic_beta" and true
	self.isClscPTR    = agentUID == "wow_classic_ptr" and true
	self.isClsc       = agentUID == "wow_classic" and true
	self.isClscERAPTR = agentUID == "wow_classic_era_ptr" and true
	self.isClscERA    = agentUID == "wow_classic_era" and true
	self.isRtlBeta    = agentUID == "wow_beta" and true
	self.isRtlPTR     = agentUID == "wow_ptr" and true
	self.isRtl        = agentUID == "wow" and true

	-- self:Debug("checkVersion#1: [%s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtl)

	-- check current version or build number against current wow version info, if greater then it's a patch
	self.isPatch = (buildInfo.curr[1] ~= buildInfo[agentUID][1]) or (_G.tonumber(buildInfo.curr[2]) > _G.tonumber(buildInfo[agentUID][2]))

	--@alpha@
	self:Printf("%s, %d, %s, %d, %s, %d, %s", buildInfo[agentUID][1], buildInfo[agentUID][2], buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	local vType = self.isPatch and buildInfo[agentUID][3] .. " (Patched)" or buildInfo[agentUID][3]
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	self:Debug(vType .. " detected")
	--@end-alpha@

	-- handle Beta changes in PTR or Live
	self.isClscBeta   = self.isClscBeta or self.isClscPTR and buildInfo.curr[1] > buildInfo.wow_classic_ptr[1]
	-- indicate we're on ClassicPTR if on Classic Beta
	self.isClscPTR    = self.isClscPTR or self.isClscBeta
	-- indicate we're on Classic if on Classic PTR
	self.isClsc       = self.isClsc or self.isClscPTR
	-- indicate we're on ClassicERA if on Classic ERA PTR
	self.isClscERA    = self.isClscERA  or self.isClscERAPTR
	-- handle Beta changes in PTR or Live
	self.isRtlBeta    = self.isRtlBeta or self.isRtlPTR and buildInfo.curr[1] > buildInfo.wow_ptr[1]
	-- indicate we're on Retail PTR if on Retail Beta
	self.isRtlPTR     = self.isRtlPTR or self.isRtlBeta
	-- indicate we're on Retail if on Retail PTR
	self.isRtl        = self.isRtl or self.isRtlPTR
	-- handle PTR changes going Live
	self.isClscPTR    = self.isClscPTR or self.isPatch and self.isClsc and buildInfo.curr[1] > buildInfo.wow_classic[1]
	self.isClscERAPTR = self.isClscERAPTR or self.isPatch and self.isClscERA and buildInfo.curr[1] > buildInfo.wow_classic_era[1]
	self.isRtlPTR     = self.isRtlPTR or self.isPatch and self.isRtl and buildInfo.curr[1] > buildInfo.wow[1]

	-- self:Debug("checkVersion#2: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", self.isClscBeta, self.isClscPTR, self.isClsc, self.isClscERAPTR, self.isClscERA, self.isRtlBeta, self.isRtlPTR, self.isRtl, self.isPatch)

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

function aObj:setupOptions(optNames, optIgnore, preLoadFunc, postLoadFunc)

	local db = self.db.profile
	local dflts = self.db.defaults.profile

	-- add DB profile options
	self.optTables.Profiles = _G.LibStub:GetLibrary("AceDBOptions-3.0", true):GetOptionsTable(self.db)
	self:add2Table(optNames, "Profiles")
	self:add2Table(optIgnore, "Profiles")

	self.optionsFrames = {}
	-- register the options tables and add them to the blizzard frame
	self.ACR:RegisterOptionsTable(aName, self.optTables.General)
	self.optionsFrames[aName] = self.ACD:AddToBlizOptions(aName, self.L[aName]) -- N.B. display localised name
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
			aObj.optionsFrames[oName] = aObj.ACD:AddToBlizOptions(optTitle, aObj.L[oName], aObj.L[aName]) -- N.B. use localised name
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
		if not aObj.isRtlPTR then
			_G.InterfaceAddOnsList_Update()
		else
			-- toggle tabs to force refresh of Categories
			_G.SettingsPanel.tabsGroup:SelectAtIndex(1)
			_G.SettingsPanel.tabsGroup:SelectAtIndex(2)
		end
		aObj:UnregisterMessage("Options_Selected")
	end
	self:RegisterMessage("Options_Selected", function(_, addon)
		if self ~= addon then return end
		categorySelected()
	end)
	if not aObj.isRtlPTR then
		self:RawHook("InterfaceOptionsListButton_OnClick", function(bObj, mouseButton)
			if bObj.element.name == aName
			and not bObj.element.hasChildren
			then
				categorySelected()
				self:Unhook("InterfaceOptionsListButton_OnClick")
				return
			end
			self.hooks.InterfaceOptionsListButton_OnClick(bObj, mouseButton)
		end, true)
	else
		local function onCategorySelected(addon, category)
			if category.name == aName then
				categorySelected()
				_G.SettingsPanel:GetCategoryList():UnregisterCallback(_G.SettingsCategoryListMixin.Event.OnCategorySelected, aObj)
			end
		end
		_G.SettingsPanel:GetCategoryList():RegisterCallback(_G.SettingsCategoryListMixin.Event.OnCategorySelected, onCategorySelected, self)
	end

end
