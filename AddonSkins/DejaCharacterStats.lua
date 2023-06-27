local _, aObj = ...
if not aObj:isAddonEnabled("DejaCharacterStats") then return end
local _G = _G

aObj.addonsToSkin.DejaCharacterStats = function(self) -- v R100100r2

	_G.CharacterStatsPane.ClassBackground:SetTexture(nil)
	self:skinObject("slider", {obj=_G.CharacterFrameInsetRightScrollBar})

	-- DCS_configButton (lock icon TRHS of papedoll frame)
	-- DCS_InterfaceOptConfigButton  (lock icon TRHS of IoF panel)

	if self.modBtns then
		-- self:changeLock(_G.DCS_configButton)
		-- _G.DCS_configButton:SetScale(0.5)
		-- self:RawHook(_G.DCS_configButton, "SetNormalTexture", function(this, tex)
		-- 	aObj:Debug("DCS_configButton SetNormalTexture: [%s, %s]", tex)
		-- 	if tex == [[Interface\\BUTTONS\\LockButton-Locked-Up]] then
		-- 		tex:SetTexCoord(0, 0.25, 0, 1.0)
		-- 	elseif tex == [[Interface\\BUTTONS\\LockButton-Unlocked-Down]] then
		-- 		tex:SetTexCoord(0.25, 0.5, 0, 1.0)
		-- 	end
		-- 	self.hooks[this].SetNormalTexture(this, self.tFDIDs.gAOI)
		-- end, true)
		-- self:moveObject{obj=_G.DCS_configButton, x=-20, y=12}
		self:skinStdButton{obj=_G.DCS_TableRelevantStats}
		self:skinStdButton{obj=_G.DCS_TableResetButton}
	end
	if self.modBtnBs then
		 self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-2, clr="gold"}
	end

	local statsFrame
	for _, child in _G.ipairs_reverse{_G.CharacterFrameInsetRight:GetChildren()} do
		if child:IsObjectType("ScrollFrame")
		and child:GetNumChildren() == 2
		then
			statsFrame = child:GetScrollChild()
			break
		end
	end
	if statsFrame then
		for _, frame in _G.ipairs{statsFrame:GetChildren()} do
			frame:DisableDrawLayer("BACKGROUND")
			if self.modChkBtns then
				if frame.checkButton then
					self:skinCheckButton{obj=frame.checkButton}
					frame.checkButton:SetSize(21, 21)
					frame.checkButton:SetScale(0.66)
				end
			end
		end
	end

	self.RegisterCallback("DejaCharacterStats", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "DejaCharacterStats" then return end
		self.iofSkinnedPanels[panel] = true
		for _, child in _G.ipairs{panel:GetChildren()} do
			if child:IsObjectType("CheckButton") then
				if self.modChkBtns then
					self:skinCheckButton{obj=child}
				end
			elseif child == _G.DCS_InterfaceOptConfigButton then
				if self.modBtns then
					-- self:changeLock(_G.DCS_InterfaceOptConfigButton)
				end
			elseif child:IsObjectType("Button") then
				if self.modBtns then
					self:skinStdButton{obj=child}
				end
			end
		end

		self.UnregisterCallback("DejaCharacterStats", "IOFPanel_Before_Skinning")
	end)

end
