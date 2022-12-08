local _, aObj = ...
if not aObj:isAddonEnabled("Storyline") then return end
local _G = _G

aObj.addonsToSkin.Storyline = function(self) -- v 3.3.1

	self:SecureHookScript(_G.Storyline_NPCFrame, "OnShow", function(this)
		this.Background:DisableDrawLayer("BACKGROUND")
		_G.Storyline_NPCFrameGossipChoices:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G.Storyline_NPCFrameGossipChoices, ofs=0, clr="gold"})
		self:getChild(this, 3):DisableDrawLayer("OVERLAY")
		self:getRegion(this.Banner, 1):SetTexture(nil)
		self:skinObject("frame", {obj=this.chat, kfs=true, ng=true, ofs=0})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.chat.previous, ofs=-2, y2=4, clr="grey"}
		end
		self:getRegion(_G.Storyline_NPCFrameObjectives, 3):SetTexture(nil)
		_G.Storyline_NPCFrameObjectivesContent:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G.Storyline_NPCFrameObjectivesContent, ofs=0, clr="gold"})
		self:getRegion(_G.Storyline_NPCFrameRewards, 2):SetTexture(nil)
		_G.Storyline_NPCFrameRewards.Content:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G.Storyline_NPCFrameRewards.Content, ofs=0, clr="gold"})
		self:skinObject("frame", {obj=this, kfs=true, bg=true, ofs=-4, y1=-10, y2=10})
		if self.modBtns then
			self:skinCloseButton{obj=_G.Storyline_NPCFrameClose}
			-- Lock button, change texture
			local tex = _G.Storyline_NPCFrameLock:GetNormalTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0, 0.25, 0, 1.0)
			tex:SetAlpha(1)
			tex = _G.Storyline_NPCFrameLock:GetPushedTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(0.75)
			tex = _G.Storyline_NPCFrameLock:GetCheckedTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(1)
			self:moveObject{obj=_G.Storyline_NPCFrameLock, x=-6, y=7} -- move it up and left
			self:skinOtherButton{obj=_G.Storyline_NPCFrameResizeButton, font=self.fontS, text=self.searrow}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.Storyline_NPCFrameConfigButton, ofs=-2, x1=1, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:RawHook(_G.Storyline_API.dialogs.buttons, "getButton", function(parent, anchor)
		local button = self.hooks[_G.Storyline_API.dialogs.buttons].getButton(parent, anchor)
		button:DisableDrawLayer("BACKGROUND")
		return button
	end, true)
	self:SecureHook(_G.Storyline_API.rewards.buttons, "displayRewardsOnGrid", function(_, _, parent, _, _)
		for _, child in _G.ipairs_reverse{parent:GetChildren()} do
			if child:IsObjectType("Button")
			then
				child.NameFrame:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=child, relTo=child.Icon, clr="grey"}
				end
			end
		end

	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.Storyline_MainTooltip)
	end)

end
