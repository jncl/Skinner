local aName, aObj = ...
if not aObj:isAddonEnabled("Enchantrix-Barker") then return end

function aObj:EnchantrixBarker()
	if self.initialized.EnchantrixBarker then return end
	self.initialized.EnchantrixBarker = true

	self:SecureHookScript(Enchantrix_BarkerOptions_Frame, "OnShow", function(this)
		self:addSkinFrame{obj=this, kfs=true, x1=10, y1=-11, x2=-33, y2=70}
		-- Tabs
		for i = 1, this.numTabs do
			tab = _G["Enchantrix_BarkerOptions_FrameTab"..i]
			self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
			-- set textures here first time thru
			if i == 1 then
				if self.isTT then self:setActiveTab(tabSF) end
			else
				if self.isTT then self:setInactiveTab(tabSF) end
			end
		end
		self.tabFrames[this] = true
		self:Unhook(Enchantrix_BarkerOptions_Frame, "OnShow")
	end)

	-- Tab on TradeSkill Frame
	self:keepRegions(Enchantrix_BarkerOptions_TradeTab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
	local tabSF = self:addSkinFrame{obj=Enchantrix_BarkerOptions_TradeTab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
	if self.isTT then self:setActiveTab(tabSF) end

end
