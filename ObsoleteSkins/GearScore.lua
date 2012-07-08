local aName, aObj = ...
if not aObj:isAddonEnabled("GearScore") then return end

function aObj:GearScore()

	-- Main Button Control Frame
	self:addSkinFrame{obj=TenTonHammer_ControlFrame, kfs=true, ofs=-7}

	-- Display frame
	self:addSkinFrame{obj=TenTonHammer_TitleFrame, kfs=true, ofs=-7}
	TenTonHammer_EquipmentFrame_Model:SetBackdrop(nil)
	TenTonHammer_EquipmentFrame_Model:SetScript("OnUpdate", nil) -- remove existing script
	self:makeMFRotatable(TenTonHammer_EquipmentFrame_Model)
	self:addSkinFrame{obj=TenTonHammer, kfs=true, ofs=-7, y2=3}
	-- Options frame
	self:skinDropDown{obj=TenTonHammer_Frame6_ThemeColor}

	-- Tabs
	for i = 1, TenTonHammer.numTabs do
		local tabObj = _G["TenTonHammerTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
		if i == 3 then -- option tab
			self:moveObject{obj=tabObj, x=-10}
			tabObj:SetHeight(32)
		end
	end
	self.tabFrames[TenTonHammer] = true

	-- Popup Frame
	self:addSkinFrame{obj=TenTonHammer_PopupFrame}

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then TenTonHammerTooltip:SetBackdrop(self.Backdrop[1]) end
		if self.db.profile.Tooltips.style == 3 then TenTonHammerTooltip2:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(TenTonHammerTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(TenTonHammerTooltip2, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
