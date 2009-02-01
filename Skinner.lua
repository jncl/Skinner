-- check to see if LibStub is loaded
assert(LibStub, "LibStub unavailable, Skinner not loaded")
-- check to see if AceAddon-3.0 is loaded
assert(LibStub("AceAddon-3.0"), "AceAddon-3.0 unavailable, Skinner not loaded")

Skinner = LibStub("AceAddon-3.0"):NewAddon("Skinner", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

assert(Skinner, "Skinner creation failed, missing Libraries")

-- specify where debug messages go
Skinner.debugFrame = ChatFrame7
Skinner.debugLevel = 1

-- Get Locale
Skinner.L = LibStub("AceLocale-3.0"):GetLocale("Skinner")

-- check to see if LibSharedMedia-3.0 is loaded
assert(LibStub("LibSharedMedia-3.0", true), "LibSharedMedia-3.0 unavailable, Skinner not loaded")
Skinner.LSM = LibStub("LibSharedMedia-3.0", true)

--check to see if running on PTR
Skinner.isPTR = FeedbackUI and true or false
--check to see if running on patch 3.0.8
Skinner.isPatch = GM_CHAT and true or false

function Skinner:OnInitialize()
--	self:Debug("OnInitialize")

--@debug@
	if self:IsDebugging() then self:Print("Debugging is enabled") self:Debug("Debugging is enabled") end
--@end-debug@

--@alpha@
	if self.isPTR then self:Debug("PTR detected") end
	if self.isPatch then self:Debug("Patch detected") end
--@end-alpha@

	-- setup the default DB values and register them
	self:checkAndRun("Defaults")
	-- setup the Addon's options
	self:checkAndRun("Options")

	-- register the default background texture
	self.LSM:Register("background", "Blizzard ChatFrame Background", "Interface\\ChatFrame\\ChatFrameBackground")
	-- register the inactive tab texture
	self.LSM:Register("background", "Inactive Tab", "Interface\\AddOns\\Skinner\\textures\\inactive")
	-- register the EditBox/ScrollBar texture
	self.LSM:Register("border", "Skinner EditBox/ScrollBar Border", "Interface\\AddOns\\Skinner\\textures\\krsnik")

	-- Heading and Body Text colours
	local c = self.db.profile.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	local c = self.db.profile.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b

	-- Frame multipliers
	self.FxMult, self.FyMult = 0.9, 0.87
	-- Frame Tab multipliers
	self.FTxMult, self.FTyMult = 0.5, 0.75
	-- EditBox regions to keep
	self.ebRegions = {1, 2, 3, 4, 5} -- 1 is text, 2-5 are textures

	-- Gradient settings
	local c = self.db.profile.GradientMin
	self.MinR, self.MinG, self.MinB, self.MinA = c.r, c.g, c.b, c.a
	local c = self.db.profile.GradientMax
	self.MaxR, self.MaxG, self.MaxB, self.MaxA = c.r, c.g, c.b, c.a
	local orientation = self.db.profile.Gradient.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOn = self.db.profile.Gradient.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	self.gradientOff = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}
	self.gradientTab = {orientation, .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {orientation, .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTexture = self.LSM:Fetch("background", self.db.profile.Gradient.texture)

	-- backdrop for Frames etc
	local bdtex = self.LSM:Fetch("background", "Blizzard ChatFrame Background")
	local bdbtex = self.LSM:Fetch("border", "Blizzard Tooltip")
	if self.db.profile.BdDefault then
		self.backdrop = {
			bgFile = bdtex, tile = true, tileSize = 16,
			edgeFile = bdbtex, edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		}
	else
		if self.db.profile.BdFile and self.db.profile.BdFile ~= "None" then
			bdtex = self.db.profile.BdFile
		else
			bdtex = self.LSM:Fetch("background", self.db.profile.BdTexture)
		end
		if self.db.profile.BdEdgeFile and self.db.profile.BdEdgeFile ~= "None" then
			bdbtex = self.db.profile.BdEdgeFile
		else
			bdbtex = self.LSM:Fetch("border", self.db.profile.BdBorderTexture)
		end
		local bdi = self.db.profile.BdInset
		local bdt = self.db.profile.BdTileSize > 0 and true or false
		self.backdrop = {
			bgFile = bdtex, tile = bdt, tileSize = self.db.profile.BdTileSize,
			edgeFile = bdbtex, edgeSize = self.db.profile.BdEdgeSize,
			insets = {left = bdi, right = bdi, top = bdi, bottom = bdi},
		}
	end

	-- backdrop for ScrollBars & EditBoxes
	local edgetex = self.LSM:Fetch("border", "Skinner EditBox/ScrollBar Border")
	self.backdrop2 = {
		bgFile = bdtex, tile = true, tileSize = 16,
		edgeFile = edgetex, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}
	-- narrow backdrop for ScrollBars
	self.backdrop3 = {
		bgFile = bdtex, tile = true, tileSize = 8,
		edgeFile = edgetex, edgeSize = 8,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
	}

	-- these are used to disable frames from being skinned
	self.charKeys1 = {"CharacterFrames", "PVPFrame", "PetStableFrame", "SpellBookFrame", "TalentUI", "DressUpFrame", "FriendsFrame", "TradeSkillUI", "TradeFrame", "RaidUI", "ReadyCheck", "Buffs", "AchieveFrame", "AchieveAlert", "AchieveWatch"}
	self.charKeys2 = {"QuestLog"}
	self.npcKeys = {"MerchantFrames", "GossipFrame", "TrainerUI", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard", "BarbershopUI"}
	self.uiKeys1 = {"StaticPopups", "ChatMenus", "ChatConfig", "ChatTabs", "ChatFrames", "CombatLogQBF", "LootFrame", "StackSplit", "ItemText", "Colours", "WorldMap", "HelpFrame", "KnowledgeBase", "InspectUI", "BattleScore", "BattlefieldMm", "ScriptErrors", "Tutorial", "DropDowns", "MinimapButtons", "MinimapGloss", "MenuFrames", "BankFrame", "MailFrame", "AuctionUI", "CoinPickup", "GMSurveyUI", "LFGFrame", "ItemSocketingUI", "GuildBankUI", "Nameplates", "TimeManager", "Calendar"}
	if IsMacClient() then table.insert(self.uiKeys1, "MovieProgress") end
	if self.isPTR then table.insert(self.uiKeys1, "Feedback") end
	self.uiKeys2 = {"Tooltips", "MirrorTimers", "CastingBar", "ChatEditBox", "GroupLoot", "ContainerFrames", "MainMenuBar"}
	-- these are used to disable the gradient
	self.charFrames = {}
	self.uiFrames = {}
	self.npcFrames = {}
	self.skinnerFrames = {}

	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	self.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefTooltip"}
	-- list of Tooltips used when the Tooltip style is 3
	self.ttList = CopyTable(self.ttCheck)
	table.insert(self.ttList, "SmallTextTooltip")
	-- Set the Tooltip Border
	self.ttBorder = true
	-- TooltipBorder colours
	local c = self.db.profile.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar colours
	local c = self.db.profile.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	self.sbTexture = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)
	-- Backdrop colours
	local c = self.db.profile.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a}
	-- BackdropBorder colours
	local c = self.db.profile.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a}
	-- Inactive Tab texture
	self.itTex = self.LSM:Fetch("background", "Inactive Tab")

	-- class table
	self.classTable = {"Druid", "Priest", "Paladin", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Warrior", "DeathKnight"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

end

function Skinner:OnEnable()
--	self:Debug("OnEnable")

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")

	self:ScheduleTimer("BlizzardFrames", self.db.profile.Delay.Init)
	self:ScheduleTimer("SkinnerFrames", self.db.profile.Delay.Init + 0.1)
	self:ScheduleTimer("AddonFrames", self.db.profile.Delay.Init + self.db.profile.Delay.Addons + 0.1)

	-- handle profile changes
	self.db.RegisterCallback(self, "OnProfileChanged", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileCopied", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileReset", "ReloadAddon")

end

function Skinner:ReloadAddon(callback)
-- 	self:Debug("ReloadAddon:[%s]", callback)

	StaticPopupDialogs["Skinner_Reload_UI"] = {
		text = self.L["Confirm reload of UI to activate profile changes"],
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(this, data, reason)
			if reason == "timeout" or reason == "clicked" then
				self:CustomPrint(1, 1, 0, nil, nil, nil, "The profile '"..Skinner.db:GetCurrentProfile().."' will be activated next time you Login or Reload the UI")
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
	StaticPopup_Show("Skinner_Reload_UI")

end


-- Printing Functions
local real_tostring = tostring
local function tostring(t)

	if type(t) == "table" then
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s>"):format(t:GetObjectType(), t:GetName() or "(anon)")
		end
	end
	return real_tostring(t)

end

local function clearTable(table)

	local i = 1
	while table[i] do
		table[i] = nil
		i =i + 1
	end

end

local function makeText(a1, ...)

	local tmp = {}
	local output = ""
	if a1:find("%%") and select('#', ...) >= 1 then
		for i = 1, select('#', ...) do
			tmp[i] = tostring(select(i, ...))
		end
		output = output .. " " .. a1:format(unpack(tmp))
	else
		tmp[1] = output
		tmp[2] = a1
		for i = 1, select('#', ...) do
			tmp[i+2] = tostring((select(i, ...)))
		end
		output = table.concat(tmp, " ")
	end
	clearTable(tmp)
	return output

end

local function print(text, r, g, b, frame, delay)

	(frame or DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b, 1, delay or 5)

end
--@debug@
function Skinner:Debug(a1, ...)

	local output = ("|cff7fff7f(DBG) %s:[%s.%3d]|r"):format("Skinner", date("%H:%M:%S"), (GetTime() % 1) * 1000)

	print(output.." "..makeText(a1, ...), nil, nil, nil, self.debugFrame)

end

function Skinner:LevelDebug(lvl, a1, ...) if self.debugLevel >= lvl then self:Debug(a1, ...) end end

function Skinner:IsDebugging() return true end
--@end-debug@
--[===[@non-debug@
function Skinner:Debug() end
function Skinner:LevelDebug() end
function Skinner:IsDebugging() end
--@end-non-debug@]===]

function Skinner:CustomPrint(r, g, b, frame, delay, connector, a1, ...)

	local output = ("|cffffff78Skinner:|r")

	print(output.." "..makeText(a1, ...), r, g, b, frame, delay)

end

-- Skinning functions
function Skinner:addSkinButton(obj, parent, hookObj, hideBut)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	if not obj then return end
	if not parent then parent = obj:GetParent() end
	if not hookObj then hookObj = obj end

	local but = CreateFrame("Button", nil, parent)
	but:SetPoint("TOPLEFT", obj, "TOPLEFT", -4, 4)
	but:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 4, -4)
	LowerFrameLevel(but)
	but:EnableMouse(false) -- allow clickthrough
	self:applySkin(but)
	if hideBut then but:Hide() end
	hookObj.sBut = but
	if not self:IsHooked(hookObj, "Show") then
		self:SecureHook(hookObj, "Show", function(this) this.sBut:Show() end)
		self:SecureHook(hookObj, "Hide", function(this) this.sBut:Hide() end)
	end

end

function Skinner:addSkinFrame(parent, xOfs1, yOfs1, xOfs2, yOfs2, ftype)
--@alpha@
	assert(parent, "Unknown object\n"..debugstack())
--@end-alpha@

	if not parent then return end

	xOfs1 = xOfs1 or -3
	yOfs1 = yOfs1 or -3
	xOfs2 = xOfs2 or 3
	yOfs2 = yOfs2 or 3
	local skinFrame = CreateFrame("Frame", nil, parent)
	skinFrame:ClearAllPoints()
	skinFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOfs1, yOfs1)
	skinFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", xOfs2, yOfs2)
	if not ftype then self:applySkin(skinFrame)
	else self:storeAndSkin(ftype, skinFrame) end
	if parent:GetFrameLevel() == 0 then parent:SetFrameLevel(1) end
	skinFrame:SetFrameLevel(parent:GetFrameLevel() - 1)
	parent.skinFrame = skinFrame

end

function Skinner:applyGradient(frame, fh)

	-- don't apply a gradient if required
	if not self.db.profile.Gradient.char then
		for _, v in pairs(self.charFrames) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.ui then
		for _, v in pairs(self.uiFrames) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.npc then
		for _, v in pairs(self.npcFrames) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.skinner then
		for _, v in pairs(self.skinnerFrames) do
			if v == frame then return end
		end
	end

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTexture)

	if self.db.profile.FadeHeight.enable and (self.db.profile.FadeHeight.force or not fh) then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	end
--	self:Debug("aG Fade Height: [%s, %s, %s]", frame:GetName(), frame:GetHeight(), fh)

	if self.db.profile.Gradient.invert then
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4)
		if fh then frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -4, -(fh - 4))
		else frame.tfade:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4) end
	else
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		if fh then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		else frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4) end
	end

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

function Skinner:applySkin(frame, header, bba, ba, fh, bd)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

--	self:Debug("applySkin: [%s, %s, %s, %s, %s, %s]", frame:GetName() or frame, header, bba, ba, fh, bd)

	if not frame then return end
	local hasIOT = assert(frame.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location in the BugSack
	if hasIOT and not frame:IsObjectType("Frame") then
		if self.db.profile.Errors then
			self:CustomPrint(1, 0, 0, nil, nil, nil, "Error skinning", frame.GetName and frame:GetName() or frame, "not a Frame or subclass of Frame: ", frame:GetObjectType())
			return
		end
	end

	frame:SetBackdrop(bd or self.backdrop)
	local r, g, b, a = unpack(self.bColour)
	frame:SetBackdropColor(r, g, b, ba or a)
	local r, g, b, a = unpack(self.bbColour)
	frame:SetBackdropBorderColor(r, g, b, bba or a)

	if header then
		for _, v in pairs({"Header", "_Header", "_HeaderBox", "FrameHeader", "HeaderTexture"}) do
			local hdr = _G[frame:GetName()..v]
			if hdr then
				hdr:Hide()
				hdr:SetPoint("TOP", frame, "TOP", 0, 7)
				break
			end
		end
	end

	self:applyGradient(frame, fh)

end

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(funcName, LoD)
	-- handle errors from internal functions
	local success, err = xpcall(function() return Skinner[funcName](Skinner, LoD) end, errorhandler)
	if not success then
		if Skinner.db.profile.Errors then
			Skinner:CustomPrint(1, 0, 0, nil, nil, nil, "Error running", funcName)
		end
	end
end

function Skinner:checkAndRun(funcName)
--	self:Debug("checkAndRun:[%s]", funcName or "<Anon>")

	if type(self[funcName]) == "function" then
		safecall(funcName)
	else
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, nil, nil, nil, "function ["..funcName.."] not found in Skinner")
		end
	end

end

function Skinner:checkAndRunAddOn(addonName, LoD, addonFunc)

	if not addonFunc then addonFunc = addonName end

--	self:Debug("checkAndRunAddOn:[%s, %s, %s, %s, %s]", addonName, LoD, IsAddOnLoaded(addonName), IsAddOnLoadOnDemand(addonName), type(self[addonFunc]))

	if not IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if IsAddOnLoadOnDemand(addonName) and not LoD then
--			self:Debug(addonName, "is managed by a LoadManager, converting to LoD status")
			self.lmAddons[addonName] = addonFunc
		-- Nil out loaded Skins for Addons that aren't loaded
		elseif self[addonFunc] then
			self[addonFunc] = nil
--			self:Debug(addonName, "skin unloaded as Addon not loaded")
		end
	else
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not self[addonFunc] then
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, nil, nil, nil, addonName, "loaded but skin not found in the SkinMe directory")
			end
		elseif type(self[addonFunc]) == "function" then
--			self:Debug("checkAndRunAddOn#2:[%s, %s]", addonFunc, self[addonFunc])
			safecall(addonFunc, LoD)
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, nil, nil, nil, "function ["..addonFunc.."] not found in Skinner")
			end
		end
	end

end

function Skinner:findFrame(height, width, children)

	local frame
	local obj = EnumerateFrames()

	while obj do

		if obj:IsObjectType("Frame") then
			if obj:GetName() == nil then
				if obj:GetParent() == nil then
--					self:Debug("UnNamed Frame's H, W: [%s, %s]", obj:GetHeight(), obj:GetWidth())
					if math.ceil(obj:GetHeight()) == height and math.ceil(obj:GetWidth()) == width then
						local kids = {}
						for i = 1, obj:GetNumChildren() do
							local v = select(i, obj:GetChildren())
--							self:Debug("UnNamed Frame's Children's Type: [%s]", v:GetObjectType())
							kids[i] = v:GetObjectType()
						end
						local matched = 0
						for _, c in pairs(children) do
							for _, k in pairs(kids) do
								if c == k then matched = matched + 1 end
							end
						end
						if matched == #children then
							frame = obj
							break
						end
					end
				end
			end
		end

		obj = EnumerateFrames(obj)
	end

	return frame

end

function Skinner:findFrame2(parent, objType, ...)
--@alpha@
	assert(parent, "Unknown object\n"..debugstack())
--@end-alpha@

	if not parent then return end

--	self:Debug("findFrame2: [%s, %s, %s, %s, %s, %s, %s]", parent, objType, select(1, ...) or nil, select(2, ...) or nil, select(3, ...) or nil, select(4, ...) or nil, select(5, ...) or nil)

	local frame

	for i = 1, parent:GetNumChildren() do
		local obj = select(i, parent:GetChildren())
		if obj:GetName() == nil then
			if obj:IsObjectType(objType) then
				if select("#", ...) > 2 then
					-- base checks on position
					local point, relativeTo, relativePoint, xOfs, yOfs = obj:GetPoint()
					xOfs = math.ceil(xOfs)
					yOfs = math.ceil(yOfs)
--					self:Debug("UnNamed Object's Point: [%s, %s, %s, %s, %s]", point, relativeTo, relativePoint, xOfs, yOfs)
					if  point         == select(1, ...)
					and relativeTo    == select(2, ...)
					and relativePoint == select(3, ...)
					and xOfs          == select(4, ...)
					and yOfs          == select(5, ...) then
						frame = obj
						break
					end
				else
					-- base checks on size
					local height, width = math.ceil(obj:GetHeight()), math.ceil(obj:GetWidth())
-- 					self:Debug("UnNamed Object's H, W: [%s, %s]", height, width)
					if  height == select(1, ...)
					and width  == select(2, ...) then
						frame = obj
						break
					end
				end
			end
		end
	end

	return frame

end

function Skinner:findFrame3(name, element)
--	self:Debug("findFrame3: [%s, %s]", name, element)

	for i = 1, UIParent:GetNumChildren() do
		local obj = select(i, UIParent:GetChildren())
		if obj:GetName() == name then
			if obj[element] then return obj end
		end
	end

	return nil

end

function Skinner:getChild(obj, childNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	if obj and childNo then return (select(childNo, obj:GetChildren())) end -- this will return only 1 value

end

function Skinner:getRegion(obj, regNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	if obj and regNo then return (select(regNo, obj:GetRegions())) end -- this will return only 1 value

end

local sbGlazed = {}
function Skinner:glazeStatusBar(statusBar, fi, texture)
--@alpha@
	assert(statusBar and statusBar:IsObjectType("StatusBar"), "Not a StatusBar\n"..debugstack())
--@end-alpha@

	if not statusBar or not statusBar:IsObjectType("StatusBar") then return end
	
	statusBar:SetStatusBarTexture(self.sbTexture)
	table.insert(sbGlazed, statusBar)

	if fi then
		if texture then
			if not statusBar.bg then statusBar.bg = statusBar:CreateTexture(nil, "BORDER") end
			statusBar.bg:SetTexture(self.sbTexture)
			statusBar.bg:SetVertexColor(unpack(self.sbColour))
		else
			if not statusBar.bg then statusBar.bg = CreateFrame("StatusBar", nil, statusBar) end
			local sbfs = statusBar:GetFrameStrata()
			statusBar.bg:SetFrameStrata(sbfs ~= "UNKNOWN" and sbfs or "BACKGROUND")
			local sbfl = statusBar:GetFrameLevel()
			statusBar.bg:SetFrameLevel(sbfl > 0 and sbfl - 1 or 0)
			statusBar.bg:SetStatusBarTexture(self.sbTexture)
			statusBar.bg:SetStatusBarColor(unpack(self.sbColour))
			table.insert(sbGlazed, statusBar.bg)
		end
		statusBar.bg:SetPoint("TOPLEFT", statusBar, "TOPLEFT", fi, -fi)
		statusBar.bg:SetPoint("BOTTOMRIGHT", statusBar, "BOTTOMRIGHT", -fi, fi)
	end

end

local ddTex = "Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"
function Skinner:isDropDown(obj)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	local objTexName
	if obj:GetName() then objTexName = _G[obj:GetName().."Left"] end
--	self:Debug("isDropDown: [%s, %s]", obj:GetName(), objTexName)
	if obj:IsObjectType("Frame") and objTexName and objTexName:GetTexture() == ddTex then return true
	else return false end

end

function Skinner:isVersion(addonName, verNoReqd, actualVerNo)
--	self:Debug("isVersion: [%s, %s, %s]", addonName, verNoReqd, actualVerNo)

	local hasMatched = false

	if type(verNoReqd) == "table" then
		for _, v in pairs(verNoReqd) do
			if v == actualVerNo then
				hasMatched = true
				break
			end
		end
	else
		if verNoReqd == actualVerNo then hasMatched = true end
	end

	if not hasMatched and self.db.profile.Warnings then
		local addText = ""
		if type(verNoReqd) ~= "table" then addText = "Version "..verNoReqd.." is required" end
		self:CustomPrint(1, 0.25, 0.25, nil, nil, nil, "Version", actualVerNo, "of", addonName, "is unsupported.", addText)
	end

	return hasMatched

end

function Skinner:keepFontStrings(frame)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

--	self:Debug("keepFontStrings: [%s]", frame:GetName() or "???")

	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		if not reg:IsObjectType("FontString") then
			reg:SetAlpha(0)
		end
	end

end

function Skinner:keepRegions(frame, regions)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

--	self:Debug("keepRegions: [%s]", frame:GetName() or "???")

	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		local keep
		if self:IsDebugging() and regions then
			if reg:IsObjectType("FontString") then self:LevelDebug(3, "kr FS: [%s, %s]", frame:GetName() or "nil", i) end
		end
		-- if we have a list, hide the regions not in that list
		if regions then
			for _, r in pairs(regions) do
				if i == r then keep = true break end
			end
		end
		if not keep then
--			 self:Debug("remove region: [%s, %s]", i, reg:GetName())
			reg:SetAlpha(0)
		end
	end

end

function Skinner:makeMFRotatable(frame)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	frame:EnableMouse(true)
	frame.draggingDirection = nil
	frame.cursorPosition = {}

	if not self:IsHooked(frame, "OnUpdate") then
		self:SecureHookScript(frame, "OnUpdate", function(...)
			if this.dragging then
				local x,y = GetCursorPosition()
				if this.cursorPosition.x > x then
					Model_RotateLeft(frame, (this.cursorPosition.x - x) * arg1)
				elseif this.cursorPosition.x < x then
					Model_RotateRight(frame, (x - this.cursorPosition.x) * arg1)
				end
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(frame, "OnMouseDown", function()
			if arg1 == "LeftButton" then
				this.dragging = true
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(frame, "OnMouseUp", function()
			if this.dragging then
				this.dragging = false
				this.cursorPosition.x, this.cursorPosition.y = nil
			end
		end)
	end

	--[[ MouseWheel to zoom Modelframe - in/out works, but needs to be fleshed out
	frame:SetScript("OnMouseWheel", function()
		local xPos, yPos, zPos = frame:GetPosition()
		if arg1 == 1 then
			frame:SetPosition(xPos+00.1, 0, 0)
		else
			frame:SetPosition(xPos-00.1, 0, 0)
		end
	end) ]]

end

function Skinner:moveObject(objName, xAdj, xDiff, yAdj, yDiff, relTo)
--@alpha@
	assert(objName, "Unknown object\n"..debugstack())
--@end-alpha@

	if not objName then return end
	
--	self:Debug("moveObject: [%s, %s%s, %s%s, %s]", objName:GetName() or "<Anon>", xAdj, xDiff, yAdj, yDiff, relTo)

	local point, relativeTo, relativePoint, xOfs, yOfs = objName:GetPoint()
--	self:Debug("GetPoint: [%s, %s, %s, %s, %s]", point, relativeTo and relativeTo:GetName() or "<Anon>", relativePoint, xOfs, yOfs)

	-- Workaround for yOfs crash when using bar addons
	if not yOfs then return end

	relTo = relTo or relativeTo
	-- Workaround for relativeTo crash
	if not relTo then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, nil, nil, nil, "moveObject (relativeTo) error:", tostring(objName))
		end
		return
	end

	-- apply the adjustment
	if xAdj == nil then xOffset = xOfs else xOffset = (xAdj == "+" and xOfs + xDiff or xOfs - xDiff) end
	if yAdj == nil then yOffset = yOfs else yOffset = (yAdj == "+" and yOfs + yDiff or yOfs - yDiff) end

	objName:ClearAllPoints()
	objName:SetPoint(point, relTo, relativePoint, xOffset, yOffset)

end

function Skinner:removeRegions(frame, regions)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

--	self:Debug("removeRegions: [%s]", frame:GetName() or "???")

	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		if self:IsDebugging() and regions then
			if reg:IsObjectType("FontString") then self:LevelDebug(3, "rr FS: [%s, %s]", frame:GetName() or "nil", i) end
		end
		-- if we have a list, hide the regions in that list
		-- otherwise, hide all regions of the frame
		if regions then
			for _, r in pairs(regions) do
				if i == r then reg:SetAlpha(0) break end
			end
		else
--			self:Debug("remove region: [%s, %s]", i, reg:GetName())
			reg:SetAlpha(0)
		end
	end

end

function Skinner:resizeTabs(frame)

	local fN = frame:GetName()
	local tabName = fN.."Tab"
	local nT
	-- get the number of tabs
	nT = ((fN == "CharacterFrame" and not CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
--	self:Debug("rT: [%s, %s]", tabName, nT)
	-- accumulate the tab text widths
	local tTW = 0
	for i = 1, nT do
		tTW = tTW + _G[tabName..i.."Text"]:GetWidth()
	end
	-- add the tab side widths
	local tTW = tTW + (40 * nT)
	-- get the frame width
	local fW = frame:GetWidth()
	-- calculate the Tab left width
	local tlw = (tTW > fW and (40 - (tTW - fW) / nT) / 2 or 20)
	-- set minimum left width
	tlw = format("%.2f", (tlw >= 6 and tlw or 5.5))
-- 	self:Debug("resizeTabs: [%s, %s, %s, %s, %s]", fN, nT, tTW, fW, tlw)
	-- update each tab
	for i = 1, nT do
		_G[tabName..i.."Left"]:SetWidth(tlw)
		PanelTemplates_TabResize(_G[tabName..i], 0)
	end

end

function Skinner:setActiveTab(tabName)
--@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setActiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.gradientTexture)
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

function Skinner:setInactiveTab(tabName)
--@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setInactiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.itTex)
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientTab))

end

function Skinner:setTTBackdrop(bdReqd)
--	self:Debug("setTTBackdrop: [%s]", bdReqd)

	for _, tooltip in pairs(self.ttList) do
--		self:Debug("sTTB: [%s]", tooltip)
		local ttip = _G[tooltip]
		if ttip then
			if bdReqd then ttip:SetBackdrop(self.backdrop)
			else ttip:SetBackdrop(nil) end
		end
	end

end

function Skinner:setTTBBC()
-- 	self:Debug("setTTBBC: [%s, %s, %s, %s]", unpack(self.tbColour))

	if self.db.profile.Tooltips.border == 1 then
		return unpack(self.bbColour)
	else
		return unpack(self.tbColour)
	end

end

function Skinner:shrinkBag(frame, bpMF)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	local frameName = frame:GetName()
	local bgTop = _G[frameName.."BackgroundTop"]
	if math.floor(bgTop:GetHeight()) == 256 then -- this is the backpack
--		self:Debug("Backpack found")
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[frameName.."MoneyFrame"]:GetPoint())
--			self:Debug("Backpack Money Frame found: [%s, %s]", yOfs, math.floor(yOfs))
			if math.floor(yOfs) == -216 or math.floor(yOfs) == -217 then -- is it still in its original position
--				self:Debug("Backpack Money Frame moved")
				self:moveObject(_G[frameName.."MoneyFrame"], nil, nil, "+", 22)
			end
		end
		self:moveObject(_G[frameName.."Item1"], nil, nil, "+", 19)
	end
	if math.ceil(bgTop:GetHeight()) == 94 then frame:SetHeight(frame:GetHeight() - 20) end
	if math.ceil(bgTop:GetHeight()) == 86 then frame:SetHeight(frame:GetHeight() - 20) end
	if math.ceil(bgTop:GetHeight()) == 72 then frame:SetHeight(frame:GetHeight() + 2) end -- 6, 10 or 14 slot bag

	frame:SetWidth(frame:GetWidth() - 10)
	self:moveObject(_G[frameName.."Item1"], "+", 3, nil, nil)

	-- use default fade height
	local fh = self.db.profile.ContainerFrames.fheight <= math.ceil(frame:GetHeight()) and self.db.profile.ContainerFrames.fheight or math.ceil(frame:GetHeight())

	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
	-- set the Fade Height
	-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	end
--	self:Debug("sB - Frame, Fade Height: [%s, %s]", frame:GetName(), fh)

	if fh and frame.tfade then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -fh) end

end

function Skinner:skinDropDown(frame, moveTexture, noSkin, noMove)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end
	if not (frame.GetName and frame:GetName() and _G[frame:GetName().."Right"]) then return end -- ignore tekKonfig dropdowns

	if not self.db.profile.TexturedDD or noSkin then self:keepFontStrings(frame) return end

	_G[frame:GetName().."Left"]:SetAlpha(0)
	_G[frame:GetName().."Right"]:SetAlpha(0)
	_G[frame:GetName().."Middle"]:SetTexture(self.itTex)
	_G[frame:GetName().."Middle"]:SetHeight(19)

	if not noMove then
		self:moveObject(_G[frame:GetName().."Button"], "-", 6, "-", 2)
		self:moveObject(_G[frame:GetName().."Text"], nil, nil, "-", 2)
	end

	if moveTexture then self:moveObject(_G[frame:GetName().."Middle"], nil, nil, "+", 2) end

end

function Skinner:skinEditBox(editBox, regions, noSkin, noHeight, noWidth)
--@alpha@
	assert(editBox and editBox:IsObjectType("EditBox"), "Not an EditBox\n"..debugstack())
--@end-alpha@

	if not editBox then return end

	local kRegions = CopyTable(self.ebRegions)
	if regions then
		for _, v in pairs(regions) do
			table.insert(kRegions, v)
		end
	end

	self:keepRegions(editBox, kRegions)
	local l, r, t, b = editBox:GetTextInsets()
	editBox:SetTextInsets(l + 5, r + 5, t, b)
	if not (noHeight or editBox:IsMultiLine()) then editBox:SetHeight(26) end
	if not noWidth then editBox:SetWidth(editBox:GetWidth() + 5) end

	if not noSkin then self:skinUsingBD2(editBox) end

end

function Skinner:skinFFToggleTabs(tabName, tabCnt)
--	self:Debug("skinFFToggleTabs: [%s]", tabName)

	if not tabCnt then tabCnt = 3 end
	for i = 1, tabCnt do
		local togTab = _G[tabName..i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text/scripts
		togTab:SetHeight(togTab:GetHeight() - 5)
		if i == 1 then self:moveObject(togTab, nil, nil, "+", 3) end
		self:moveObject(_G[togTab:GetName().."Text"], "-", 2, "+", 3)
		self:moveObject(_G[togTab:GetName().."HighlightTexture"], "-", 2, "+", 5)
		self:storeAndSkin(ftype, togTab)
	end

end

function Skinner:skinFFColHeads(buttonName, noCols)
-- 	self:Debug("skinFFColHeads: [%s]", buttonName)

	local numCols = noCols and noCols or 4
	for i = 1, numCols do
		self:keepFontStrings(_G[buttonName..i])
		self:storeAndSkin(ftype, _G[buttonName..i])
	end

end

function Skinner:skinMoneyFrame(frame, moveGold, noWidth, moveSilverBox)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	for k, v in pairs({"Gold", "Silver", "Copper"}) do
		local fName = _G[frame:GetName()..v]
		fName:SetWidth(fName:GetWidth() - 4)
		fName:SetHeight(fName:GetHeight() + 4)
		self:skinEditBox(fName, {9}, nil, true) -- N.B. region 9 is the icon
		if k ~= 1 or moveGold then
			self:moveObject(self:getRegion(fName, 9), "+", 10, nil, nil)
		end
		if not noWidth and k ~= 1 then
			fName:SetWidth(fName:GetWidth() + 5)
		end
		if v == "Silver" and moveSilverBox then
			self:moveObject(fName, "-", 10, nil, nil)
		end
	end

end

function Skinner:skinScrollBar(scrollFrame, sbPrefix, sbObj, narrow)
--@alpha@
	assert(scrollFrame and scrollFrame:IsObjectType("ScrollFrame"), "Not a ScrollFrame\n"..debugstack())
--@end-alpha@

	if not scrollFrame then return end
	
--	self:Debug("skinScrollBar: [%s, %s, %s, %s]", scrollFrame:GetName(), sbPrefix or 'nil', sbObj or 'nil', narrow or 'nil')

	local sBar = sbObj and sbObj or _G[scrollFrame:GetName()..(sbPrefix or "").."ScrollBar"]
	if narrow then
		self:skinUsingBD3(sBar)
	else
		self:skinUsingBD2(sBar)
	end

end

function Skinner:skinSlider(slider)
--@alpha@
	assert(slider and slider:IsObjectType("Slider"), "Not a Slider\n"..debugstack())
--@end-alpha@

	self:keepFontStrings(slider)
	slider:SetAlpha(1)
	slider:GetThumbTexture():SetAlpha(1)
	self:skinUsingBD2(slider)

end

function Skinner:skinTooltip(frame)
	if not self.db.profile.Tooltips.skin then return end
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	if not self.db.profile.Gradient.ui then return end

	local ttHeight = math.ceil(frame:GetHeight())

--	self:Debug("sT: [%s, %s, %s, %s]", frame, frame:GetName(), self.ttBorder, ttHeight)

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTexture)

	if self.db.profile.Tooltips.style == 1 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -6, -27)
	elseif self.db.profile.Tooltips.style == 2 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	else
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		-- set the Fade Height making sure that it isn't greater than the frame height
		local fh = self.db.profile.FadeHeight.value <= ttHeight and self.db.profile.FadeHeight.value or ttHeight
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		frame:SetBackdropColor(unpack(self.bColour))
	end

	-- Check to see if we need to colour the Border
	if not self.ttBorder then
		for _, tooltip in pairs(self.ttCheck) do
			if tooltip == frame:GetName() then
				local r, g, b, a = frame:GetBackdropBorderColor()
				r = string.format("%.2f", r)
				g = string.format("%.2f", g)
				b = string.format("%.2f", b)
				a = string.format("%.2f", a)
--				self:Debug("checkTTBBC: [%s, %s, %s, %s, %s]", frame:GetName(), r, g, b, a)
				if r ~= "1.00" or g ~= "1.00" or b ~= "1.00" or a ~= "1.00" then return end
			end
		end
	end

	frame:SetBackdropBorderColor(self:setTTBBC())

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

function Skinner:skinUsingBD2(obj)

	obj:SetBackdrop(self.backdrop2)
	obj:SetBackdropBorderColor(.2, .2, .2, 1)
	obj:SetBackdropColor(.1, .1, .1, 1)

end

function Skinner:skinUsingBD3(obj)

	obj:SetBackdrop(self.backdrop3)
	obj:SetBackdropBorderColor(.2, .2, .2, 1)
	obj:SetBackdropColor(.1, .1, .1, 1)

end

function Skinner:storeAndSkin(ftype, frame, ...)

	if ftype == "c" then table.insert(self.charFrames, frame)
	elseif ftype == "u" then table.insert(self.uiFrames, frame)
	elseif ftype == "n" then table.insert(self.npcFrames, frame)
	elseif ftype == "s" then table.insert(self.skinnerFrames, frame)
	end

	self:applySkin(frame, ...)

end

function Skinner:updateSBTexture()

	local c = self.db.profile.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	self.sbTexture = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)

	for _, statusBar in pairs(sbGlazed) do
		statusBar:SetStatusBarTexture(self.sbTexture)
		if statusBar.bg then
			if statusBar.bg:IsObjectType("StatusBar") then
				statusBar.bg:SetStatusBarTexture(self.sbTexture)
				statusBar.bg:SetStatusBarColor(unpack(self.sbColour))
			else
				statusBar.bg:SetTexture(self.sbTexture) -- handle backgrounds that aren't StatusBars
				statusBar.bg:SetVertexColor(unpack(self.sbColour))
			end
		end
		if statusBar.flash then statusBar.flash:SetTexture(self.sbTexture) end -- handle CastingBar Flash
	end

end

-- This function was copied from WoWWiki
-- http://www.wowwiki.com/RGBPercToHex
function Skinner:RGBPercToHex(r, g, b)

--	Check to see if the passed values are strings, if so then use some default values
	if type(r) == "string" then r, g, b = 0.8, 0.8, 0.0 end

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return string.format("%02x%02x%02x", r*255, g*255, b*255)

end

function Skinner:ShowInfo(obj, showKids, noDepth)

	local showKids = showKids and true or false

	local function print(fmsg, ...)

		local tmp = {}
		local output = "dbg:"

		fmsg = tostring(fmsg)
		if fmsg:find("%%") and select('#', ...) >= 1 then
			for i = 1, select('#', ...) do
				tmp[i] = tostring((select(i, ...)))
			end
			output = strjoin(" ", output, fmsg:format(unpack(tmp)))
		else
			tmp[1] = output
			tmp[2] = fmsg
			for i = 1, select('#', ...) do
				tmp[i + 2] = tostring((select(i, ...)))
			end
			output = table.concat(tmp, " ")
		end

		Skinner.debugFrame:AddMessage(output)

	end

	local function getRegions(object, lvl)

		for i = 1, object:GetNumRegions() do
			local v = select(i, object:GetRegions())
			print("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "<Anon>", v:GetObjectType() or "nil", v:GetWidth() or "nil", v:GetHeight() or "nil", v:GetObjectType() == "Texture" and string.format("%s : %s", v:GetTexture() or "nil", v:GetDrawLayer() or "nil") or "nil")
		end

	end

	local function getChildren(frame, lvl)

		if not showKids then return end
		if string.find(lvl, "-") == 2 and noDepth then return end

		for i = 1, frame:GetNumChildren() do
			local v = select(i, frame:GetChildren())
			local objType = v:GetObjectType()
			print("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "<Anon>", v:GetWidth() or "nil", v:GetHeight() or "nil", objType or "nil", v:GetFrameStrata() or "nil")
			if objType == "Frame" or objType == "Button" or objType == "StatusBar" or objType == "Slider" or objType == "ScrollFrame" then
				getRegions(v, lvl.."-"..i)
				getChildren(v, lvl.."-"..i)
			end
		end

	end

	print("%s : %s : %s : %s : %s : %s", obj:GetName() or "<Anon>", obj:GetWidth() or "nil", obj:GetHeight() or "nil", obj:GetObjectType() or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil")

	print("Started Regions")
	getRegions(obj, 0)
	print("Finished Regions")
	print("Started Children")
	getChildren(obj, 0)
	print("Finished Children")

end

--[[
	The following code is to handle moving the TradeSkillFrame/PlayerTalentFrame/MacroFrame when the SpellBookFrame is displayed to ensure that the SpellBookFrame Tabs are visible
]]--
local center = 345
local centerplus = 384
local right = 691
local sbfShown, mfShown, tsShown, tfShown, mfxOfs, tsxOfs, tfxOfs = 0, 0, 0, 0, 0, 0, 0
local function getFrameInfo()
	sbfShown = SpellBookFrame:IsShown()
	mfShown = MacroFrame and MacroFrame:IsShown() or 0
	mfxOfs = MacroFrame and select(4, MacroFrame:GetPoint()) or 0
	mfxOfs = math.floor(mfxOfs)
	tsShown = TradeSkillFrame and TradeSkillFrame:IsShown() or 0
	tsxOfs = TradeSkillFrame and select(4, TradeSkillFrame:GetPoint()) or 0
	tsxOfs = math.floor(tsxOfs)
	tfShown = PlayerTalentFrame and PlayerTalentFrame:IsShown() or 0
	tfxOfs = PlayerTalentFrame and select(4, PlayerTalentFrame:GetPoint()) or 0
	tfxOfs = math.floor(tfxOfs)
--	Skinner:Debug("getFrameInfo: [%s, %s, %s, %s, %s]", sbfShown, mfShown, mfxOfs, tsShown, tsxOfs)
end
Skinner:SecureHook("ShowUIPanel", function(frame, force)
	getFrameInfo()
--	Skinner:Debug("ShowUIPanel: [%s, %s]", frame:GetName() or "<Anon>", force)
	if MacroFrame and (frame == MacroFrame or frame == SpellBookFrame) then
		if mfShown and sbfShown and (mfxOfs == center or mfxOfs == right) then
			Skinner:moveObject(MacroFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
		if tsShown and sbfShown and tsxOfs == 345 then
			Skinner:moveObject(TradeSkillFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
	end
	if TradeSkillFrame and (frame == TradeSkillFrame or frame == SpellBookFrame) then
		if tsShown and sbfShown and tsxOfs == center then
			Skinner:moveObject(TradeSkillFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
		if mfShown then
		 	if sbfShown and mfxOfs == right then
				Skinner:moveObject(MacroFrame, "+", 40, nil, nil)
				getFrameInfo()
			elseif mfxOfs == centerplus then
				Skinner:moveObject(MacroFrame, "-", 40, nil, nil)
				getFrameInfo()
			end
		end
	end
	if PlayerTalentFrame and (frame == PlayerTalentFrame or frame == SpellBookFrame) then
		if tfShown and sbfShown and tfxOfs == center then
			Skinner:moveObject(PlayerTalentFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
	end
end)
Skinner:SecureHook("HideUIPanel", function(frame, skipSetPoint)
	if not frame then return end
	getFrameInfo()
--	Skinner:Debug("HideUIPanel: [%s, %s]", frame:GetName() or "<Anon>", skipSetPoint)
	if frame == MacroFrame then
		if tsShown and sbfShown and tsxOfs == center then
			Skinner:moveObject(TradeSkillFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
	end
	if frame == TradeSkillFrame then
		if mfShown and sbfShown and mfxOfs == center then
			Skinner:moveObject(MacroFrame, "+", 40, nil, nil)
			getFrameInfo()
		end
	end
end)
