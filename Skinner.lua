
-- if the Debug library is available then use it
if AceLibrary:HasInstance("AceDebug-2.0") then
	Skinner = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceHook-2.1", "AceDebug-2.0", "FuBarPlugin-2.0")
--@alpha@
	Skinner:SetDebugging(true)
--@end-alpha@
	Skinner:SetDebugLevel(1)
else
	Skinner = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
	function Skinner:Debug() end
	function Skinner:LevelDebug() end
	function Skinner:IsDebugging() end
end

Skinner.L = AceLibrary("AceLocale-2.2"):new("Skinner")
Skinner.LT = AceLibrary("Tablet-2.0")
Skinner.LSM = AceLibrary("LibSharedMedia-3.0")

-- specify where debug messages go
Skinner.debugFrame = ChatFrame7

-- FuBar setup
Skinner.hasIcon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01"
Skinner.defaultMinimapPosition = 285
Skinner.clickableTooltip = false
Skinner.cannotDetachTooltip = true
Skinner.hasNoColor = true
Skinner.hideMenuTitle = true
Skinner.hideWithoutStandby = true
Skinner.independentProfile = true

--check to see if running on PTR
Skinner.isPTR = FeedbackUI and true or false
--check to see if running on WotLK
Skinner.isWotLK = GetCVarBool and true or false

function Skinner:addSkinButton(obj, parent, hookObj, hideBut)

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

	xOfs1 = xOfs1 or -3
	yOfs1 = yOfs1 or -3
	xOfs2 = xOfs2 or 3
	yOfs2 = yOfs2 or 3
	local skinFrame = CreateFrame("Frame", nil, parent)
	skinFrame:SetFrameStrata("BACKGROUND")
	skinFrame:ClearAllPoints()
	skinFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOfs1, yOfs1)
	skinFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", xOfs2, yOfs2)
	if not ftype then self:applySkin(skinFrame)
	else self:storeAndSkin(ftype, skinFrame) end
	parent.skinFrame = skinFrame

end

function Skinner:adjustTFOffset(reset)

	--	Adjust the UIParent TOP-OFFSET attribute if required
	if self.initialized.TopFrame then
		local topOfs	= -self.db.profile.TopFrame.height
		local UIPtopOfs = -104
		if topOfs < UIPtopOfs and not reset then
			UIParent:SetAttribute("TOP_OFFSET", topOfs)
		elseif UIParent:GetAttribute("TOP_OFFSET") < UIPtopOfs then
			UIParent:SetAttribute("TOP_OFFSET", UIPtopOfs)
		end
	end

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
--	self:Debug("aS - Frame, Fade Height: [%s, %s]", frame:GetName(), fh)

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
		for _, v in pairs({"Header", "_Header", "FrameHeader", "HeaderTexture"}) do
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

local eh = geterrorhandler()
function Skinner:checkAndRun(funcName)

--	self:Debug("checkAndRun:[%s]", funcName)

	-- handle errors from internal functions
	if type(self[funcName]) == "function" then
		local status, result = pcall(self[funcName], self)
		if status == false then
			eh(result)
			if self.db.profile.Errors then
				self:CustomPrint(1, 0, 0, nil, nil, nil, "Error running", funcName, result)
			end
		end
	else
		self:CustomPrint(1, 0, 0, nil, nil, nil, "function [", funcName, "] not found in Skinner")
	end

end

function Skinner:checkAndRunAddOn(addonName, LoD, addonFunc)

	if not addonFunc then addonFunc = addonName end

--	self:Debug("checkAndRunAddOn:[%s, %s, %s, %s]", addonName, LoD, IsAddOnLoaded(addonName), type(self[addonFunc]))

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
		local status, result
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not self[addonFunc] then
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, nil, nil, nil, addonName, "loaded but skin not found in SkinMe directory")
			end
		-- handle errors from internal functions
		elseif type(self[addonFunc]) == "function" then
--			self:Debug("checkAndRunAddOn#2:[%s, %s]", addonFunc, self[addonFunc])
			status, result = pcall(self[addonFunc], self)
		elseif type(self[addonFunc]) == "string" then
--			self:Debug("checkAndRunAddOn#3:[%s, %s]", addonFunc, self[addonFunc])
			-- add Skinner reference to string before running it
			status, result = pcall(function() return assert(loadstring("local self = Skinner "..self[addonFunc], addonFunc))() end)
			-- throw away the string if it doesn't have a hook in it
			if not string.match(self[addonFunc], "Hook[\(S]") then self[addonFunc] = nil end
			-- run the associated Hook function if there is one
			if self[addonFunc.."Hooks"] then
				status, result = pcall(function() return assert(loadstring("local self = Skinner "..self[addonFunc.."Hooks"], addonFunc))() end)
			end
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, nil, nil, nil, "function [", addonFunc, "] not found in Skinner")
			end
		end
		if status == false then
			eh(result)
			if self.db.profile.Errors then
				self:CustomPrint(1, 0, 0, nil, nil, nil, "Error running", addonFunc, result)
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
						for i = 1, select("#", obj:GetChildren()) do
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

--	self:Debug("findFrame2: [%s, %s, %s, %s, %s, %s, %s]", parent, objType, select(1, ...) or nil, select(2, ...) or nil, select(3, ...) or nil, select(4, ...) or nil, select(5, ...) or nil)

	local frame

	for i = 1, select("#", parent:GetChildren()) do
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

function Skinner:getChild(frame, childNo)

	if frame then return select(childNo, frame:GetChildren()) end

end

function Skinner:getRegion(frame, regNo)

	if frame then return select(regNo, frame:GetRegions()) end

end

function Skinner:glazeStatusBar(frame, fi)

	if not frame then return end

	if frame:GetFrameType() ~= "StatusBar" then return end
	frame:SetStatusBarTexture(self.sbTexture)

	if fi then
		if not frame.bg then frame.bg = CreateFrame("StatusBar", nil, frame) end
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", fi, -fi)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -fi, fi)
		frame.bg:SetFrameStrata(frame:GetFrameStrata() ~= "UNKNOWN" and frame:GetFrameStrata() or "BACKGROUND") -- handle Nameplate status bars
		frame.bg:SetFrameLevel((frame:GetFrameLevel() > 0 and frame:GetFrameLevel() - 1 or 0))
		frame.bg:SetStatusBarTexture(self.sbTexture)
		frame.bg:SetStatusBarColor(unpack(self.sbColour))
	end

end

local ddTex = "Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"
function Skinner:isDropDown(obj)

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

	if not frame then return end

--	self:Debug("keepFontStrings: [%s]", frame:GetName() or "???")

	for i = 1, select("#", frame:GetRegions()) do
		local reg = select(i, frame:GetRegions())
		if reg:GetObjectType() ~= "FontString" then
			reg:SetAlpha(0)
		end
	end

end

function Skinner:keepRegions(frame, regions)

	if not frame then return end

--	self:Debug("keepRegions: [%s]", frame:GetName() or "???")

	for i = 1, select("#", frame:GetRegions()) do
		local reg = select(i, frame:GetRegions())
		local keep
		if self:IsDebugging() and regions then
			if reg:GetObjectType() == "FontString" then self:LevelDebug(3, "kr FS: [%s, %s]", frame:GetName() or "nil", i) end
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

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	frame:EnableMouse(true)
	frame.draggingDirection = nil
	frame.cursorPosition = {}

	if not self:IsHooked(frame, "OnUpdate") then
		self:HookScript(frame, "OnUpdate", function(...)
			self.hooks[frame].OnUpdate(...)
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
		self:HookScript(frame, "OnMouseDown", function()
			self.hooks[frame].OnMouseDown()
			if arg1 == "LeftButton" then
				this.dragging = true
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:HookScript(frame, "OnMouseUp", function()
			self.hooks[frame].OnMouseUp()
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

	if not objName then return end
--	self:Debug("moveObject: [%s, %s%s, %s%s, %s]", objName:GetName(), xAdj, xDiff, yAdj, yDiff, relTo)

	local point, relativeTo, relativePoint, xOfs, yOfs = objName:GetPoint()
--	self:Debug("GetPoint: [%s, %s, %s, %s, %s]", point, relativeTo:GetName(), relativePoint, xOfs, yOfs)

	-- Workaround for yOfs crash when using bar addons
	if not yOfs then return end

	-- Workaround for relativeTo crash
	if not relativeTo then
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, nil, nil, nil, "moveObject (relativeTo) error:", objName, objName:GetName() or "???")
		end
		return
	end

	-- apply the adjustment
	if xAdj == nil then xOffset = xOfs else xOffset = (xAdj == "+" and xOfs + xDiff or xOfs - xDiff) end
	if yAdj == nil then yOffset = yOfs else yOffset = (yAdj == "+" and yOfs + yDiff or yOfs - yDiff) end

	if relTo == nil and relativeTo:GetName() then relTo = relativeTo:GetName() end

	objName:ClearAllPoints()
	objName:SetPoint(point, relTo, relativePoint, xOffset, yOffset)

end

function Skinner:removeRegions(frame, regions)

	if not frame then return end

--	self:Debug("removeRegions: [%s]", frame:GetName() or "???")

	for i = 1, select("#", frame:GetRegions()) do
		local reg = select(i, frame:GetRegions())
		if self:IsDebugging() and regions then
			if reg:GetObjectType() == "FontString" then self:LevelDebug(3, "rr FS: [%s, %s]", frame:GetName() or "nil", i) end
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
	if not self.isWotLK then
		nT = ((fN == "CharacterFrame" and not HasPetUI()) and 4 or frame.numTabs)
	else
		nT = ((fN == "CharacterFrame" and not CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
	end
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
		if self.isWotLK then PanelTemplates_TabResize(_G[tabName..i], 0)
		else PanelTemplates_TabResize(0, _G[tabName..i]) end
	end

end

function Skinner:setActiveTab(tabName)

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setActiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.gradientTexture)
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

function Skinner:setInactiveTab(tabName)

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setInactiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.LSM:Fetch("background", "Inactive Tab"))
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientTab))

end

function Skinner:setTTBackdrop(bdReqd)

	self:Debug("setTTBackdrop: [%s]", bdReqd)

	for _, tooltip in pairs(self.ttList) do
		self:Debug("sTTB: [%s]", tooltip)
		local ttip = _G[tooltip]
		if ttip then
			if bdReqd then ttip:SetBackdrop(self.backdrop)
			else ttip:SetBackdrop(nil) end
		end
	end

end

function Skinner:setTTBBC()

-- 	self:Debug("setTTBBC: [%s]", self.db.profile.Tooltips.border)

	if self.db.profile.Tooltips.border == 1 then
		return unpack(self.bbColour)
	else
		return unpack(self.tbColour)
	end

end

function Skinner:shrinkBag(frame, bpMF)

	if not frame then return end

	local frameName = frame:GetName()
	local mfAdjust = self.isWotLK and 22 or 18
	local bgTop = _G[frameName.."BackgroundTop"]
	if math.floor(bgTop:GetHeight()) == 256 then -- this is the backpack
--		self:Debug("Backpack found")
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[frameName.."MoneyFrame"]:GetPoint())
--			self:Debug("Backpack Money Frame found: [%s, %s]", yOfs, math.floor(yOfs))
			if math.floor(yOfs) == -216 or math.floor(yOfs) == -217 then -- is it still in its original position
--				self:Debug("Backpack Money Frame moved")
				self:moveObject(_G[frameName.."MoneyFrame"], nil, nil, "+", mfAdjust)
			end
		end
		if not self.isWotLK then
			if bpMF then
				frame:SetHeight(frame:GetHeight() - 20)
			else
				self:moveObject(_G[frameName.."Item1"], nil, nil, "-", 20)
				frame:SetHeight(frame:GetHeight() - 40)
			end
		else
			self:moveObject(_G[frameName.."Item1"], nil, nil, "+", 19)
		end
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

function Skinner:skinDropDown(frame, moveTexture, noSkin)

	if not frame then return end

	if not self.db.profile.TexturedDD or noSkin then self:keepFontStrings(frame) return end

	_G[frame:GetName().."Left"]:SetAlpha(0)
	_G[frame:GetName().."Right"]:SetAlpha(0)
	_G[frame:GetName().."Middle"]:SetTexture(self.LSM:Fetch("background", "Inactive Tab"))
	_G[frame:GetName().."Middle"]:SetHeight(19)

	self:moveObject(_G[frame:GetName().."Button"], "-", 6, "-", 2)
	self:moveObject(_G[frame:GetName().."Text"], nil, nil, "-", 2)

	if moveTexture then self:moveObject(_G[frame:GetName().."Middle"], nil, nil, "+", 2) end

end

function Skinner:skinEditBox(frame, regions, noSkin, noHeight)

	if not frame then return end

--	self:SetDebugging(true) -- Enable to identify additional text strings

	local kRegions = CopyTable(self.ebRegions)
	if regions then
		for _, v in pairs(regions) do
			table.insert(kRegions, v)
		end
	end

	self:keepRegions(frame, kRegions)
	local l, r, t, b = frame:GetTextInsets()
	frame:SetTextInsets(l + 5, r + 5, t, b)
	if not (noHeight or frame:IsMultiLine()) then frame:SetHeight(26) end
	frame:SetWidth(frame:GetWidth() + 5)

	if not noSkin then self:skinUsingBD2(frame) end

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

function Skinner:skinFFColHeads(buttonName)
--	self:Debug("skinFFColHeads: [%s]", buttonName)

	for i = 1, 4 do
		self:keepFontStrings(_G[buttonName..i])
		self:storeAndSkin(ftype, _G[buttonName..i])
	end

end

function Skinner:skinMoneyFrame(frame, moveGold, noWidth)

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
	end

end

function Skinner:skinScrollBar(scrollFrame, sbPrefix, sbObj, narrow)

	if not scrollFrame then return end
--	self:Debug("skinScrollBar: [%s, %s, %s, %s]", scrollFrame:GetName(), sbPrefix or 'nil', sbObj or 'nil', narrow or 'nil')

	local sBar = sbObj and sbObj or _G[scrollFrame:GetName()..(sbPrefix or "").."ScrollBar"]
	if narrow then
		self:skinUsingBD3(sBar)
	else
		self:skinUsingBD2(sBar)
	end

end

function Skinner:skinTooltip(frame)
	if not self.db.profile.Tooltips.skin then return end

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

	self.sbTexture = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)

	if self.db.profile.CharacterFrames then
		self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
		for i = 1 , NUM_FACTIONS_DISPLAYED do
			self:glazeStatusBar(_G["ReputationBar"..i], 0)
		end
		for i = 1, SKILLS_TO_DISPLAY do
			self:glazeStatusBar(_G["SkillRankFrame"..i], 0)
		end
		self:glazeStatusBar(SkillDetailStatusBar, 0)
	end

	if self.db.profile.TradeSkill then self:glazeStatusBar(TradeSkillRankFrame, 0) end

	if self.db.profile.CraftFrame then self:glazeStatusBar(CraftRankFrame, 0) end

	if self.db.profile.Tooltips.glazesb then self:glazeStatusBar(GameTooltipStatusBar, 0) end

	if self.db.profile.MirrorTimers.glaze then
		for i = 1, MIRRORTIMER_NUMTIMERS do
			self:glazeStatusBar(_G["MirrorTimer"..i.."StatusBar"], 0)
		end
	end

	if self.db.profile.CastingBar.glaze then
		self:glazeStatusBar(CastingBarFrame, 0)
		CastingBarFrameFlash:SetTexture(self.sbTexture)
	end

	if self.db.profile.GroupLoot.skin then
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			self:glazeStatusBar(_G["GroupLootFrame"..i.."Timer"], 0)
		end
	end

	if self.db.profile.ItemText then self:glazeStatusBar(ItemTextStatusBar, 0) end

	if IsMacClient() then self:glazeStatusBar(MovieProgressBar, 0) end

	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(MainMenuExpBar, 0)
		self:glazeStatusBar(ReputationWatchStatusBar, 0)
	end

	if self.db.profile.Nameplates then
		for i = 1, select("#", WorldFrame:GetChildren()) do
			local child = select(i, WorldFrame:GetChildren())
			if child.skinned then child.skinned = nil end
		end
	end

end

function Skinner:OnEnable()
--	self:Debug("OnEnable")

	self.initialized = {}

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")

	self:ScheduleEvent(self.BlizzardFrames, self.db.profile.Delay.Init, self)
	self:ScheduleEvent(self.SkinnerFrames, self.db.profile.Delay.Init + 0.1, self)
	self:ScheduleEvent(self.AddonFrames, self.db.profile.Delay.Init + self.db.profile.Delay.Addons + 0.1, self)

end

function Skinner:OnInitialize()
--	self:Debug("OnInitialize")

--	if self.isPTR then self:Debug("PTR detected") end
--	if self.isWotLK then self:Debug("WotLK detected") end

	-- register the SV database
	self:RegisterDB("SkinnerDB")

	-- setup the default DB values
	self:checkAndRun("Defaults")
	-- setup the Addon's options
	self:checkAndRun("Options")

	-- register the default background texture
	self.LSM:Register("background", "Blizzard ChatFrame Background", "Interface\\ChatFrame\\ChatFrameBackground")
	-- register the inactive tab texture
	self.LSM:Register("background", "Inactive Tab", "Interface\\AddOns\\Skinner\\textures\\inactive")
	-- register the EditBox/ScrollBar texture
	self.LSM:Register("border", "Skinner EditBox/ScrollBar Border", "Interface\\AddOns\\Skinner\\textures\\krsnik")

	-- update the Backdrop settings if required
	if self.db.profile.BdFile and self.db.profile.BdFile == "Interface\\ChatFrame\\ChatFrameBackground" then
		self.db.profile.BdTexture = "Blizzard ChatFrame Background"
		self.db.profile.BdFile = nil
	end
	if self.db.profile.BdEdgeFile and self.db.profile.BdEdgeFile == "Interface\\Tooltips\\UI-Tooltip-Border" then
		self.db.profile.BdBorderTexture = "Blizzard Tooltip"
		self.db.profile.BdEdgeFile = nil
	end

	-- update the Gradient Texture value
	if self.db.profile.Gradient.texture and self.db.profile.Gradient.texture == "Default" then
		self.db.profile.Gradient.texture = "Blizzard ChatFrame Background"
	end

	self:RegisterChatCommand({"/Skinner", "/skin"}, self.options)
	self.OnMenuRequest = self.options

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
	self.charKeys1 = {"CharacterFrames", "PetStableFrame", "SpellBookFrame", "TalentFrame", "DressUpFrame", "FriendsFrame", "TradeSkill", "CraftFrame", "TradeFrame", "RaidUI", "Buffs"}
	self.charKeys2 = {"QuestLog"}
	self.npcKeys = {"MerchantFrames", "GossipFrame", "ClassTrainer", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard"}
	self.uiKeys1 = {"StaticPopups", "ChatMenus", "ChatConfig", "ChatTabs", "ChatFrames", "LootFrame", "StackSplit", "ItemText", "Colours", "WorldMap", "HelpFrame", "KnowledgeBase", "Inspect", "BattleScore", "BattlefieldMm", "ScriptErrors", "Tutorial", "DropDowns", "MinimapButtons", "MinimapGloss", "MovieProgress", "MenuFrames", "BankFrame", "MailFrame", "AuctionFrame", "CoinPickup", "GMSurveyUI", "LFGFrame", "ItemSocketingUI", "GuildBankUI"}
	self.uiKeys2 = {"Tooltips", "MirrorTimers", "CastingBar", "ChatEditBox", "GroupLoot", "ContainerFrames", "MainMenuBar"}
	-- these are used to disable the gradient
	self.charFrames = {}
	self.uiFrames = {}
	self.npcFrames = {}
	self.skinnerFrames = {}

	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	self.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip"}
	if self.isWotLK then table.insert(self.ttCheck, "ShoppingTooltip3") end
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

	-- class table
	self.classTable = {"Druid", "Priest", "Paladin", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Warrior"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

end

function Skinner:OnTooltipUpdate()

	self.LT:SetHint(self.L["Right Click to display menu"])

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

function Skinner:ShowInfo(obj)

	local getKids = true

	local function p(fmsg, ...)

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

		for i = 1, select("#", object:GetRegions()) do
			local v = select(i, object:GetRegions())
			p("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "nil", v:GetObjectType() or "nil", v:GetWidth() or "nil", v:GetHeight() or "nil", v:GetObjectType() == "Texture" and string.format("%s : %s", v:GetTexture() or "nil", v:GetDrawLayer() or "nil") or "nil")
		end

	end

	local function getChildren(frame, lvl)
		if not getKids then return end

		for i = 1, select("#", frame:GetChildren()) do
			local v = select(i, frame:GetChildren())
			local objType = v:GetObjectType()
			p("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "nil", v:GetWidth() or "nil", v:GetHeight() or "nil", objType or "nil", v:GetFrameStrata() or "nil")
			if objType == "Frame" or objType == "Button" or objType == "StatusBar" then
				getRegions(v, lvl.."-"..i)
				getChildren(v, lvl.."-"..i)
			end
		end

	end

	p("%s : %s : %s : %s : %s : %s", obj:GetName() or "nil", obj:GetWidth()or "nil", obj:GetHeight()or "nil", obj:GetObjectType()or "nil", obj:GetFrameLevel()or "nil", obj:GetFrameStrata()or "nil")

	p("Started Regions")
	getRegions(obj, 1)
	p("Finished Regions")
	p("Started Children")
	getChildren(obj, 1)
	p("Finished Children")

end
