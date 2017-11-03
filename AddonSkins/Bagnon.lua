local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

aObj.addonsToSkin.Bagnon = function(self) -- v 7.3.2
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
		aObj:addSkinFrame{obj=frame, ft="a", nb=true}
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
					aObj:skinCloseButton{obj=this.closeButton}
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

-- Bagnon_GuildBank frame handled in above skinFrame function
-- Bagnon_VoidStorage frame handled in above skinFrame function

aObj.lodAddons.Bagnon_Config = function(self) -- v 7.3.2

	-- hook these to manage the SushiDropFrame
	self:secureHook(_G.SushiDropFrame, "OnCreate", function(this)
		local frame
		for j = 1, #this.usedFrames do
			frame = this.usedFrames[j]
			if not frame.bg.sf then
				self:addSkinFrame{obj=frame.bg, ft="a", kfs=true, nb=true}
				frame.bg.SetBackdrop = _G.nop
			end
		end
		frame = nil
	end)
	self:secureHook(_G.SushiDropFrame, "OnAcquire", function(this)
		-- need to raise frame level so it's above other text
		_G.RaiseFrameLevelByTwo(this)
	end)

	-- register callback to indicate already skinned
	local pCnt = 0
	self.RegisterCallback("Bagnon_Config", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name == "Bagnon"
		or panel.parent == "Bagnon"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end
		if pCnt == 5 then
			self.UnregisterCallback("Bagnon_Config", "IOFPanel_Before_Skinning")
		end
	end)

	-- register callback to skin elements
	self.RegisterCallback("Bagnon_Config", "IOFPanel_After_Skinning", function(this, panel)
		local function skinKids(panel)

			for _, child in _G.ipairs{panel:GetChildren()} do
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child}
				elseif child:IsObjectType("Slider") then
					aObj:skinSlider{obj=child, hgt=-4}
				elseif child:IsObjectType("CheckButton") then
					aObj:skinCheckButton{obj=child}
					if aObj.modBtns then
						if child.toggle then -- expanded check button
							aObj:skinExpandButton{obj=child.toggle, onSB=true, plus=true, noHook=true}
							-- hook this to handle button texture changes
							aObj:SecureHook(child, "SetExpanded", function(this)
								if this:IsExpanded() then
									this.toggle.sb:SetText("-")
								else
									this.toggle.sb:SetText("+")
								end
							end)
						end
					end
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={6}} -- 6 is text
				elseif child:IsObjectType("Button") then
					aObj:skinStdButton{obj=child}
				elseif child:IsObjectType("Frame") then
					if child:GetName():find("Bagnon_Config")
					or child:GetName():find("FauxScroll")
					then
						skinKids(child)
					end
				end
			end

		end

		if panel.name == "Bagnon"
		or panel.parent == "Bagnon"
		and not panel.sknd
		then
			skinKids(self:getChild(panel, 1)) -- options on sub panel
			panel.sknd = true
		end
		if pCnt == 5 then
			self.UnregisterCallback("Bagnon_Config", "IOFPanel_After_Skinning")
			pCnt = nil
		end
	end)

end