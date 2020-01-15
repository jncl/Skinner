local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

aObj.addonsToSkin.Bagnon = function(self) -- v 8.2.29
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	local Bagnon = _G.Bagnon
	-- hide empty slot background
	Bagnon.sets['emptySlots'] = false

	-- skin the bag frames
	local function skinFrame(frame, id)
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		aObj:secureHookScript(frame, "OnShow", function(this)
			if aObj.modBtnBs then
				for i = 1, #this.menuButtons do
					aObj:addButtonBorder{obj=this.menuButtons[i], ofs=3, clr="grey"}
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
					aObj:addButtonBorder{obj=this.optionsToggle, ofs=3, clr="grey"}
				end
				if this:HasBrokerDisplay() then
					aObj:addButtonBorder{obj=this.brokerDisplay, relTo=this.brokerDisplay.icon, ofs=3, clr="grey"}
				end
				-- VoidStorage Transfer button
				if this:HasMoneyFrame()
				and this.moneyFrame.icon
				then
					aObj:addButtonBorder{obj=this.moneyFrame.icon:GetParent(), relTo=this.moneyFrame.icon, ofs=3, clr="grey"}
				end
			end
			if aObj.modBtns then
				if this.closeButton then
					aObj:skinCloseButton{obj=this.closeButton}
				end
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
	-- skin the Search EditBox
	self:RawHook(Bagnon["SearchFrame"], "New", function(this, ...)
		local eb = self.hooks[this].New(this, ...)
		self:skinEditBox{obj=eb, regs={9}}
		return eb
	end)
	-- hook this to skin new frames
	self:RawHook(Bagnon.Frames, "New", function(this, id)
		local frame = self.hooks[this].New(this, id)
		if frame then
			skinFrame(frame, id)
			return frame
		else
			return
		end
	end)

end

-- Bagnon_GuildBank frame handled in above skinFrame function
-- Bagnon_VoidStorage frame handled in above skinFrame function

aObj.lodAddons.Bagnon_Config = function(self) -- v 8.2.29

	-- hook this to manage the Sushi Dropdowns
	local sushi = _G.LibStub:GetLibrary("Sushi-3.1")
	self:RawHook(sushi.Dropdown, "Toggle", function(this, obj)
		local drop = self.hooks[this].Toggle(this, obj)
		self:addSkinFrame{obj=drop.Bg, ft="a", kfs=true, nb=true}
		drop.Bg.SetBackdrop = _G.nop
		return drop
	end, true)
	-- hook this to manage width of check boxes
	if aObj.modChkBtns then
		self:RawHook(sushi.Check, "Construct", function(this)
			local frame = self.hooks[this].Construct(this)
			self:skinCheckButton{obj=frame}
			frame.sb:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 22, 5)
			return frame
		end, true)
	end
	-- register callback to skin elements
	self.RegisterCallback("Bagnon_Config", "IOFPanel_After_Skinning", function(this, panel)
		local function skinKids(panel)
			for _, child in _G.ipairs{panel:GetChildren()} do
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child, x2=-1}
				elseif child:IsObjectType("Slider") then
					aObj:skinSlider{obj=child}
					if Round(child:GetHeight()) == 17 then
						aObj:adjHeight(child, -4)
					end
				elseif child:IsObjectType("Frame") then
					skinKids(child)
				end
			end

		end

		if panel.name == "Bagnon"
		or panel.parent == "Bagnon"
		then
			skinKids(self:getChild(panel, 1)) -- options on sub panel
		end
	end)

end
