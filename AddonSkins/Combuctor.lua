
function Skinner:Combuctor()
	if not self.db.profile.ContainerFrames.skin then return end

	-- skin Inventory & Bank frames
	for i = 1, 2 do
		local frame = _G["CombuctorFrame"..i]
		local frameResize = _G["CombuctorFrame"..i.."Resize"]
		self:moveObject(frame.title, nil, nil, "+", 10)
		self:moveObject(_G["CombuctorFrame"..i.."CloseButton"], "+", 29, "+", 8)
		self:keepFontStrings(frame)
		self:skinEditBox(frame.nameFilter, {9})
		frame.nameFilter:ClearAllPoints()
		frame.nameFilter:SetPoint("TOPLEFT", frame, "TOPLEFT", 84, -30)
		frame.nameFilter:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -84, -30)
		frame.itemFrame:SetWidth(frame.itemFrame:GetWidth() + 20)
		frame.itemFrame:SetHeight(frame.itemFrame:GetHeight() + 60)
		self:moveObject(frame.bagButtons[1], "+", 30, "+", 4)
		self:moveObject(frame.qualityFilter, nil, nil, "-", 60)
		self:moveObject(frame.moneyFrame, "+", 40, "-", 59)
		frameResize:ClearAllPoints()
		frameResize:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
		self:applySkin(frame)
	end
	
	-- Tabs aka BottomFilter
	local function skinTabs(frame)
	
--		self:Debug("skinTabs:[%s, %s]", frame:GetName(), frame.selectedTab)

		for i = 1, #frame.buttons do
			local tabObj = frame.buttons[i]
			if i == frame.selectedTab then Skinner:setActiveTab(tabObj)
			else Skinner:setInactiveTab(tabObj) end
		end

	end

	self:SecureHook(Combuctor.BottomFilter, "UpdateFilters", function(this)
--		self:Debug("C.BF_UF: [%s]", this:GetName())
		for i = 1, #this.buttons do
			local tabObj = this.buttons[i]
			if not self.skinned[tabObj] then
				if i == 1 then
					self:moveObject(tabObj, nil, nil, "-", 55)
				else
					self:moveObject(tabObj, "+", 11, nil, nil)
				end 
				self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
				if self.db.profile.TexturedTab then
					self:applySkin(tabObj, nil, 0, 1)
					if i == 1 then self:setActiveTab(tabObj)
					else self:setInactiveTab(tabObj) end
				else self:applySkin(tabObj) end
				if not self:IsHooked(tabObj, "OnClick") then
					self:SecureHookScript(tabObj, "OnClick", function(this)
						skinTabs(this:GetParent())
					end)
				end
			end
			if self.db.profile.TexturedTab then
				if i == 1 then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end
	end)

	-- Side Tabs aka SideFilter
	self:SecureHook(Combuctor.SideFilter, "UpdateFilters", function(this)
--		self:Debug("C.SF_UF: [%s]", this:GetName())
		for i = 1, #this.buttons do
			local tabObj = this.buttons[i]
			if not self.skinned[tabObj] then
				if i == 1 then
					self:moveObject(tabObj, "+", 30, "+", 20)
				else
					self:moveObject(tabObj, nil, nil, "+", 10)
				end 
				self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
			end
		end
	end)

	-- Item Frame Size Change
	self:SecureHook(Combuctor.Frame, "UpdateItemFrameSize", function(this)
--		self:Debug("CF_UIFS: [%s, %s, %s]", this:GetName(), this.itemFrame:GetWidth(), this.itemFrame:GetHeight())
		this.itemFrame:SetWidth(this.itemFrame:GetWidth() + 20)
		this.itemFrame:SetHeight(this.itemFrame:GetHeight() + 60)
		this.itemFrame:RequestLayout()
	end)

	-- Bag buttons
	self:SecureHook(Combuctor.Frame, "UpdateBagFrame", function(this)
--		self:Debug("CF_UBF: [%s, %s]", this, this:GetName())
		self:moveObject(this.bagButtons[1], "+", 30, "+", 4)
	end)

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
	
end
