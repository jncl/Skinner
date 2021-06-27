local aName, aObj = ...
if not aObj:isAddonEnabled("BtWLoadouts") then return end
local _G = _G

aObj.addonsToSkin.BtWLoadouts = function(self) -- v 1.0.0

	self:SecureHookScript(_G.BtWLoadoutsFrame, "OnShow", function(this)
		self:removeInset(this.SidebarInset)
		self:skinObject("editbox", {obj=this.Sidebar.SearchBox, si=true, ca=true})
		self:skinObject("slider", {obj=this.Sidebar.Scroll.ScrollBar})
		self:removeInset(this.BodyInset)
		self:skinObject("glowbox", {obj=this.HelpTipBox})
		self:skinObject("frame", {obj=this.NPE, ri=true})
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=true, offsets={x1=6, y1=3, x2=-6, y2=2}})
		self:skinObject("frame", {obj=this, kfs=true, rns=true, cb=true, x2=2})
		if self.modBtns then
			this.OptionsButton:SetHitRectInsets(0, 0, 0, 0)
			self:moveObject{obj=this.OptionsButton, x=-10}
			this.OptionsButton:SetSize(14, 14)
			this.OptionsButton:SetNormalTexture([[Interface\AddOns\]] .. aName .. [[\Textures\gear]])
			this.OptionsButton:SetPushedTexture(nil)
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
			self:skinStdButton{obj=this.NPE.AddButton}
		end

		self:SecureHookScript(this.Loadouts, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			self:skinObject("dropdown", {obj=this.SpecDropDown, initState=not this.SpecDropDown.Button:IsEnabled()})
			self:skinObject("dropdown", {obj=this.CharacterDropDown, initState=not this.CharacterDropDown.Button:IsEnabled()})
			self:SecureHook(this, "Update", function(this)
				self:checkDisabledDD(this.SpecDropDown, not this.SpecDropDown.Button:IsEnabled())
			end)
			self:skinObject("slider", {obj=this.SetsScroll.ScrollBar})
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Enabled}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.Loadouts)
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
		self:SecureHookScript(this.Talents, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			self:skinObject("dropdown", {obj=this.SpecDropDown, initState=not this.SpecDropDown.Button:IsEnabled()})
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
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			self:skinObject("dropdown", {obj=this.SpecDropDown, initState=not this.SpecDropDown.Button:IsEnabled()})
			self:SecureHook(this, "Update", function(this)
				for grid in this.GridPool:EnumerateActive() do
					skinTalentRow(grid)
				end
			end)

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.Essences, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			self:skinObject("dropdown", {obj=this.RoleDropDown, initState=not this.RoleDropDown.Button:IsEnabled()})
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
		self:SecureHookScript(this.Soulbinds, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			self:skinObject("dropdown", {obj=this.SoulbindDropDown, initState=not this.SoulbindDropDown.Button:IsEnabled()})
			self:skinObject("dropdown", {obj=this.RestrictionsDropDown, initState=not this.RestrictionsDropDown.Button:IsEnabled()})
			
			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.Equipment, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			for _, slot in pairs(this.Slots) do
				slot:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=slot, ibt=true}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.ActionBars, "OnShow", function(this)
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
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
			local ddNames = {"Loadout", "Character", "ConditionType", "Instance", "Difficulty", "Boss", "Affixes", "Scenario"}
			self:removeInset(this.Inset)
			self:skinObject("editbox", {obj=this.Name, ca=true})
			for _, name in _G.pairs(ddNames) do
				self:skinObject("dropdown", {obj=this[name .. "DropDown"], initState=not this[name .. "DropDown"].Button:IsEnabled()})
				self:SecureHook(this[name .. "DropDown"], "SetShown", function(this)
					this.sf:SetShown(this:IsShown())
				end)
			end
			self:SecureHook(this, "Update", function(this)
				for _, name in _G.pairs(ddNames) do
					self:checkDisabledDD(this[name .. "DropDown"], not this[name .. "DropDown"].Button:IsEnabled())
				end
			end)
			self:removeNineSlice(_G.BtWLoadoutsConditionsAffixesDropDownList.Border)
			self:skinObject("frame", {obj=_G.BtWLoadoutsConditionsAffixesDropDownList, ofs=0})
			if self.modChkBtns then
				self:skinCheckButton{obj=this.Enabled}
			end

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BtWLoadoutsLogFrame, "OnShow", function(this)
		self:removeInset(this.BodyInset)
		self:skinObject("slider", {obj=this.Scroll.ScrollBar, rpTex="background"})
		self:skinObject("frame", {obj=this, kfs=true, rns=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

end
