local _, aObj = ...
if not aObj:isAddonEnabled("MissingTradeSkillsList") then return end
local _G = _G

aObj.addonsToSkin.MissingTradeSkillsList = function(self) -- v 1.13.51

	if self.modBtns then
		self:skinStdButton{obj=_G.MTSLUI_ToggleButton}
	end

	local mtsl = _G.MTSLUI_MISSING_TRADESKILLS_FRAME

	self:SecureHookScript(mtsl.ui_frame, "OnShow", function(this)
		self:skinObject("editbox", {obj=mtsl.skill_list_filter_frame.ui_frame.search_box})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.source_drop_down})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.phase_drop_down})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.faction_drop_down})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.specialisation_drop_down})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.continent_drop_down})
		self:skinObject("dropdown", {obj=mtsl.skill_list_filter_frame.ui_frame.zone_drop_down})
		self:skinObject("slider", {obj=mtsl.skill_list_frame.ui_frame.slider.ui_frame.slider, x1=5, x2=-6})
		self:skinObject("frame", {obj=mtsl.skill_list_frame.ui_frame, fb=true})
		self:skinObject("frame", {obj=mtsl.skill_detail_frame.ui_frame, fb=true})
		self:keepFontStrings(mtsl.progressbar.ui_frame.progressbar.ui_frame.counter)
		self:skinStatusBar{obj=mtsl.progressbar.ui_frame.progressbar.ui_frame.texture, fi=0}
		self:skinObject("frame", {obj=this})
		if self.modBtns then
			self:skinStdButton{obj=mtsl.skill_list_filter_frame.ui_frame.search_btn}
		end

		self:Unhook(this, "OnShow")
	end)

end
