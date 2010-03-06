
function Skinner:PlusOneTable()

-->>-- Frame1
	self:skinAllButtons{obj=Frame1}
	self:applySkin{obj=Frame1, kfs=true}
-->>-- Toggle Window (LOOT ROLL TYPE)
	self:skinAllButtons{obj=ToggleWindow}
	self:applySkin{obj=ToggleWindow, kfs=true}
-->>-- Options Window (SAVE)
	self:skinAllButtons{obj=OptionsWindow}
	self:applySkin{obj=OptionsWindow, kfs=true}
-->>-- Loading Window (LOAD)
	self:skinAllButtons{obj=LoadingWindow}
	self:applySkin{obj=LoadingWindow, kfs=true}

end
