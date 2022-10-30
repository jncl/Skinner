local aName, aObj = ...
if not aObj:isAddonEnabled("Bagnon") then return end
local _G = _G

aObj.addonsToSkin.Bagnon = function(self) -- v 9.2.2/10.0.1
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

	-- hide empty slot background
	_G.Bagnon.sets.emptySlots = false

	-- skin the bag frames
	local function skinFrame(frame, id)
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true})
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		aObj:secureHookScript(frame, "OnShow", function(this)
			if aObj.modBtnBs then
				for _, btn in _G.pairs(this.menuButtons) do
					aObj:addButtonBorder{obj=btn, ofs=3, clr="grey"}
				end
				-- bag/tab buttons
				if this.bagGroup then
					for _, child in _G.ipairs{this.bagGroup:GetChildren()} do
						if child:IsObjectType("CheckButton") then
							aObj:addButtonBorder{obj=child, ofs=4, clr="grey"}
						end
					end
				end
				-- Options button
				if this:HasOptionsToggle() then
					aObj:addButtonBorder{obj=this.OptionsToggle or this.optionsToggle, ofs=3, clr="grey"}
				end
				-- Broker button
				if this.HasBrokerCarrousel
				and this:HasBrokerCarrousel()
				then
					aObj:addButtonBorder{obj=this.Broker, relTo=this.Broker.Icon, ofs=3, clr="grey"}
				elseif this.HasBrokerDisplay
				and this:HasBrokerDisplay()
				then
					aObj:addButtonBorder{obj=this.brokerDisplay, relTo=this.brokerDisplay.icon, ofs=3, clr="grey"}
				end
				-- VoidStorage Transfer button
				if this.frameID == "vault" then
					if this.Money then
						aObj:addButtonBorder{obj=this.Money.Button, relTo=this.Money.Button.Icon, ofs=3, clr="grey"}
					else
						aObj:addButtonBorder{obj=this.moneyFrame.Button, relTo=this.moneyFrame.Button.Icon, ofs=3, clr="grey"}
					end
				end
			end

			aObj:Unhook(this, "OnShow")
		end)
	end
	-- hook this to skin new frames
	self:RawHook(_G.Bagnon.Frames, "New", function(this, id)
		local frame = self.hooks[this].New(this, id)
		if frame then
			skinFrame(frame, id)
			return frame
		else
			return
		end
	end)

	-- skin the Search EditBox
	self:RawHook(_G.Bagnon["SearchFrame"], "New", function(this, ...)
		local eb = self.hooks[this].New(this, ...)
		self:skinObject("editbox", {obj=eb})
		return eb
	end)

end

-- Bagnon_GuildBank frame handled in above skinFrame function
-- Bagnon_VoidStorage frame handled in above skinFrame function

aObj.lodAddons.Bagnon_Config = function(self) -- v 9.2.2

	-- register callback to skin elements
	self.RegisterCallback("Bagnon_Config", "IOFPanel_After_Skinning", function(this, panel)
		local function skinKids(panel)
			for _, child in _G.ipairs{panel:GetChildren()} do
				if aObj:isDropDown(child) then
					aObj:skinObject("dropdown", {obj=child})
				elseif child:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=child})
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
