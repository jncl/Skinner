local _, aObj = ...

local _G = _G

aObj.SetupDragonflight_NPCFrames = function()
	local ftype = "n"

	aObj.blizzLoDFrames[ftype].GenericTraitUI = function(self)
		if not self.prdb.GenericTraitUI or self.initialized.GenericTraitUI then return end
		self.initialized.GenericTraitUI = true

		self:SecureHookScript(_G.GenericTraitFrame, "OnShow", function(this)
			-- TODO: Keep background visible
			this.PortraitOverlay:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].GossipFrame = function(self)
		if not self.prdb.GossipFrame or self.initialized.GossipFrame then return end
		self.initialized.GossipFrame = true

		if not (self:isAddonEnabled("Quester")
		and _G.QuesterDB.gossipColor)
		then
			local newText, upd
			local function skinGossip(element)
				if element.GreetingText then
					element.GreetingText:SetTextColor(aObj.HT:GetRGB())
				else
					newText, upd = aObj:removeColourCodes(element:GetText())
					if upd then
						element:SetText(newText)
					end
					element:GetFontString():SetTextColor(aObj.BT:GetRGB())
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(_G.GossipFrame.GreetingPanel.ScrollBox, skinGossip, aObj, true)
		end

		self:SecureHookScript(_G.GossipFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.GreetingPanel.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.GreetingPanel.GoodbyeButton}
			end
			self:removeRegions(this.FriendshipStatusBar, {1, 2, 5, 6, 7, 8 ,9})
			self:skinObject("statusbar", {obj=this.FriendshipStatusBar, fi=0, bg=self:getRegion(this.FriendshipStatusBar, 10)})

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupDragonflight_NPCFramesOptions = function(self)

	local optTab = {
		["Generic Trait UI"] = {desc = "Trait UI"},
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end