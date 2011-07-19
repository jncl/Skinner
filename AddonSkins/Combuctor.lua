local aName, aObj = ...
if not aObj:isAddonEnabled("Combuctor") then return end

function aObj:Combuctor()
	if not self.db.profile.ContainerFrames.skin then return end

	-- skin Inventory & Bank frames
	for i = 1, #Combuctor.frames do
		local frame = _G["CombuctorFrame"..i]
		self:skinEditBox{obj=frame.nameFilter, regs={9}, noWidth=true, noMove=true}
		_G["CombuctorFrame"..i.."BagToggleBorder"]:SetTexture(nil)
		self:addSkinFrame{obj=frame, kfs=true, ri=true, x1=-1, y1=3, x2=1, y2=-5}
	end
	
	-- Tabs aka BottomFilter
	local function skinTabs(frame)
	
		for i = 1, #frame.buttons do
			local tabSF = self.skinFrame[frame.buttons[i]]
			if i == frame.selectedTab then
				self:setActiveTab(tabSF)
			else
				self:setInactiveTab(tabSF)
			end
		end

	end

	self:SecureHook(Combuctor.BottomFilter, "UpdateFilters", function(this)
		for i = 1, #this.buttons do
			local tabObj = this.buttons[i]
			if not self.skinned[tabObj] then
				self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
				self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
				local tabSF = self.skinFrame[tabObj]
				if i == 1 then
					if self.isTT then self:setActiveTab(tabSF) end
				else
					if self.isTT then self:setInactiveTab(tabSF) end
				end
				if not self:IsHooked(tabObj, "OnClick") then
					self:SecureHookScript(tabObj, "OnClick", function(this)
						skinTabs(this:GetParent())
					end)
				end
			end
		end
	end)

	-- Side Tabs aka SideFilter
	self:SecureHook(Combuctor.SideFilter, "UpdateFilters", function(this)
--		self:Debug("C.SF_UF: [%s]", this:GetName())
		for i = 1, #this.buttons do
			local tabObj = this.buttons[i]
			if not self.skinned[tabObj] then
				self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
			end
		end
	end)

	-- if Bagnon_Forever loaded
	if BagnonDB then -- move & show the player icon, used to select player info
		CombuctorFrame1.portrait:SetAlpha(1)
		self:moveObject{obj=CombuctorFrame1IconButton, x=10, y=-10}
		CombuctorFrame2.portrait:SetAlpha(1)
		self:moveObject{obj=CombuctorFrame2IconButton, x=10, y=-10}
	else
		self:keepFontStrings(CombuctorFrame1IconButton)
		self:keepFontStrings(CombuctorFrame2IconButton)
	end
	
end
