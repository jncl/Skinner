local _, aObj = ...
if not aObj:isAddonEnabled("BtWLoadouts") then return end
local _G = _G

aObj.addonsToSkin.BtWLoadouts = function(self) -- v 1.19.3

	self:SecureHookScript(_G.BtWLoadoutsFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollBar})
		self:removeInset(this.SidebarInset)
		self:skinObject("editbox", {obj=this.Sidebar.SearchBox, si=true, ca=true})
		self:skinObject("slider", {obj=this.Sidebar.Scroll.scrollBar})
		self:removeInset(this.BodyInset)
		self:skinObject("glowbox", {obj=this.HelpTipBox})
		self:skinObject("frame", {obj=this.NPE, ri=true, ofs=8})
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=true, offsets={x1=0, y1=0, x2=0, y2=2}})
		self:skinObject("frame", {obj=this, kfs=true, rns=true, cb=true, ofs=5})
		if self.modBtns then
			this.OptionsButton:SetHitRectInsets(0, 0, 0, 0)
			self:moveObject{obj=this.OptionsButton, x=-10}
			this.OptionsButton:SetSize(14, 14)
			this.OptionsButton:SetNormalTexture(self.tFDIDs.gearWhl)
			this.OptionsButton:SetPushedTexture("")
			self:skinStdButton{obj=this.Sidebar.FilterButton, ofs=0}
			self:skinStdButton{obj=this.NPE.AddButton}
			self:skinStdButton{obj=this.AddButton}
			self:skinStdButton{obj=this.RefreshButton, sechk=true}
			self:skinStdButton{obj=this.ActivateButton, sechk=true}
			self:skinStdButton{obj=this.ExportButton, sechk=true}
			self:skinStdButton{obj=this.DeleteButton, sechk=true}
		end

		self:SecureHookScript(this.Loadouts, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.SpecDropDown})
			self:skinObject("dropdown", {obj=fObj.CharacterDropDown})
			self:skinObject("slider", {obj=fObj.SetsScroll.ScrollBar})
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.Enabled}
			end

			self:Unhook(fObj, "OnShow")
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
					aObj:secureHook(btn, "Update", function(bObj)
						aObj:clrBtnBdr(bObj, bObj.KnownSelection:IsShown() and "gold" or "disabled")
					end)
				else
					btn.KnownSelection:SetTexCoord(0.14, 0.86, 0, 1)
					btn.KnownSelection:SetVertexColor(0, 1, 0, 1)
				end
			end
		end
		self:SecureHookScript(this.Talents, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.SpecDropDown, initState=not fObj.SpecDropDown.Button:IsEnabled()})
			self:skinObject("dropdown", {obj=fObj.RestrictionsDropDown, initState=not fObj.RestrictionsDropDown.Button:IsEnabled()})
			-- .RestrictionsButton
			for _, row in _G.pairs(fObj.rows) do
				self:SecureHook(row, "Update", function(frame)
					skinTalentRow(frame)
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.DFTalents, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("dropdown", {obj=fObj.SpecDropDown})
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			-- .RestrictionsButton
			-- .SelectionChoiceFrame
			self:skinObject("slider", {obj=fObj.Scroll.scrollBar})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.HeroTalents, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("dropdown", {obj=fObj.HeroTreeDropDown})
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.RestrictionsDropDown})
			-- .RestrictionsButton
			-- .SelectionChoiceFrame
			self:skinObject("slider", {obj=fObj.Scroll.scrollBar})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.PvPTalents, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.SpecDropDown})
			self:SecureHook(fObj, "Update", function(frame)
				for grid in frame.GridPool:EnumerateActive() do
					skinTalentRow(grid)
				end
			end)

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Essences, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.RoleDropDown})
			for key, slot in _G.pairs(fObj.Slots) do
				if key == 115 then -- Major slot
					slot.Glow:SetAlpha(0)
					slot.Shadow:SetAlpha(0)
				end
				slot.Ring:SetAlpha(0)
				slot.HighlightRing:SetAlpha(0)
			end
			self:skinObject("slider", {obj=fObj.EssenceList.ScrollBar})
			for _, btn in _G.pairs(fObj.EssenceList.buttons) do
				self:nilTexture(btn.Background, true)
				self:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Soulbinds, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("dropdown", {obj=fObj.SoulbindDropDown})
			self:skinObject("dropdown", {obj=fObj.RestrictionsDropDown})
			
			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Equipment, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			for _, slot in _G.pairs(fObj.Slots) do
				slot:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=slot, ibt=true}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.ActionBars, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("slider", {obj=_G.BtWLoadoutsFrameScrollBar}) -- N.B. scrollbar name
			if self.modBtnBs then
				for _, slot in _G.pairs(fObj.Scroll:GetScrollChild().Slots) do
					slot:GetNormalTexture():SetTexture(nil)
					slot.ErrorBorder:SetAlpha(0)
					self:addButtonBorder{obj=slot, clr="grey"}
					self:SecureHook(slot, "Update", function(frame)
						self:clrBtnBdr(frame, slot.ErrorBorder:IsShown() and "red" or "grey")
					end)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Conditions, "OnShow", function(fObj)
			local ddNames = {"Loadout", "Character", "ConditionType", "Instance", "Difficulty", "Boss", "Affixes", "Scenario"}
			self:removeInset(fObj.Inset)
			self:skinObject("editbox", {obj=fObj.Name, ca=true})
			self:skinObject("editbox", {obj=fObj.ZoneEditBox, ca=true})
			for _, name in _G.pairs(ddNames) do
				self:skinObject("dropdown", {obj=fObj[name .. "DropDown"]})
				self:SecureHook(fObj[name .. "DropDown"], "SetShown", function(frame)
					frame.sf:SetShown(frame:IsShown())
				end)
			end
			self:removeNineSlice(_G.BtWLoadoutsConditionsAffixesDropDownList.Border)
			self:skinObject("frame", {obj=_G.BtWLoadoutsConditionsAffixesDropDownList, ofs=0})
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.Enabled}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Import, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("slider", {obj=fObj.Scroll.scrollBar})
			fObj.Scroll:SetPoint("BOTTOMRIGHT", -12, 2)

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Export, "OnShow", function(fObj)
			self:removeInset(fObj.Inset)
			self:skinObject("slider", {obj=fObj.Scroll.scrollBar})
			fObj.Scroll:SetPoint("BOTTOMRIGHT", -12, 2)

			self:Unhook(fObj, "OnShow")
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
