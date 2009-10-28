
function Skinner:PlusOneTable()

-->>-- Frame1
	local kids = {Frame1:GetChildren()}
	for _, child in ipairs(kids) do
		if child:IsObjectType("Button") then
			self:skinButton{obj=child}
		end
	end
	self:applySkin{obj=Frame1, kfs=true}
-->>-- Toggle Window (LOOT ROLL TYPE)
	local kids = {ToggleWindow:GetChildren()}
	for _, child in ipairs(kids) do
		if child:IsObjectType("Button") then
			self:skinButton{obj=child}
		end
	end
	self:applySkin{obj=ToggleWindow, kfs=true}
-->>-- Options Window (SAVE)
	local kids = {OptionsWindow:GetChildren()}
	for _, child in ipairs(kids) do
		if child:IsObjectType("Button") then
			self:skinButton{obj=child}
		end
	end
	self:applySkin{obj=OptionsWindow, kfs=true}
-->>-- Loading Window (LOAD)
	local kids = {LoadingWindow:GetChildren()}
	for _, child in ipairs(kids) do
		if child:IsObjectType("Button") then
			self:skinButton{obj=child}
		end
	end
	self:applySkin{obj=LoadingWindow, kfs=true}
	kids = nil

end
