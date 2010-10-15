if not Skinner:isAddonEnabled("Clique") then return end

function Skinner:Clique()
	if not self.db.profile.SpellBookFrame then return end

	-- Tab on SpellBook (side)
	self:removeRegions(CliqueSpellTab, {1})
	self:addButtonBorder{obj=CliqueSpellTab}

	-- Dialog Frame
	self:addSkinFrame{obj=CliqueDialog, kfs=true, x1=-3, y1=2, x2=1, y2=-3}

	-- Main frame
	self:skinDropDown{obj=CliqueConfigDropdown}
	self:addSkinFrame{obj=CliqueConfig, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-3}

	-- Configuration List
	self:skinFFColHeads("CliqueConfigPage1Column", 2)
	self:skinSlider{obj=CliqueConfig.page1.slider}
	self:skinButton{obj=CliqueConfig.page1.button_spell}
	self:skinButton{obj=CliqueConfig.page1.button_other}
	self:skinButton{obj=CliqueConfig.page1.button_options}
	-- Edit Page
	self:skinButton{obj=CliqueConfig.page2.button_binding}
	self:addSkinFrame{obj=CliqueClickGrabber}
	self:skinScrollBar{obj=CliqueScrollFrame}
	self:skinButton{obj=CliqueConfig.page2.button_save}
	self:skinButton{obj=CliqueConfig.page2.button_cancel}
	-- Alert Frame (GlowBox)
	self:addSkinFrame{obj=CliqueTabAlert, kfs=true, y1=3, x2=3}

end
