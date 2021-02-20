local _, aObj = ...
if not aObj:isAddonEnabled("BtWLoadouts") then return end
local _G = _G

aObj.addonsToSkin.BtWLoadouts = function(self) -- v 83

	local function skinTabFrame(frame, dropdown)
		aObj:removeInset(frame.Inset)
		aObj:skinObject("editbox", {obj=frame.Name, ca=true})
		if dropdown then
			aObj:skinObject("dropdown", {obj=dropdown, initState=not dropdown.Button:IsEnabled()})
		end
	end
	local function skinTalentRow(row)
		for tex in row.BackgroundPool:EnumerateActive() do
			tex:SetTexture(nil)
		end
		for tex in row.SeparatorPool:EnumerateActive() do
			tex:SetTexture(nil)
		end
		for btn in row.ButtonPool:EnumerateActive() do
			btn.Slot:SetTexture(nil)
			btn.Cover:SetTexture(nil)
			if aObj.modBtnBs then
				btn.KnownSelection:SetAlpha(0)
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, clr=btn.KnownSelection:IsShown() and "gold" or "disabled"}
				aObj:secureHook(btn, "Update", function(this)
					aObj:clrBtnBdr(btn, btn.KnownSelection:IsShown() and "gold" or "disabled")
				end)
			else
				btn.KnownSelection:SetTexCoord(0.14, 0.86, 0, 1)
				btn.KnownSelection:SetVertexColor(0, 1, 0, 1)
			end
		end
	end
	self:SecureHookScript(_G.BtWLoadoutsFrame, "OnShow", function(this)
		self:removeInset(this.SidebarInset)
		self:skinObject("editbox", {obj=this.Sidebar.SearchBox, si=true, ca=true})
		self:skinObject("slider", {obj=this.Sidebar.Scroll.ScrollBar})
		self:removeInset(this.BodyInset)
		self:skinObject("glowbox", {obj=this.HelpTipBox})
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=true, offsets={x1=6, y1=3, x2=-6, y2=2}})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=2})
		if self.modBtns then
			self:skinStdButton{obj=this.Sidebar.FilterButton, ofs=0}
			self:SecureHook(this.Sidebar, "Update", function(this)
				self:clrBtnBdr(this.FilterButton)
			end)
			self:skinStdButton{obj=this.AddButton}
			self:skinStdButton{obj=this.RefreshButton}
			self:skinStdButton{obj=this.ActivateButton}
			self:skinStdButton{obj=this.DeleteButton}
			self:SecureHook(this.RefreshButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(this.ActivateButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(this.DeleteButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end

		self:SecureHookScript(this.Profiles, "OnShow", function(this)
			skinTabFrame(this,this.SpecDropDown)
			self:SecureHook(this, "Update", function(this)
				self:checkDisabledDD(this.SpecDropDown, not this.SpecDropDown.Button:IsEnabled())
			end)
			self:skinObject("slider", {obj=this.SetsScroll.ScrollBar})
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Enabled}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.Profiles)
		self:SecureHookScript(this.Talents, "OnShow", function(this)
			skinTabFrame(this, this.SpecDropDown)
			self:SecureHook(this, "Update", function(this)
				self:checkDisabledDD(this.SpecDropDown, not this.SpecDropDown.Button:IsEnabled())
			end)
			for _, row in pairs(this.rows) do
				self:SecureHook(row, "Update", function(this)
					skinTalentRow(this)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.PvPTalents, "OnShow", function(this)
			skinTabFrame(this, this.SpecDropDown)
			self:SecureHook(this, "Update", function(this)
				for grid in this.GridPool:EnumerateActive() do
					skinTalentRow(grid)
				end
			end)

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.Essences, "OnShow", function(this)
			skinTabFrame(this, this.RoleDropDown)
			for key, slot in _G.pairs(this.Slots) do
				if key == 115 then -- Major slot
					slot.Glow:SetAlpha(0)
					slot.Shadow:SetAlpha(0)
				end
				slot.Ring:SetAlpha(0)
				slot.HighlightRing:SetAlpha(0)
			end
			self:skinObject("slider", {obj=this.EssenceList.ScrollBar})
			for _, btn in _G.pairs(this.EssenceList.buttons) do
				self:nilTexture(btn.Background, true)
				self:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.Equipment, "OnShow", function(this)
			skinTabFrame(this)
			for _, slot in pairs(this.Slots) do
				slot:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=slot, ibt=true}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.ActionBars, "OnShow", function(this)
			skinTabFrame(this)
			if self.modBtnBs then
				for _, slot in pairs(this.Slots) do
					slot:GetNormalTexture():SetTexture(nil)
					slot.ErrorBorder:SetAlpha(0)
					self:addButtonBorder{obj=slot, clr="grey"}
					self:SecureHook(slot, "Update", function(this)
						self:clrBtnBdr(this, slot.ErrorBorder:IsShown() and "red" or "grey")
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.Conditions, "OnShow", function(this)
			skinTabFrame(this)
			for _, name in _G.pairs{"Profile", "ConditionType", "Instance", "Difficulty", "Boss", "Affixes", "Scenario"} do
				self:skinObject("dropdown", {obj=this[name .. "DropDown"], initState=not this[name .. "DropDown"].Button:IsEnabled()})
				self:SecureHook(this[name .. "DropDown"], "SetShown", function(this)
					this.sf:SetShown(this:IsShown())
				end)
			end
			self:SecureHook(this, "Update", function(this)
				self:checkDisabledDD(this.ProfileDropDown, not this.ProfileDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.ConditionTypeDropDown, not this.ConditionTypeDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.InstanceDropDown, not this.InstanceDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.DifficultyDropDown, not this.DifficultyDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.BossDropDown, not this.BossDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.AffixesDropDown, not this.AffixesDropDown.Button:IsEnabled())
				self:checkDisabledDD(this.ScenarioDropDown, not this.ScenarioDropDown.Button:IsEnabled())
			end)
			-- TODO: BtWLoadoutsConditionsAffixesDropDownList
				-- .Border
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Enabled}
			end

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BtWLoadoutsLogFrame, "OnShow", function(this)
		self:removeInset(this.BodyInset)
		this.Scroll:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.Scroll.ScrollBar, wdth=-4}
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

end
