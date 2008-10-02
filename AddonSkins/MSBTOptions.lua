
function Skinner:MSBTOptions()

	-- hook this the skin all the popup frames
	self:SecureHook(MSBTOptions.Main, "RegisterPopupFrame", function(pframe)
--		self:Debug("Main_RegisterPopupFrame: [%s]", pframe)
		-- hook the show method so we can skin the popup frame
		if not self:IsHooked(pframe, "Show") then
			self:SecureHook(pframe, "Show", function(this)
--				self:Debug("PopupFrame_Show: [%s, %s]", pframe, pframe:GetName() or "???")
				if not this.skinned then
					self:applySkin(this)
					-- skin the sliders
					if this.mainConditionsListbox and this.mainConditionsListbox.sliderFrame then
						self:skinUsingBD2(this.mainConditionsListbox.sliderFrame)
					end
					if this.secondaryConditionsListbox and this.secondaryConditionsListbox.sliderFrame then
						self:skinUsingBD2(this.secondaryConditionsListbox.sliderFrame)
					end
					if this.triggerEventsListbox and this.triggerEventsListbox.sliderFrame then
						self:skinUsingBD2(this.triggerEventsListbox.sliderFrame)
					end
					if this.skillsListbox and this.skillsListbox.sliderFrame then
						self:skinUsingBD2(this.skillsListbox.sliderFrame)
					end
					this.skinned = true
				end
				self:Unhook(pframe, "Show")
			end)
		end
	end)

	-- hook these to skin the dropdowns & editboxes
	self:Hook(MSBTOptions.Controls, "CreateDropdown", function(parent)
--		self:Debug("Controls_CreateDropdown:[%s]", parent)
		local obj = self.hooks[MSBTOptions.Controls].CreateDropdown(parent)
		self:keepFontStrings(obj)
		obj.skinned = true
		return obj
	end)
	self:Hook(MSBTOptions.Controls, "CreateEditbox", function(parent)
--		self:Debug("Controls_CreateEditbox:[%s]", parent)
		local obj = self.hooks[MSBTOptions.Controls].CreateEditbox(parent)
		self:skinEditBox(obj.editboxFrame, {9})
		self:moveObject(obj.labelFontString, "+", 8, "+", 3, obj)
		obj.skinned = true
		return obj
	end)

	-- handle being invoked as LoD or normal addon
	local function skinMSBTOptions()

	-->>-- Main Frame
		MSBTMainOptionsFrame:SetHeight(MSBTMainOptionsFrame:GetHeight() - 40)
		Skinner:keepFontStrings(MSBTMainOptionsFrame)
		Skinner:moveObject(Skinner:getRegion(MSBTMainOptionsFrame, 12), nil, nil, "+", 8) -- move the title up
		Skinner:moveObject(Skinner:getChild(MSBTMainOptionsFrame, 1), "+", 4, "+", 8) -- move the close button
		for i = 2, 8 do
			local cframe = Skinner:getChild(MSBTMainOptionsFrame, i)
			Skinner:moveObject(cframe, nil, nil, "+", 40) -- move the child frame up
			if i > 3 then
				-- hook the show method so we can skin the Option tab frame elements
				Skinner:SecureHook(cframe, "Show", function(this)
					for i = 1, select("#", this:GetChildren()) do
						local obj = select(i, this:GetChildren())
						if obj:IsObjectType("Frame") and not obj.skinned then
							if obj.selectedItem then -- it's a dropdown
	--							Skinner:Debug("obj has .selectedItem [%s, %s]", obj, obj.selectedItem)
								Skinner:keepFontStrings(obj)
								obj.skinned = true
							end
						end
					end
					-- skin sliders
					if this.controls.eventsListbox and this.controls.eventsListbox.sliderFrame then
						Skinner:skinUsingBD2(this.controls.eventsListbox.sliderFrame)
					end
					if this.controls.triggersListbox and this.controls.triggersListbox.sliderFrame then
						Skinner:skinUsingBD2(this.controls.triggersListbox.sliderFrame)
					end
					Skinner:Unhook(cframe, "Show")
				end)
			end
		end
		Skinner:applySkin(MSBTMainOptionsFrame)

	-->>--	TabList frame
		local tabList = Skinner:getChild(MSBTMainOptionsFrame, 2)
		Skinner:skinUsingBD2(tabList.sliderFrame)
		Skinner:applySkin(tabList) -- skin the tablist frame
		tabList.skinned = true

	-->>--	General tab of the Options Frame dropdown
		Skinner:keepFontStrings(Skinner:getChild(Skinner:getChild(MSBTMainOptionsFrame, 3), 2))

	-->>--	dropdown listbox frame
		for i = 1, select("#", UIParent:GetChildren()) do
			local obj = select(i, UIParent:GetChildren())
			if obj:GetName() == nil and obj:IsObjectType("Frame") then
				local backdrop = obj:GetBackdrop()
				if backdrop and backdrop.bgFile == "Interface\\Addons\\MSBTOptions\\Artwork\\PlainBackdrop" then
					if not obj.skinned then
						Skinner:skinUsingBD2(obj.listbox.sliderFrame)
						Skinner:applySkin(obj)
						obj.skinned = true
					end
				end
			end
		end

	end

	if MSBTMainOptionsFrame then
		skinMSBTOptions()
	else
		self:SecureHook(MSBTOptions.Main, "ShowMainFrame", function()
			skinMSBTOptions()
			self:Unhook(MSBTOptions.Main, "ShowMainFrame")
		end)
	end

end
