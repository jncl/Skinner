local aName, aObj = ...
if not aObj:isAddonEnabled("ClassTrainerPlus") then return end
local _G = _G

aObj.addonsToSkin.ClassTrainerPlus = function(self) -- v 0.5-beta

	self:SecureHookScript(_G.ClassTrainerPlusFrame, "OnShow", function(this)
		self:keepFontStrings(_G.ClassTrainerPlusExpandButtonFrame)
		self:skinDropDown{obj=_G.ClassTrainerPlusFrameFilterDropDown}
		self:skinEditBox{obj=_G.ClassTrainerPlusSearchBox, mi=true, regs={1, 6, 7}} -- 6 is text
		self:skinSlider{obj=_G.ClassTrainerPlusListScrollFrame.ScrollBar, rt="background"}
		self:skinSlider{obj=_G.ClassTrainerPlusDetailScrollFrame.ScrollBar, rt="background"}
		_G.ClassTrainerPlusSkillIcon:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-31, y2=70}
		if self.modBtns then
			self:skinCloseButton{obj=_G.ClassTrainerPlusFrameCloseButton}
			self:skinStdButton{obj=_G.ClassTrainerPlusTrainButton}
			self:skinStdButton{obj=_G.ClassTrainerPlusCancelButton}
			self:skinExpandButton{obj=_G.ClassTrainerPlusCollapseAllButton, onSB=true}
			for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
				self:skinExpandButton{obj=_G["ClassTrainerPlusSkill" .. i], onSB=true}
			end
			self:SecureHook("ClassTrainerPlusFrame_Update", function()
				for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
					self:checkTex{obj=_G["ClassTrainerPlusSkill" .. i]}
				end
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ClassTrainerPlusSkillIcon}
		end

		self:Unhook(this, "OnShow")
	end)


end
