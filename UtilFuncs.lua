local aName, aObj = ...
local _G = _G

local assert, debugstack, ipairs, pairs, select, type, print = _G.assert, _G.debugstack, _G.ipairs, _G.pairs, _G.select, _G.type, _G.print
local GetMouseFocus = _G.GetMouseFocus

local function makeString(t)

	if type(t) == "table" then
		if type(_G.rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s:%s>"):format(_G.tostring(t), t:GetObjectType(), t:GetName() or "(Anon)")
		end
	end

	return _G.tostring(t)

end
local function makeText(a1, ...)

	local tmpTab = {}
	local output = ""

	if a1
	and a1.find
	and a1:find("%%")
	and select('#', ...) >= 1
	then
		for i = 1, select('#', ...) do
			tmpTab[i] = makeString(select(i, ...))
		end
		tmpTab[#tmpTab + 1] = "nil" -- handle 1 missing variable
		output = output .. " " .. a1:format(_G.unpack(tmpTab))
	else
		tmpTab[1] = output
		tmpTab[2] = a1 and type(a1) == "table" and makeString(a1) or a1 or ""
		for i = 1, select('#', ...) do
			tmpTab[i + 2] = makeString(select(i, ...))
		end
		output = _G.table.concat(tmpTab, " ")
	end

	tmpTab = nil
	return output

end
local function printIt(text, frame, r, g, b)

	(frame or _G.DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b)

end
--@debug@
local function print_family_tree(fName)

	if fName:IsForbidden() then
		print("Frame access is forbidden")
		return
	end

	local lvl = "Parent"
	print(makeText("Frame is %s, %s, %s, %s, %s", fName, fName:GetFrameLevel(), fName:GetFrameStrata(), aObj:getInt(fName:GetWidth()) or "nil", aObj:getInt(fName:GetHeight()) or "nil"))
	while fName:GetParent() do
		fName = fName:GetParent()
		print(makeText("%s is %s, %s, %s, %s, %s", lvl, fName, (fName:GetFrameLevel() or "<Anon>"), (fName:GetFrameStrata() or "<Anon>"), aObj:getInt(fName:GetWidth()) or "nil", aObj:getInt(fName:GetHeight()) or "nil"))
		lvl = (lvl:find("Grand") and "Great" or "Grand") .. lvl
	end
	lvl = nil

end

local function getObjFromString(input)
    -- first split the string on "."
    local words = {}
    for w in _G.string.gmatch(input, "%a+") do
        words[#words + 1] = w
    end
    -- then build string in the form _G["str1"]["str2"]...["strn"]
    local objString = "_G"
    for i = 1, #words do
        objString = objString .. '["' .. words[i] .. '"]'
    end
    -- finally use loadstring to get the object from the command
    -- print("getObjFromString", input, objString)
    return assert(_G.loadstring("return " .. objString)())
end
function aObj:SetupCmds()

	local function getObj(input)
        -- print("getObj", input, _G[input], GetMouseFocus())
		if not input or input:trim() == "" then
			return GetMouseFocus()
		else
            return getObjFromString(input)
        end
	end
	local function getObjP(input)
		-- print("getObjP", input, _G[input], GetMouseFocus():GetParent())
		if not input or input:trim() == "" then
			return GetMouseFocus():GetParent()
		else
            return getObjFromString(input)
        end
	end
	local function getObjGP(input)
		-- print("getObjGP", input, _G[input], GetMouseFocus():GetParent():GetParent())
		if not input or input:trim() == "" then
			return GetMouseFocus():GetParent():GetParent()
		else
            return getObjFromString(input)
        end
	end
	-- define some helpful slash commands (ex Baddiel)
	self:RegisterChatCommand("rl", function() _G.ReloadUI() end)
	self:RegisterChatCommand("lo", function() _G.Logout() end)
	self:RegisterChatCommand("pin", function(msg) print(msg, "is item:", (_G.GetItemInfoFromHyperlink(msg))) end)
	self:RegisterChatCommand("pii", function(msg) print(_G.GetItemInfo(msg)) end)
	self:RegisterChatCommand("pil", function(msg) print(_G.gsub(msg, "\124", "\124\124")) end)
	self:RegisterChatCommand("ft", function() print_family_tree(GetMouseFocus()) end)
	self:RegisterChatCommand("ftp", function() print_family_tree(GetMouseFocus():GetParent()) end)
	self:RegisterChatCommand("sid", function(msg) self:ShowInfo(getObj(msg), true, false) end) -- detailed
	self:RegisterChatCommand("si1", function(msg) self:ShowInfo(getObj(msg), true, true) end) -- 1 level only
	self:RegisterChatCommand("sir", function(msg) self:ShowInfo(getObj(msg), false, false) end) -- regions only
	self:RegisterChatCommand("sidp", function(msg) self:ShowInfo(getObjP(msg), true, false) end) -- detailed
	self:RegisterChatCommand("si1p", function(msg) self:ShowInfo(getObjP(msg), true, true) end) -- 1 level only
	self:RegisterChatCommand("sirp", function(msg) self:ShowInfo(getObjP(msg), false, false) end) -- regions only
	self:RegisterChatCommand("sidgp", function(msg) self:ShowInfo(getObjGP(msg), true, false) end) -- detailed
	self:RegisterChatCommand("si1gp", function(msg) self:ShowInfo(getObjGP(msg), true, false) end) -- 1 level only
	self:RegisterChatCommand("sirgp", function(msg) self:ShowInfo(getObjGP(msg), false, false) end) -- regions only
	self:RegisterChatCommand("gp", function() print(GetMouseFocus():GetPoint()) end)
	self:RegisterChatCommand("gpp", function() print(GetMouseFocus():GetParent():GetPoint()) end)
	self:RegisterChatCommand("sspew", function(msg) return _G.Spew and _G.Spew(msg, getObj(msg)) end)
	self:RegisterChatCommand("sspewp", function(msg) return _G.Spew and _G.Spew(msg, getObjP(msg)) end)
	self:RegisterChatCommand("sspewgp", function(msg) return _G.Spew and _G.Spew(msg, getObjGP(msg)) end)

	self:RegisterChatCommand("wai", function()
		_G.SetMapToCurrentZone()
		local x, y=_G.GetPlayerMapPosition("player")
		_G.DEFAULT_CHAT_FRAME:AddMessage(_G.format("%s, %s: %.1f, %.1f", _G.GetZoneText(), _G.GetSubZoneText(), x * 100, y * 100))
		x, y = nil, nil
		return
	end)

end

function aObj:printTS(...)

	print(("[%s.%03d]"):format(_G.date("%H:%M:%S"), (_G.GetTime() % 1) * 1000), ...)

end

-- specify where debug messages go
aObj.debugFrame = _G.ChatFrame10
function aObj:Debug(a1, ...)

	local output = ("|cff7fff7f(DBG) %s:[%s.%03d]|r"):format(aName, _G.date("%H:%M:%S"), (_G.GetTime() % 1) * 1000)
	printIt(output .. " " .. makeText(a1, ...), self.debugFrame)
	output = nil

end

aObj.debug2 = false
function aObj:Debug2(...)

	if aObj.debug2 then self:Debug(...) end

end
--@end-debug@

--[===[@non-debug@
aObj.debugFrame = nil
function aObj:Debug() end
function aObj:Debug2() end
--@end-non-debug@]===]

function aObj:CustomPrint(r, g, b, a1, ...)

	printIt("|cffffff78" .. aName .. ":|r" .. " " .. makeText(a1, ...), nil, r, g, b)

end

local errorhandler = _G.geterrorhandler()
local function safecall(funcName, funcObj, LoD, quiet)
-- local function safecall(funcName, LoD, quiet)
--@alpha@
	assert(funcObj, "Unknown object safecall\n" .. debugstack())
--@end-alpha@

	-- aObj:Debug("safecall: [%s, %s, %s, %s]", funcName, funcObj, LoD, quiet)

	-- handle errors from internal functions
	local success, err = _G.xpcall(function() return funcObj(aObj, LoD) end, errorhandler)
	-- local success, err = _G.xpcall(function() return aObj[funcName](aObj, LoD) end, errorhandler)
	if quiet then
		return success, err
	end
	if not success then
		if aObj.db.profile.Errors then
			aObj:CustomPrint(1, 0, 0, "Error running", funcName)
		end
	end

end

function aObj:add2Table(table, value)
--@alpha@
	assert(table, "Unknown table add2Table\n" .. debugstack())
	assert(value, "Missing value add2Table\n" .. debugstack())
--@end-alpha@

	table[#table + 1] = value

end

function aObj:checkAndRun(funcName, funcType, LoD, quiet)
--@alpha@
	assert(funcName, "Unknown functionName checkAndRun\n" .. debugstack())
	assert(funcType, "Unknown functionType checkAndRun\n" .. debugstack())
--@end-alpha@

	-- self:Debug("checkAndRun: [%s, %s, %s, %s]", funcName, funcType, LoD, quiet)

	-- handle in combat
	if _G.InCombatLockdown() then
		self:add2Table(self.oocTab, {self.checkAndRun, {self, funcName, funcType, LoD, quiet}})
		return
	end

	-- setup function's table object to use
	local tObj
	if funcType == "s" then tObj = self
	else tObj = LoD and self["blizzLoDFrames"][funcType] or self["blizzFrames"][funcType]
	end

	-- only skin frames if required
	if (funcType == "n" and self.db.profile.DisableAllNPC)
	or (funcType == "p" and self.db.profile.DisableAllP)
	or (funcType == "u" and self.db.profile.DisableAllUI)
	or (funcType == "s" and (self.db.profile.DisabledSkins[funcName] or self.db.profile.DisableAllAS))
	then
		tObj[funcName] = nil
		return
	else
		if type(tObj[funcName]) == "function" then
			return safecall(funcName, tObj[funcName], nil, quiet)
		else
			if not quiet and self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "function [" .. funcName .. "] not found in " .. aName)
			end
		end
	end

end

function aObj:checkAndRunAddOn(addonName, LoD, addonFunc)
--@alpha@
	assert(addonName, "Unknown object checkAndRunAddOn\n" .. debugstack())
--@end-alpha@

	-- self:Debug("checkAndRunAddOn: [%s, %s, %s]", addonName, LoD, addonFunc)

	-- handle in combat
	if _G.InCombatLockdown() then
		self:add2Table(self.oocTab, {self.checkAndRunAddOn, {self, addonName, LoD, addonFunc}})
		return
	end

	if not addonFunc then addonFunc = addonName end

	-- don't skin any Addons whose skins are flagged as disabled
	if self.db.profile.DisabledSkins[addonName]
	or self.db.profile.DisableAllAS
	then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as disabled (c&RA)")
		end
		self[addonFunc] = nil
		return
	end

	-- aObj:Debug("checkAndRunAddOn #2: [%s, %s, %s]", _G.IsAddOnLoaded(addonName), _G.IsAddOnLoadOnDemand(addonName), self[addonFunc])

	if not _G.IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if _G.IsAddOnLoadOnDemand(addonName) and not LoD then
			self.lmAddons[addonName:lower()] = addonFunc -- store with lowercase addonname (AddonLoader fix)
		-- Nil out loaded Skins for Addons that aren't loaded
		elseif self[addonFunc] then
			self[addonFunc] = nil
		end
	else
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not self[addonFunc] then
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, addonName, "loaded but skin not found in the SkinMe directory")
			end
		elseif type(self[addonFunc]) == "function" then
			return safecall(addonName, self[addonFunc], LoD)
			-- return safecall(addonFunc, LoD)
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "function [" .. addonName .. "] not found in " .. aName)
			end
		end
	end

end

function aObj:checkLoadable(addonName)

	local name, title, notes, loadable, reason, security, newVersion = _G.GetAddOnInfo(addonName)
	-- aObj:Debug("checkLoadable: [%s, %s, %s, %s, %s, %s, %s]", name, title, notes, loadable, reason, security, newVersion)
	if not loadable then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as:", reason, "(cL)")
		end
	end

	return loadable

end


aObj.lvlBG = [[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]]
function aObj:changeTandC(obj, tex)
--@alpha@
	assert(obj, "Unknown object changeTandC\n" .. debugstack())
--@end-alpha@

	obj:SetTexture(tex)
	obj:SetTexCoord(0, 1, 0, 1)

end

aObj.shieldTex = [[Interface\CastingBar\UI-CastingBar-Arena-Shield]]
function aObj:changeShield(shldReg, iconReg)
--@alpha@
	assert(shldReg, "Unknown object changeShield\n" .. debugstack())
	assert(iconReg, "Unknown object changeShield\n" .. debugstack())
--@end-alpha@

	self:changeTandC(shldReg, self.shieldTex)
	shldReg:SetSize(44, 44)
	-- move it behind the icon
	shldReg:ClearAllPoints()
	shldReg:SetPoint("CENTER", iconReg, "CENTER", 9, -1)

end

aObj.RecTex = [[Interface\HelpFrame\HelpButtons]]
function aObj:changeRecTex(obj, isYellow, isUnitFrame)

	obj:SetTexture(self.RecTex)
	if isYellow then
		obj:SetTexCoord(isUnitFrame and 0.015 or 0.0038, isUnitFrame and 0.66 or 0.7, 0.67, 0.855) -- yellow
	else
		obj:SetTexCoord(0.0038, 0.7, 0.004, 0.205) -- blue
	end

end

function aObj:findFrame(height, width, children)
	-- find frame by matching children's object types

	local frame
	local obj = _G.EnumerateFrames()

	while obj do

		if obj.IsObjectType -- handle object not being a frame !?
		and obj:IsObjectType("Frame")
		then
			if obj:GetName() == nil then
				if obj:GetParent() == nil then
					if self:getInt(obj:GetHeight()) == height
					and self:getInt(obj:GetWidth()) == width
					then
						local kids = {}
						for _, child in pairs{obj:GetChildren()} do
							kids[#kids + 1] = child:GetObjectType()
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

		obj = _G.EnumerateFrames(obj)
	end

	return frame

end

function aObj:findFrame2(parent, objType, ...)
--@alpha@
	assert(parent, "Unknown object findFrame2\n" .. debugstack())
--@end-alpha@

	if not parent then return end

	local frame, cKey

	local kids = {parent:GetChildren()}
	for key, child in pairs(kids) do
		-- check for forbidden objects (StoreUI components)
		if not child:IsForbidden() then
			if child:GetName() == nil then
				if child:IsObjectType(objType) then
					if select("#", ...) > 2 then
						-- base checks on position
						local point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint()
						-- self:Debug("ff2 GetPoint: [%s, %s, %s, %s, %s, %s]", child, point, relativeTo, relativePoint, xOfs, yOfs)
						xOfs = xOfs and self:getInt(xOfs) or 0
						yOfs = yOfs and self:getInt(yOfs) or 0
						if	point		  == select(1, ...)
						and relativeTo	  == select(2, ...)
						and relativePoint == select(3, ...)
						and xOfs		  == select(4, ...)
						and yOfs		  == select(5, ...) then
							frame, cKey = child, key
							break
						end
					else
						-- base checks on size
						local height, width = self:getInt(child:GetHeight()), self:getInt(child:GetWidth())
						-- self:Debug("ff2 h/w: [%s, %s, %s]", child, height, width)
						if	height == select(1, ...)
						and width  == select(2, ...) then
							frame, cKey = child, key
							break
						end
					end
				end
			end
		end
	end
	kids = nil

	return frame, cKey

end

function aObj:getChild(obj, childNo)
--@alpha@
	assert(obj, "Unknown object getChild\n" .. debugstack())
--@end-alpha@

	if obj and childNo then return (select(childNo, obj:GetChildren())) end

end

function aObj:getInt(num)
--@alpha@
	assert(num, "Missing number\n" .. debugstack())
--@end-alpha@

	return _G.math.floor(num + 0.5)

end

function aObj:round2(num, idp)
	--@alpha@
		assert(num, "Missing number\n" .. debugstack())
	--@end-alpha@

  return _G.tonumber(_G.string.format("%." .. (idp or 0) .. "f", num))

end

function aObj:getRegion(obj, regNo)
--@alpha@
	assert(obj, "Unknown object getRegion\n" .. debugstack())
	assert(regNo, "Missing value getRegion\n" .. debugstack())
--@end-alpha@

	if obj and regNo then return (select(regNo, obj:GetRegions())) end

end

function aObj:hasTextInName(obj, text)
--@alpha@
	assert(obj, "Unknown object hasTextInName\n" .. debugstack())
	assert(text, "Missing value hasTextInName\n" .. debugstack())
--@end-alpha@

	return obj and obj.GetName and obj:GetName() and obj:GetName():find(text) and true or false

end

function aObj:hasAnyTextInName(obj, tab)
--@alpha@
	assert(obj, "Unknown object hasAnyTextInName\n" .. debugstack())
	assert(tab, "Missing value hasAnyTextInName\n" .. debugstack())
--@end-alpha@

	if obj
	and obj.GetName
	and obj:GetName()
	then
		local oName = obj:GetName()
		for _, text in pairs(tab) do
			if oName:find(text) then return true end
		end
	end

	return false

end

function aObj:hasTextInTexture(obj, text, plain)
--@alpha@
	-- assert(obj, "Unknown object hasTextInTexture\n" .. debugstack()) -- N.B. allow for missing texture object
	assert(text, "Missing value hasTextInTexture\n" .. debugstack())
--@end-alpha@

	return obj and obj.GetTexture and obj:GetTexture() and _G.tostring(obj:GetTexture()):find(text, 1, plain) and true

end

-- populate addon Index table first time through
local addonIdx, uName = {}, _G.UnitName("player")
local name, title, notes, loadable, reason, security, newVersion
do
	for i = 1, _G.GetNumAddOns() do
		name, title, notes, loadable, reason, security, newVersion = _G.GetAddOnInfo(i)
		addonIdx[name] = i
		-- _G.print(i, name, title, notes, loadable, reason, security, newVersion)
		-- handle special case (Beta vs Live)
		if name == "spew" then
			addonIdx["Spew"] = addonIdx["spew"]
			addonIdx["spew"] = nil
		end
	end
end

function aObj:isAddonEnabled(addonName)
--@alpha@
	assert(addonName, "Unknown object isAddonEnabled\n" .. debugstack())
--@end-alpha@

	if addonIdx[addonName] then
		return (_G.GetAddOnEnableState(uName, addonIdx[addonName]) > 0) or _G.IsAddOnLoadOnDemand(addonName)
	end

end

function aObj:isDropDown(obj)
--@alpha@
	assert(obj, "Unknown object isDropDown\n" .. debugstack())
--@end-alpha@

	if obj:IsObjectType("Frame")
	and obj:GetName()
	then
		return self:hasTextInTexture(_G[obj:GetName() .. "Left"], "CharacterCreate")
	end

end

function aObj:removeInset(frame)
--@alpha@
	assert(frame, "Unknown object removeInset\n" .. debugstack())
--@end-alpha@

	frame:DisableDrawLayer("BACKGROUND")
	frame:DisableDrawLayer("BORDER")

end

function aObj:removeMagicBtnTex(btn)
--@alpha@
	assert(btn, "Unknown object removeMagicBtnTex\n" .. debugstack())
--@end-alpha@

	-- Magic Button textures
	if btn.LeftSeparator then btn.LeftSeparator:SetTexture(nil) end
	if btn.RightSeparator then btn.RightSeparator:SetTexture(nil) end

end

function aObj:resizeTabs(frame)
--@alpha@
	assert(frame, "Unknown object resizeTabs\n" .. debugstack())
--@end-alpha@

	local tabName = frame:GetName() .. "Tab"
	-- get the number of tabs
	local nT = ((frame == _G.CharacterFrame and not _G.CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
	-- accumulate the tab text widths
	local tTW = 0
	for i = 1, nT do
		tTW = tTW + _G[tabName .. i .. "Text"]:GetWidth()
	end
	-- add the tab side widths
	tTW = tTW + (40 * nT)
	-- get the frame width
	local fW = frame:GetWidth()
	-- calculate the Tab left width
	local tlw = (tTW > fW and (40 - (tTW - fW) / nT) / 2 or 20)
	-- set minimum left width
	tlw = ("%.2f"):format(tlw >= 6 and tlw or 5.5)
	-- update each tab
	for i = 1, nT do
		_G[tabName .. i .. "Left"]:SetWidth(tlw)
		_G.PanelTemplates_TabResize(_G[tabName .. i], 0)
	end

end

function aObj:resizeEmptyTexture(texture)
--@alpha@
	assert(texture, "Unknown object resizeEmptyTexture\n" .. debugstack())
--@end-alpha@

	texture:SetTexture(self.esTex)
	texture:SetSize(64, 64)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", texture:GetParent())

end

function aObj:scanUIParentsChildren()

	-- scan through all UIParent's children, firing events for each one
	-- this allows skins to check the children as required
	local retOK, ret1
	local kids = {_G.UIParent:GetChildren()}
	for _, child in ipairs(kids) do
		-- check for forbidden objects (StoreUI components)
		if not child:IsForbidden() then
			self.callbacks:Fire("UIParent_GetChildren", child)
-- --@alpha@
--         else
--             -- N.B. use print as Debug function causes taint
--             print("ignoring forbidden object [%s]", child)
-- --@end-alpha@
		end
	end
	kids = nil

	-- remove all callbacks for this event
	self.callbacks.events["UIParent_GetChildren"] = nil

end

function aObj:scanWorldFrameChildren()

	-- scan through all UIParent's children, firing events for each one
	-- this allows skins to check the children as required
	local kids = {_G.WorldFrame:GetChildren()}
	for _, child in ipairs(kids) do
		self.callbacks:Fire("WorldFrame_GetChildren", child)
	end
	kids = nil

	-- remove all callbacks for this event
	self.callbacks.events["WorldFrame_GetChildren"] = nil

end
function aObj:toggleTabDisplay(tab, active)

	if active then
		if self.isTT then
			self:setActiveTab(tab.sf)
		else
			-- HIGHLIGHT_FONT_COLOR is white
			tab.Text:SetVertexColor(_G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
		end
	else
		if self.isTT then
			self:setInactiveTab(tab.sf)
		else
			-- NORMAL_FONT_COLOR is yellow
			tab.Text:SetVertexColor(_G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)
		end
	end

end

function aObj:updateSBTexture()

	-- get updated colour/texture
	local sb = self.db.profile.StatusBar
	self.sbColour = {sb.r, sb.g, sb.b, sb.a}
	self.sbTexture = self.LSM:Fetch("statusbar", sb.texture)

	for statusBar, tab in pairs(self.sbGlazed) do
		statusBar:SetStatusBarTexture(self.sbTexture)
		for k, tex in pairs(tab) do
			tex:SetTexture(self.sbTexture)
			if k == "bg" then tex:SetVertexColor(sb.r, sb.g, sb.b, sb.a) end
		end
	end

end

-- This function was copied from WoWWiki
-- http://www.wowwiki.com/RGBPercToHex
function aObj:RGBPercToHex(r, g, b)
--@alpha@
	assert(r, "Missing value (red) - RGBPercToHex\n" .. debugstack())
	assert(g, "Missing value (green) - RGBPercToHex\n" .. debugstack())
	assert(b, "Missing value (blue) - RGBPercToHex\n" .. debugstack())
--@end-alpha@

--	Check to see if the passed values are strings, if so then use some default values
	if type(r) == "string" then r, g, b = 0.8, 0.8, 0.0 end

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return ("%02x%02x%02x"):format(r*255, g*255, b*255)

end

function aObj:RaiseFrameLevelByFour(frame)

	frame:SetFrameLevel(frame:GetFrameLevel() + 4)

end

function aObj:ShowInfo(obj, showKids, noDepth)

    -- print("ShowInfo:", obj, showKids, noDepth)

--@alpha@
	assert(obj, "Unknown object ShowInfo\n" .. debugstack())
--@end-alpha@

	showKids = showKids or false

	local function showIt(fmsg, ...)

		printIt("dbg:" .. makeText(fmsg, ...), aObj.debugFrame)

	end

	local function getRegions(obj, lvl)

        local regs = {obj:GetRegions()}
        for k, reg in ipairs(regs) do
			showIt("[lvl%sr%s : %s : %s : %s : %s : %s]", lvl, k, reg, reg:GetObjectType() or "nil", reg.GetWidth and self:getInt(reg:GetWidth()) or "nil", reg.GetHeight and self:getInt(reg:GetHeight()) or "nil", reg:GetObjectType() == "Texture" and ("%s : %s"):format(reg:GetTexture() or "nil", reg:GetDrawLayer() or "nil") or "nil")
        end
        regs = nil

	end

	local function getChildren(frame, lvl)

		if not showKids then return end
		if type(lvl) == "string" and lvl:find("c") == 2 and noDepth then return end

        local kids = {frame:GetChildren()}
        for k, child in ipairs(kids) do
			local objType = child:GetObjectType()
			showIt("[lvl%sc%s : %s : %s : %s : %s : %s]", lvl, k, child, child.GetWidth and aObj:getInt(child:GetWidth()) or "nil", child.GetHeight and aObj:getInt(child:GetHeight()) or "nil", child:GetFrameLevel() or "nil", child:GetFrameStrata() or "nil")
			if objType == "Frame"
			or objType == "Button"
			or objType == "StatusBar"
			or objType == "Slider"
			or objType == "ScrollFrame"
			then
				getRegions(child, lvl .. "c" .. k)
				getChildren(child, lvl .. "c" .. k)
			end
        end
        kids = nil

	end

	showIt("%s : %s : %s : %s : %s : %s : %s", obj, self:getInt(obj:GetWidth()) or "nil", self:getInt(obj:GetHeight()) or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil", obj:GetNumRegions(), obj:GetNumChildren())

	showIt("Started Regions")
	getRegions(obj, 0)
	showIt("Finished Regions")
	showIt("Started Children")
	getChildren(obj, 0)
	showIt("Finished Children")

end
