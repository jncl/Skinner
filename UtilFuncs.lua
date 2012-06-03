local aName, aObj = ...
local _G = _G
local obj, objName, texName, btn, btnName, tab, tabSF

local function makeString(t)

	if type(t) == "table" then
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s:%s>"):format(tostring(t), t:GetObjectType(), t:GetName() or "(Anon)")
		end
	end

	return tostring(t)

end
local function makeText(a1, ...)

	local tmpTab = {}
	local output = ""

	if a1:find("%%") and select('#', ...) >= 1 then
		for i = 1, select('#', ...) do
			tmpTab[i] = makeString(select(i, ...))
		end
		output = output .. " " .. a1:format(unpack(tmpTab))
	else
		tmpTab[1] = output
		tmpTab[2] = a1
		for i = 1, select('#', ...) do
			tmpTab[i+2] = makeString(select(i, ...))
		end
		output = table.concat(tmpTab, " ")
	end

	return output

end
local function printIt(text, frame, r, g, b)

	(frame or DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b, 1, 5)

end
--@debug@
function printTS(...)
	print(("[%s.%03d]"):format(date("%H:%M:%S"), (GetTime() % 1) * 1000), ...)
end
local output
function aObj:Debug(a1, ...)

	output = ("|cff7fff7f(DBG) %s:[%s.%03d]|r"):format(aName, date("%H:%M:%S"), (GetTime() % 1) * 1000)

	printIt(output.." "..makeText(a1, ...), self.debugFrame)

end
--@end-debug@
--[===[@non-debug@
function aObj:Debug() end
--@end-non-debug@]===]

function aObj:CustomPrint(r, g, b, a1, ...)

	output = ("|cffffff78"..aName..":|r")

	printIt(output.." "..makeText(a1, ...), nil, r, g, b)

end

--@debug@
local function print_family_tree(fName)
	local lvl = "Parent"
	print(makeText("Frame is %s, %s, %s, %s, %s", fName, fName:GetFrameLevel(), fName:GetFrameStrata(), aObj.round2(fName:GetWidth(), 2) or "nil", aObj.round2(fName:GetHeight(), 2) or "nil"))
	while fName:GetParent() do
		fName = fName:GetParent()
		print(makeText("%s is %s, %s, %s, %s, %s", lvl, fName, (fName:GetFrameLevel() or "<Anon>"), (fName:GetFrameStrata() or "<Anon>"), aObj.round2(fName:GetWidth(), 2) or "nil", aObj.round2(fName:GetHeight(), 2) or "nil"))
		lvl = (lvl:find("Grand") and "Great" or "Grand")..lvl
	end
end
function aObj:SetupCmds()

	-- define some helpful slash commands (ex Baddiel)
	self:RegisterChatCommand("rl", function(msg) ReloadUI() end)
	self:RegisterChatCommand("lo", function(msg) Logout() end)
	self:RegisterChatCommand("pl", function(msg) print(msg, "is", gsub(select(2, GetItemInfo(msg)), "|", "||"))	end)
	self:RegisterChatCommand("ft", function() print_family_tree(GetMouseFocus()) end)
	self:RegisterChatCommand("ftp", function() print_family_tree(GetMouseFocus():GetParent()) end)
	self:RegisterChatCommand("si", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), true, false) end)
	self:RegisterChatCommand("sid", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), true, true) end) -- detailed
	self:RegisterChatCommand("sib", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus(), false, false) end) -- brief
	self:RegisterChatCommand("sip", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus():GetParent(), true, false) end)
	self:RegisterChatCommand("sipb", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus():GetParent(), false, false) end)
	self:RegisterChatCommand("sigp", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus():GetParent():GetParent(), true, false) end)
	self:RegisterChatCommand("sigpb", function(msg) self:ShowInfo(_G[msg] or GetMouseFocus():GetParent():GetParent(), false, false) end)
	self:RegisterChatCommand("gp", function(msg) print(GetMouseFocus():GetPoint()) end)
	self:RegisterChatCommand("gpp", function(msg) print(GetMouseFocus():GetParent():GetPoint()) end)
	self:RegisterChatCommand("sp", function(msg) return Spew and Spew("xyz", _G[msg]) end)

end
--@end-debug@

local function errorhandler(err)
	return geterrorhandler()(err)
end
local success, err
local function safecall(funcName, LoD, quiet)
	-- handle errors from internal functions
	success, err = xpcall(function() return aObj[funcName](aObj, LoD) end, errorhandler)
	if quiet then
--		print(funcName, success, err)
		return success, err
	end
	if not success then
		if aObj.db.profile.Errors then
			aObj:CustomPrint(1, 0, 0, "Error running", funcName)
		end
	end
end

function aObj:add2Table(table, value)

	table[#table + 1] = value

end

function aObj:checkAndRun(funcName, quiet)

	if type(self[funcName]) == "function" then
		return safecall(funcName, nil, quiet)
	else
		if not quiet and self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, "function ["..funcName.."] not found in "..aName)
		end
	end

end

function aObj:checkAndRunAddOn(addonName, LoD, addonFunc)

	if not addonFunc then addonFunc = addonName end

	-- don't skin any Addons whose skins are flagged as disabled
	if self.db.profile.DisabledSkins[addonName] then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, addonName, "not skinned, flagged as disabled")
		end
		return
	end

	if not IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if IsAddOnLoadOnDemand(addonName) and not LoD then
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
			safecall(addonFunc, LoD)
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "function ["..addonFunc.."] not found in "..aName)
			end
		end
	end

end

function aObj:changeShield(shldReg, iconReg)

	shldReg:SetTexture([[Interface\CastingBar\UI-CastingBar-Arena-Shield]])
	shldReg:SetTexCoord(0, 1, 0, 1)
	shldReg:SetWidth(46)
	shldReg:SetHeight(46)
	-- move it behind the icon
	shldReg:ClearAllPoints()
	shldReg:SetPoint("CENTER", iconReg, "CENTER", 9, -1)

end

function aObj:findFrame(height, width, children)
	-- find frame by matching children's object types

	local kids, frame, matched = {}
	obj = EnumerateFrames()

	while obj do

		if obj:IsObjectType("Frame") then
			if obj:GetName() == nil then
				if obj:GetParent() == nil then
					if self.round2(obj:GetHeight(), 2) == height and self.round2(obj:GetWidth(), 2) == width then
						kids = {}
						for _, child in pairs{obj:GetChildren()} do
							kids[#kids + 1] = child:GetObjectType()
						end
						matched = 0
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

function aObj:findFrame2(parent, objType, ...)
--@alpha@
	assert(parent, "Unknown object\n"..debugstack())
--@end-alpha@

	if not parent then return end

	local frame, point, relativeTo, relativePoint, xOfs, yOfs, height, width

	for _, child in pairs{parent:GetChildren()} do
		if child:GetName() == nil then
			if child:IsObjectType(objType) then
				if select("#", ...) > 2 then
					-- base checks on position
					point, relativeTo, relativePoint, xOfs, yOfs = child:GetPoint()
					-- self:Debug("ff2 GetPoint: [%s, %s, %s, %s, %s, %s]", child, point, relativeTo, relativePoint, xOfs, yOfs)
					xOfs = xOfs and self.round2(xOfs, 2) or 0
					yOfs = yOfs and self.round2(yOfs, 2) or 0
					if	point		  == select(1, ...)
					and relativeTo	  == select(2, ...)
					and relativePoint == select(3, ...)
					and xOfs		  == select(4, ...)
					and yOfs		  == select(5, ...) then
						frame = child
						break
					end
				else
					-- base checks on size
					height, width = self.round2(child:GetHeight(), 2), self.round2(child:GetWidth(), 2)
					-- self:Debug("ff2 h/w: [%s, %s, %s]", child, height, width)
					if	height == select(1, ...)
					and width  == select(2, ...) then
						frame = child
						break
					end
				end
			end
		end
	end

	return frame

end

function aObj:findFrame3(name, element)
--@alpha@
	assert(name, "Unknown object\n"..debugstack())
--@end-alpha@

	local frame

	for _, child in pairs{UIParent:GetChildren()} do
		if child:GetName() == name then
			if child[element] then
				frame = child
				break
			end
		end
	end

	return frame

end

function aObj:getChild(obj, childNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	if obj and childNo then return (select(childNo, obj:GetChildren())) end

end

function aObj:getFirstChildOfType(obj, oType)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	for _, child in ipairs{obj:GetChildren()} do
		if child:IsObjectType(oType) then return child end
	end

end

function aObj:getRegion(obj, regNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	if obj and regNo then return (select(regNo, obj:GetRegions())) end

end

function aObj:isAddonEnabled(addonName)

	return (select(4, GetAddOnInfo(addonName))) or IsAddOnLoadOnDemand(addonName) -- handle LoD Addons (config mainly)

end

function aObj:isDropDown(obj)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	local tex
	if obj:GetName() then tex = _G[obj:GetName().."Left"] end

	if obj:IsObjectType("Frame")
	and tex
	and tex.GetTexture
	and tex:GetTexture():find("CharacterCreate") then
		return true
	else
		return false
	end

end

function aObj:isVersion(addonName, verNoReqd, actualVerNo)

	local hasMatched = false

	if type(verNoReqd) == "table" then
		for _, v in ipairs(verNoReqd) do
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
		self:CustomPrint(1, 0.25, 0.25, "Version", actualVerNo, "of", addonName, "is unsupported.", addText)
	end

	return hasMatched

end

function aObj:removeInset(frame)

	frame:DisableDrawLayer("BACKGROUND")
	frame:DisableDrawLayer("BORDER")

end

function aObj:removeMagicBtnTex(btn)

	-- Magic Button textures
	if btn.LeftSeparator then btn.LeftSeparator:SetAlpha(0) end
	if btn.RightSeparator then btn.RightSeparator:SetAlpha(0) end

end

function aObj:resizeTabs(frame)

	local fN = frame:GetName()
	local tabName = fN.."Tab"
	local nT
	-- get the number of tabs
	nT = ((frame == CharacterFrame and not CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
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
	tlw = ("%.2f"):format(tlw >= 6 and tlw or 5.5)
	-- update each tab
	for i = 1, nT do
		_G[tabName..i.."Left"]:SetWidth(tlw)
		PanelTemplates_TabResize(_G[tabName..i], 0)
	end

end

function aObj:resizeEmptyTexture(texture)

	texture:SetTexture(self.esTex)
	texture:SetWidth(64)
	texture:SetHeight(64)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", texture:GetParent())

end

function aObj.round2(num, ndp)

  return tonumber(("%." .. (ndp or 0) .. "f"):format(num))

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
			if k == bg then tex:SetVertexColor(sb.r, sb.g, sb.b, sb.a) end
		end
	end

end

-- This function was copied from WoWWiki
-- http://www.wowwiki.com/RGBPercToHex
function aObj:RGBPercToHex(r, g, b)

--	Check to see if the passed values are strings, if so then use some default values
	if type(r) == "string" then r, g, b = 0.8, 0.8, 0.0 end

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return ("%02x%02x%02x"):format(r*255, g*255, b*255)

end

function aObj:ShowInfo(obj, showKids, noDepth)

--@alpha@
	assert(obj, "Unknown object ShowInfo\n"..debugstack())
--@end-alpha@

	if not obj then return end

	local showKids = showKids or false

	local function showIt(fmsg, ...)

		printIt("dbg:"..makeText(fmsg, ...), aObj.debugFrame)

	end

	local function getRegions(obj, lvl)

		for k, reg in ipairs{obj:GetRegions()} do
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, k, reg, reg:GetObjectType() or "nil", reg.GetWidth and self.round2(reg:GetWidth(), 2) or "nil", reg.GetHeight and self.round2(reg:GetHeight(), 2) or "nil", reg:GetObjectType() == "Texture" and ("%s : %s"):format(reg:GetTexture() or "nil", reg:GetDrawLayer() or "nil") or "nil")
		end

	end

	local function getChildren(frame, lvl)

		if not showKids then return end
		if type(lvl) == "string" and lvl:find("-") == 2 and noDepth then return end

		for k, child in ipairs{frame:GetChildren()} do
			local objType = child:GetObjectType()
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, k, child, child.GetWidth and aObj.round2(child:GetWidth(), 2) or "nil", child.GetHeight and aObj.round2(child:GetHeight(), 2) or "nil", child:GetFrameLevel() or "nil", child:GetFrameStrata() or "nil")
			if objType == "Frame"
			or objType == "Button"
			or objType == "StatusBar"
			or objType == "Slider"
			or objType == "ScrollFrame"
			then
				getRegions(child, lvl.."-"..k)
				getChildren(child, lvl.."-"..k)
			end
		end

	end

	showIt("%s : %s : %s : %s : %s", obj, self.round2(obj:GetWidth(), 2) or "nil", self.round2(obj:GetHeight(), 2) or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil")

	showIt("Started Regions")
	getRegions(obj, 0)
	showIt("Finished Regions")
	showIt("Started Children")
	getChildren(obj, 0)
	showIt("Finished Children")

end

-- -- Event Handling (added for oGlow, not longer required 1.6.12)
-- -- This will allow for multiple occurrences of the same event to be managed
-- local eventFrame = CreateFrame("Frame")
-- local eventsTable = setmetatable({}, {__index = function(t, k) rawset(t, k, {}) return rawget(t, k) end})
-- eventFrame:SetScript("OnEvent", function(this, event, ...)
-- 	-- aObj:Debug("OnEvent: [%s, %s]", event, ... or nil)
-- 	for _, func in ipairs(eventsTable[event]) do
-- 		-- aObj:Debug("OnEvent#2: [%s]", func)
-- 		func(aObj, event, ...)
-- 	end
-- end)
-- function aObj:RegisterEvent(event, func)
-- 	eventsTable[event][#eventsTable[event]+1] = func or aObj[event]
-- 	if #eventsTable[event] == 1 then eventFrame:RegisterEvent(event) end
-- 	-- self:Debug("RegisterEvent: [%s, %s, %s]", event, func or aObj[event], #eventsTable[event])
-- 	return #eventsTable[event]
-- end
-- function aObj:UnregisterEvent(event, funcNum)
-- 	-- self:Debug("UnregisterEvent: [%s, %s]", event, funcNum)
-- 	if funcNum then
-- 		eventsTable[event][funcNum] = nil
-- 	else
-- 		for i, v in ipairs(eventsTable[event]) do
-- 			if v == aObj[event] then
-- 				v = nil
-- 				break
-- 			end
-- 		end
-- 	end
-- end
