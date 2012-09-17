local aName, aObj = ...
if not aObj:isAddonEnabled("REFlex") then return end

function aObj:REFlex()

	self:SecureHook("REFlex_MainTabShow", function()
		for i = 1, 9 do
			if REFlexNamespace["MainTable"..i] then
				self:skinScrollBar{obj=REFlexNamespace["MainTable"..i].scrollframe}
				self:addSkinFrame{obj=REFlexNamespace["MainTable"..i].frame}
			end
		end
		self:Unhook("REFlex_MainTabShow")
	end)
	
	self:addSkinFrame{obj=REFlex_MainTab, hdr=true, y1=2}
	-- MainTab Tabs
	self:skinTabs{obj=REFlex_MainTab, lod=true, x1=6, y1=0, x2=-6, y2=2}
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
	-- Tab7 Frame
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxDF, regs={9}}
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxMF, regs={9}}
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxYF, regs={9}}
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxDT, regs={9}}
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxMT, regs={9}}
	self:skinEditBox{obj=REFlex_MainTab_Tab7_SearchBoxYT, regs={9}}
	-- SpecHolder tabs
	self:skinTabs{obj=REFlex_MainTab_SpecHolder, lod=true, x1=6, y1=0, x2=-6, y2=2}
	
-->>-- Export Tab frame
	self:skinScrollBar{obj=REFlex_ExportTab_Panel}
	self:addSkinFrame{obj=REFlex_ExportTab, hdr=true}

end
