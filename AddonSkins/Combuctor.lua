local aName, aObj = ...
if not aObj:isAddonEnabled("Combuctor") then return end
local _G = _G

function aObj:Combuctor()
	if not self.db.profile.ContainerFrames.skin then return end

	-- skin Inventory & Bank frames
	local frame
	for i = 1, #_G.Combuctor.frames do
		frame = _G["CombuctorFrame" .. i]
		self:skinEditBox{obj=frame.nameFilter, regs={9}, noWidth=true, noMove=true}
		_G["CombuctorFrame" .. i .. "BagToggleBorder"]:SetTexture(nil)
		self:addSkinFrame{obj=frame, kfs=true, ri=true, x1=-1, y1=3, x2=1, y2=-5}
	end
	frame = nil

	-- Tabs aka BottomFilter
	local function skinTabs(frame)

		for i = 1, #frame.buttons do
			if i == frame.selectedTab then
				self:setActiveTab(frame.buttons[i].sf)
			else
				self:setInactiveTab(frame.buttons[i].sf)
			end
		end

	end

	self:SecureHook(_G.Combuctor.BottomFilter, "UpdateFilters", function(this)
		local tabObj
		for i = 1, #this.buttons do
			tabObj = this.buttons[i]
			if not tabObj.sknd then
				self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
				self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
				if i == 1 then
					if self.isTT then self:setActiveTab(tabObj.sf) end
				else
					if self.isTT then self:setInactiveTab(tabObj.sf) end
				end
				if not self:IsHooked(tabObj, "OnClick") then
					self:SecureHookScript(tabObj, "OnClick", function(this)
						skinTabs(this:GetParent())
					end)
				end
			end
		end
		tabObj = nil
	end)

	-- Side Tabs aka SideFilter
	self:SecureHook(_G.Combuctor.SideFilter, "UpdateFilters", function(this)
		for i = 1, #this.buttons do
			self:removeRegions(this.buttons[i], {1}) -- N.B. other regions are icon and highlight
		end
	end)

	-- if Bagnon_Forever loaded
	if _G.BagnonDB then -- move & show the player icon, used to select player info
		_G.CombuctorFrame1.portrait:SetAlpha(1)
		self:moveObject{obj=_G.CombuctorFrame1IconButton, x=10, y=-10}
		_G.CombuctorFrame2.portrait:SetAlpha(1)
		self:moveObject{obj=_G.CombuctorFrame2IconButton, x=10, y=-10}
	else
		self:keepFontStrings(_G.CombuctorFrame1IconButton)
		self:keepFontStrings(_G.CombuctorFrame2IconButton)
	end

end
