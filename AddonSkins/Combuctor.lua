
function Skinner:Combuctor()
	if not self.db.profile.ContainerFrames.skin then return end

	-- Bags
	CombuctorFrame1:SetWidth(CombuctorFrame1:GetWidth() * self.FxMult)
	CombuctorFrame1:SetHeight(CombuctorFrame1:GetHeight() * self.FyMult)
	self:moveObject(CombuctorFrame1Title, nil, nil, "+", 10)
	self:moveObject(CombuctorFrame1CloseButton, "+", 29, "+", 8)
	self:keepFontStrings(CombuctorFrame1)
	self:skinEditBox(CombuctorFrame1Search, {9})
	self:moveObject(CombuctorFrame1Search, "-", 12, "+", 10)
	self:moveObject(CombuctorFrame1.itemFrame, "-", 10, "+", 10)
	self:moveObject(CombuctorFrame1.bagButtons[1], "+", 34, "+", 12)
	self:moveObject(CombuctorFrame1.qualityFilter, nil, nil, "-", 60)
	self:moveObject(CombuctorFrame1MoneyFrame, "+", 40, "-", 59)
	self:applySkin(CombuctorFrame1)
	-- Filters
	for i = 0, #CombuctorFrame1.cats - 1 do
		local CIF = _G["CombuctorItemFilter"..i]
		self:removeRegions(CIF, {1})
	end
	self:moveObject(CombuctorItemFilter0, "+", 30, nil, nil)

	-- Bank
	CombuctorFrame2:SetWidth(CombuctorFrame2:GetWidth() * self.FxMult + 30)
	CombuctorFrame2:SetHeight(CombuctorFrame2:GetHeight() * self.FyMult)
	self:moveObject(CombuctorFrame2Title, nil, nil, "+", 10)
	self:moveObject(CombuctorFrame2CloseButton, "+", 29, "+", 8)
	self:keepFontStrings(CombuctorFrame2)
	self:skinEditBox(CombuctorFrame2Search, {9})
	self:moveObject(CombuctorFrame2Search, "-", 12, "+", 10)
	self:moveObject(CombuctorFrame2.itemFrame, "-", 10, "+", 10)
	self:moveObject(CombuctorFrame2.bagButtons[1], "+", 30, "+", 12)
	self:moveObject(CombuctorFrame2.qualityFilter, nil, nil, "-", 60)
	self:moveObject(CombuctorFrame2MoneyFrame, "+", 40, "-", 59)
	self:applySkin(CombuctorFrame2)
	-- Filters
	for i = #CombuctorFrame1.cats, #CombuctorFrame1.cats + #CombuctorFrame2.cats - 1 do
		local CIF = _G["CombuctorItemFilter"..i]
		self:removeRegions(CIF, {1})
	end
	self:moveObject(_G["CombuctorItemFilter"..#CombuctorFrame1.cats], "+", 30, nil, nil)

	-- if Bagnon_Forever loaded
	if BagnonDB then -- show the player portrait, used to select player info
		CombuctorFrame1Icon:SetAlpha(1)
		CombuctorFrame1Icon:SetDrawLayer("ARTWORK")
		CombuctorFrame2Icon:SetAlpha(1)
		CombuctorFrame2Icon:SetDrawLayer("ARTWORK")
	else
		self:keepFontStrings(CombuctorFrame1IconButton)
		self:keepFontStrings(CombuctorFrame2IconButton)
	end
	-- Tabs
	local function skinTabs(frame)

		for i = 1, #frame.tabs do
			local tabName = _G[frame:GetName().."Tab"..i]
			if i == frame.selectedTab then Skinner:setActiveTab(tabName)
			else Skinner:setInactiveTab(tabName) end
		end

	end

	self:SecureHook(CombuctorFrame.obj, "CreateTab", function(this, id)
--		self:Debug("CFo_CT: [%s, %s]", this:GetName(), id)
		local tabName = _G[this:GetName().."Tab"..id]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if not self:IsHooked(tabName, "OnClick") then
				self:HookScript(tabName, "OnClick", function(this)
					self.hooks[this].OnClick(this)
					skinTabs(this:GetParent())
				end)
			end
		else self:applySkin(tabName) end
		if id == 1 then self:moveObject(tabName, "-", 25, "-", 56)
		else self:moveObject(tabName, "+", 10, nil, nil) end
	end)
	if self.db.profile.TexturedTab then
		self:SecureHook(CombuctorFrame.obj, "SetCategory", function(this, category)
--			self:Debug("CFo_SC: [%s, %s, %s, %s]", this:GetName(), category.name, this.selectedTab, #this.tabs)
			skinTabs(this)
		end)
	end

	-- Bag buttons
	self:SecureHook(CombuctorFrame.obj, "UpdateBagFrame", function(this)
--		self:Debug("CFo_UBF: [%s, %s]", this, this:GetName())
		self:moveObject(this.bagButtons[1], "+", 30, "+", 10)
	end)

end
