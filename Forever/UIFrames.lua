local _, aObj = ...

local _G = _G

aObj.SetupForever_UIFrames = function()
	local ftype = "u"

	aObj.blizzLoDFrames[ftype].BoostTutorial = function(self)
		if not self.prdb.TutorialUI or self.initialized.BoostTutorial then return end
		self.initialized.BoostTutorial = true

		self:skinTutorialFrame(_G.NPE_TutorialKeyboardMouseFrame_Frame, ftype)
		self:skinTutorialFrame(_G.NPE_TutorialInterfaceHelp, ftype)

	end

	aObj.blizzLoDFrames[ftype].NewPlayerExperience = function(self)
		if not self.prdb.TutorialUI or self.initialized.NewPlayerExperience then return end
		self.initialized.NewPlayerExperience = true

		self:skinTutorialFrame(_G.TutorialKeyboardMouseFrame_Frame, ftype)
		self:skinTutorialFrame(_G.TutorialWalk_Frame, ftype)

		if self.modBtns then
			self:skinStdButton{obj=_G.KeyboardMouseConfirmButton, ofs=0}
			self:skinStdButton{obj=_G.SkipTutorialButton, ofs=0}
		end

	end

end

aObj.SetupForever_UIFramesOptions = function(_)

end

aObj.SetupForever_UIFramesDefaults = function(_)

end
