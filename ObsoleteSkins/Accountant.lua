
function Skinner:Accountant()

	AccountantFrame:SetWidth(AccountantFrame:GetWidth() * self.FxMult)
	AccountantFrame:SetHeight(AccountantFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(AccountantFrame)
	self:moveObject(AccountantFrameTitleText, nil, nil, "+", 10)
	self:moveObject(AccountantFrameCloseButton, "+", 30, "+", 8)
	self:moveObject(AccountantFrameResetButton, "-", 4, "+", 2)
	self:moveObject(AccountantMoneyFrame, nil, nil, "-", 75)
	self:moveObject(AccountantFrameExitButton, "+", 32, "-", 8)
	self:applySkin(AccountantFrame)
	-- Tabs
	for i = 1, 5 do
		local tabName = _G["AccountantFrameTab"..i]
		if i == 1 then
			self:moveObject(tabName, "-", 10, "-", 71)
		elseif i == 5 then
			self:moveObject(tabName, "+", 35, "-", 71)
		else
			self:moveObject(tabName, "+", 8, nil, nil)
		end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName)
			else self:setInactiveTab(tabName) end
		else self:applySkin(tabName) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("AccountantTab_OnClick", function()
			for i = 1, 5 do
				local tabName = _G["AccountantFrameTab"..i]
				if i == AccountantFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>--	Options Frame
	self:keepFontStrings(AccountantOptionsFrame)
	self:skinDropDown(AccountantOptionsFrameWeek)
	self:applySkin(AccountantOptionsFrame, true)

end
