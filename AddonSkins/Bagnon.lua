local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

function aObj:Bagnon() -- 7.0.4
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	local Bagnon = _G.Bagnon
	-- hide empty slot background
	Bagnon.sets['emptySlots'] = false

	if self.modBtnBs then
		-- hook this to manage button border colours
		self:SecureHook(Bagnon.ItemSlot, "UpdateBorder", function(this)
			if not this.sbb then return end -- handle missing sbb frame
			local _, _, _, quality = this:GetInfo()
			local item = this:GetItem()
			-- revert to default
			this.sbb:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
			-- change border if required
			if item then
				if Bagnon.sets.glowQuality
				and quality
				and quality > 1
				then
					this.sbb:SetBackdropBorderColor(_G.BAG_ITEM_QUALITY_COLORS[quality].r, _G.BAG_ITEM_QUALITY_COLORS[quality].g, _G.BAG_ITEM_QUALITY_COLORS[quality].b, 1)
				end
			end
			quality, item = nil, nil
		end)
	end

	-- skin the bag frames
	local function skinFrame(frame, id)
		aObj:addSkinFrame{obj=frame, nb=true}
		frame.SetBackdropColor = function() end
		frame.SetBackdropBorderColor = function() end
		if not aObj:IsHooked(frame, "OnShow") then
			aObj:SecureHookScript(frame, "OnShow", function(this)
				if aObj.modBtnBs then
					for i = 1, #this.menuButtons do
						aObj:addButtonBorder{obj=this.menuButtons[i], ofs=3}
					end
					-- bag/tab buttons
					if this.bagFrame then
						local kids = {this.bagFrame:GetChildren()}
						for _, child in _G.ipairs(kids) do
							if child:IsObjectType("CheckButton") then
								aObj:addButtonBorder{obj=child, ofs=3}
							end
						end
						kids = nil
					end
					if this:HasOptionsToggle() then
						aObj:addButtonBorder{obj=this.optionsToggle, ofs=3}
					end
					if this:HasBrokerDisplay() then
						aObj:addButtonBorder{obj=this.brokerDisplay, relTo=this.brokerDisplay.icon, ofs=3}
					end
					-- VoidStorage Transfer button
					if this:HasMoneyFrame()
					and this.moneyFrame.icon
					then
						aObj:addButtonBorder{obj=this.moneyFrame.icon:GetParent(), relTo=this.moneyFrame.icon, ofs=3}
					end
				end
				if this.closeButton then
					aObj:skinButton{obj=this.closeButton, cb=true}
				end
				if frame.CreateLogFrame then
					aObj:SecureHook(frame, "CreateLogFrame", function(this)
						aObj:skinSlider{obj=this.logFrame.ScrollBar}
						-- DON'T unhook as new frames are created each time
					end)
				end
				if frame.CreateEditFrame then
					aObj:SecureHook(frame, "CreateEditFrame", function(this)
						aObj:skinSlider{obj=this.editFrame.ScrollBar}
						aObj:Unhook(this, "CreateEditFrame")
					end)
				end
				aObj:Unhook(this, "OnShow")
			end)
		end
		if aObj.modBtnBs
		and id == "guild"
		then
			aObj:SecureHook(frame.ItemFrame, "Layout", function(this)
				for i = 1, #this.buttons do
					aObj:addButtonBorder{obj=this.buttons[i]}
				end
				aObj:Unhook(this, "Layout")
			end)
		end
	end
	-- skin the Search EditBox
	self:RawHook(Bagnon["SearchFrame"], "New", function(this, ...)
		local eb = self.hooks[Bagnon["SearchFrame"]].New(this, ...)
		self:skinEditBox{obj=eb, regs={9}}
		return eb
	end)
	-- skin frames
	skinFrame(Bagnon.frames["inventory"])
	-- hook this to skin new frames
	self:RawHook(Bagnon["Frame"], "New", function(this, id)
		local frame = self.hooks[Bagnon["Frame"]].New(this, id)
		skinFrame(frame, id)
		return frame
	end)

end

-- Bagnon_Config: Sushi objects are managed in IOP checkKids function
-- Bagnon_GuildBank frame handled in above skinFrame function
-- Bagnon_VoidStorage frame handled in above skinFrame function
