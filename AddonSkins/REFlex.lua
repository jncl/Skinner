local aName, aObj = ...
if not aObj:isAddonEnabled("REFlex") then return end

function aObj:REFlex()

	self:SecureHook("REFlex_MainTabShow", function()
		for i = 1, 8 do
			if REFlexNamespace["MainTable"..i] then
				self:skinScrollBar{obj=REFlexNamespace["MainTable"..i].scrollframe}
				self:addSkinFrame{obj=REFlexNamespace["MainTable"..i].frame}
			end
		end
		self:Unhook("REFlex_MainTabShow")
	end)
	
	self:addSkinFrame{obj=REFlex_MainTab, hdr=true}
	-- MainTab Tabs
	for i = 1, REFlex_MainTab.numTabs do
		tab = _G["REFlex_MainTabTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		-- set textures here first time thru
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[REFlex_MainTab] = true
	-- Tab4 Frame
	self:skinDropDown{obj=REFlex_MainTab_Tab4_DropDown}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolderSpecial}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP}
	self:glazeStatusBar(REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I, 0,  nil)
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor}
	self:glazeStatusBar(REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I, 0,  nil)
	self:glazeStatusBar(REFlex_MainTab_Tab4_Bar_I, 0,  nil)
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_Bar}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder1}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder2}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder3}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder4}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder5}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder6}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder7}
	self:addSkinFrame{obj=REFlex_MainTab_Tab4_ScoreHolder8}
	-- Tab5 Frame
	self:skinDropDown{obj=REFlex_MainTab_Tab5_DropDown}
	self:skinEditBox{obj=REFlex_MainTab_Tab5_SearchBox, regs={9}}
	-- Tab6 Frame
	self:skinDropDown{obj=REFlex_MainTab_Tab6_DropDown}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolderSpecial}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP}
	self:glazeStatusBar(REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I, 0,  nil)
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor}
	self:glazeStatusBar(REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_I, 0,  nil)
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolder1}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolder2}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolder3}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolder4}
	self:addSkinFrame{obj=REFlex_MainTab_Tab6_ScoreHolder5}
	-- SpecHolder tabs
	for i = 1, REFlex_MainTab_SpecHolder.numTabs do
		tab = _G["REFlex_MainTab_SpecHolderTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		-- set textures here first time thru
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[REFlex_MainTab_SpecHolder] = true
	
-->>-- Export Tab frame
	self:skinScrollBar{obj=REFlex_ExportTab_Panel}
	self:addSkinFrame{obj=REFlex_ExportTab, hdr=true}

end
