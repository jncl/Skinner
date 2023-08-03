local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

local ftype = "p"

if aObj.isRtl
or aObj.isClscERAPTR
then
	aObj.blizzLoDFrames[ftype].Communities = function(self)
		if not self.prdb.Communities or self.initialized.Communities then return end

		--> N.B.these frames can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
			-- CommunitiesAddDialog
			-- CommunitiesCreateDialog

		if not _G.CommunitiesFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].Communities(self)
			end)
			return
		end

		self.initialized.Communities = true

		local function skinColumnDisplay(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			frame:DisableDrawLayer("ARTWORK")
			for header in frame.columnHeaders:EnumerateActive() do
				header:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=header, fType=ftype, x2=-2})
			end
		end

		self:SecureHookScript(_G.CommunitiesFrame, "OnShow", function(this)
			self:keepFontStrings(this.PortraitOverlay)
			if aObj.isClscERAPTR then
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			end
			-- tabs (side)
			local tabs = {"ChatTab", "RosterTab"}
			if self.isRtl then
				aObj:add2Table(tabs, "GuildBenefitsTab")
				aObj:add2Table(tabs, "GuildInfoTab")
			end
			for _, tabName in _G.pairs(tabs) do
				this[tabName]:DisableDrawLayer("BORDER")
				if self.modBtnBs then
					self:addButtonBorder{obj=this[tabName]}
				end
			end
			self:moveObject{obj=this.ChatTab, x=1}
			self:skinObject("dropdown", {obj=this.StreamDropDownMenu, fType=ftype})
			self:skinObject("dropdown", {obj=this.CommunitiesListDropDownMenu, fType=ftype})
			self:skinObject("editbox", {obj=this.ChatEditBox, fType=ftype, y1=-6, y2=6})
			self:moveObject{obj=this.AddToChatButton, x=-6, y=-6}
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5})
			if self.modBtns then
				self:skinStdButton{obj=this.InviteButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.AddToChatButton, ofs=1, clr="gold"}
			end

			self:SecureHookScript(this.MaximizeMinimizeFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinOtherButton{obj=fObj.MaximizeButton, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=fObj.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
					if self.isRtl then
						self:SecureHook(this, "UpdateMaximizeMinimizeButton", function(frame)
							self:clrBtnBdr(frame.MaximizeMinimizeFrame.MinimizeButton)
						end)
					end
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MaximizeMinimizeFrame)

			self:SecureHookScript(this.CommunitiesList, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BORDER")
				fObj:DisableDrawLayer("ARTWORK")
				self:skinObject("dropdown", {obj=fObj.EntryDropDown, fType=ftype})
				fObj.FilligreeOverlay:DisableDrawLayer("ARTWORK")
				fObj.FilligreeOverlay:DisableDrawLayer("OVERLAY")
				fObj.FilligreeOverlay:DisableDrawLayer("BORDER")
				self:removeInset(fObj.InsetFrame)
				if self.isRtl then
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					local function skinElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							aObj:removeRegions(element, {1})
							aObj:changeTex(element.Selection, true)
							element.Selection:SetHeight(60)
							element.IconRing:SetAlpha(0) -- texture changed in code
							aObj:changeTex(element:GetHighlightTexture())
							element:GetHighlightTexture():SetHeight(60)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				else
					self:skinObject("slider", {obj=fObj.ListScrollFrame.scrollBar, fType=ftype})
					for _, btn in _G.pairs(fObj.ListScrollFrame.buttons) do
						btn.IconRing:SetTexture(nil)
					end
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunitiesList)

			self:SecureHookScript(this.MemberList, "OnShow", function(fObj)
				self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
					skinColumnDisplay(frame)
				end)
				self:checkShown(fObj.ColumnDisplay)
				if self.modChkBtns then
					 self:skinCheckButton{obj=fObj.ShowOfflineButton, hf=true}
				end
				self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
				self:removeInset(fObj.InsetFrame)
				if self.isRtl then
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					local function skinElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							aObj:removeRegions(element.ProfessionHeader, {1, 2, 3}) -- header textures
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				else
					self:skinObject("slider", {obj=fObj.ListScrollFrame.scrollBar, fType=ftype})
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MemberList)

			self:SecureHookScript(this.Chat, "OnShow", function(fObj)
				self:removeInset(fObj.InsetFrame)
				if aObj.isRtl then
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				else
					self:skinObject("slider", {obj=fObj.MessageFrame.ScrollBar, fType=ftype})
				end
				if self.modBtns then
					self:skinStdButton{obj=_G.JumpToUnreadButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Chat)

			self:SecureHookScript(this.InvitationFrame, "OnShow", function(fObj)
				self:removeInset(fObj.InsetFrame)
				fObj.IconRing:SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
					self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.TicketFrame, "OnShow", function(fObj)
				self:removeInset(fObj.InsetFrame)
				fObj.IconRing:SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
					self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.EditStreamDialog, "OnShow", function(fObj)
				if self.isRtl then
					self:removeNineSlice(fObj.BG)
				end
				self:skinObject("editbox", {obj=fObj.NameEdit, fType=ftype, y1=-4, y2=4})
				fObj.NameEdit:SetPoint("TOPLEFT", fObj.NameLabel, "BOTTOMLEFT", -4, 0)
				self:skinObject("frame", {obj=fObj.Description, fType=ftype, kfs=true, fb=true, ofs=7})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Accept, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.Delete, fType=ftype}
					self:skinStdButton{obj=fObj.Cancel, fType=ftype}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TypeCheckBox}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.EditStreamDialog)

			self:SecureHookScript(this.NotificationSettingsDialog, "OnShow", function(fObj)
				self:skinObject("dropdown", {obj=fObj.CommunitiesListDropDownMenu, fType=ftype})
				self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				self:removeNineSlice(fObj.Selector)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6, x2=-4})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ScrollFrame.Child.NoneButton}
					self:skinStdButton{obj=fObj.ScrollFrame.Child.AllButton}
					self:skinStdButton{obj=fObj.Selector.CancelButton}
					self:skinStdButton{obj=fObj.Selector.OkayButton}
				end
				if self.modChkBtns then
					 self:skinCheckButton{obj=fObj.ScrollFrame.Child.QuickJoinButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.NotificationSettingsDialog)

			self:SecureHookScript(this.CommunitiesControlFrame, "OnShow", function(fObj)
				if self.modBtns then
					self:skinStdButton{obj=fObj.CommunitiesSettingsButton, fType=ftype}
					if self.isRtl then
						self:skinStdButton{obj=fObj.GuildRecruitmentButton, fType=ftype, sechk=true}
						self:skinStdButton{obj=fObj.GuildControlButton, fType=ftype}
					end
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunitiesControlFrame)

			if self.isRtl then
				self:skinObject("dropdown", {obj=this.GuildMemberListDropDownMenu, fType=ftype})
				self:skinObject("dropdown", {obj=this.CommunityMemberListDropDownMenu, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=this.GuildLogButton, fType=ftype}
				end

				self:SecureHookScript(this.ApplicantList, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					fObj:DisableDrawLayer("ARTWORK")
					self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
						skinColumnDisplay(frame)
					end)
					self:checkShown(fObj.ColumnDisplay)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
					self:removeNineSlice(fObj.InsetFrame.NineSlice)
					fObj.InsetFrame.Bg:SetTexture(nil)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					local function skinElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							if aObj.modBtns then
								aObj:skinStdButton{obj=element.CancelInvitationButton}
								aObj:skinStdButton{obj=element.InviteButton}
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.ApplicantList)

				local function skinReqToJoin(frame)
					frame.MessageFrame:DisableDrawLayer("BACKGROUND")
					frame.MessageFrame.MessageScroll:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("frame", {obj=frame.MessageFrame, fType=ftype, kfs=true, fb=true, ofs=4})
					aObj:skinObject("frame", {obj=frame.BG, fType=ftype, kfs=true})
					if aObj.modBtns then
						 aObj:skinStdButton{obj=frame.Apply}
						 aObj:skinStdButton{obj=frame.Cancel}
						 aObj:SecureHook(frame, "EnableOrDisableApplyButton", function(fObj)
							 aObj:clrBtnBdr(fObj.Apply, "", 1)
						 end)
					end
					if aObj.modChkBtns then
						aObj:SecureHook(frame, "Initialize", function(fObj)
							for spec in fObj.SpecsPool:EnumerateActive() do
								aObj:skinCheckButton{obj=spec.CheckBox}
							end
						end)
					end
				end
				local function skinCFGaCF(frame)
					frame:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("dropdown", {obj=frame.OptionsList.ClubFilterDropdown, fType=ftype})
					aObj:skinObject("dropdown", {obj=frame.OptionsList.ClubSizeDropdown, fType=ftype})
					aObj:skinObject("dropdown", {obj=frame.OptionsList.SortByDropdown, fType=ftype})
					-- TODO: find out how to change atlas for each type, maybe by using tex coords
					-- ==> :SetAtlas(GetIconForRole(role1, showDisabled), TextureKitConstants.IgnoreAtlasSize)
					-- for _, role in _G.pairs{"Tank", "Healer", "Dps"} do
					-- 	frame.OptionsList[role .. "RoleFrame"].Icon:SetTexture(self.tFDIDs.lfgIR)
					-- end
					aObj:skinObject("editbox", {obj=frame.OptionsList.SearchBox, fType=ftype, si=true, y1=-6, y2=6})
					aObj:moveObject{obj=frame.OptionsList.Search, x=3, y=-4}
					if aObj.modBtns then
						aObj:skinStdButton{obj=frame.OptionsList.Search}
					end
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=frame.OptionsList.TankRoleFrame.CheckBox}
						aObj:skinCheckButton{obj=frame.OptionsList.HealerRoleFrame.CheckBox}
						aObj:skinCheckButton{obj=frame.OptionsList.DpsRoleFrame.CheckBox}
					end

					for _, btn in _G.pairs(frame.GuildCards.Cards) do
						btn:DisableDrawLayer("BACKGROUND")
						aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
						if aObj.modBtns then
							aObj:skinStdButton{obj=btn.RequestJoin}
						end
						aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
							if shouldDisable then
								aObj:clrBBC(fObj.sf, "disabled")
							else
								aObj:clrBBC(fObj.sf, "gold")
							end
						end)
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=frame.GuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
						aObj:addButtonBorder{obj=frame.GuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
					end

					self:skinObject("scrollbar", {obj=frame.CommunityCards.ScrollBar, fType=ftype})
					local function skinCardElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element:DisableDrawLayer("BACKGROUND")
							element.LogoBorder:SetTexture(nil)
							aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.CommunityCards.ScrollBox, skinCardElement, aObj, true)

					for _, btn in _G.pairs(frame.PendingGuildCards.Cards) do
						btn:DisableDrawLayer("BACKGROUND")
						aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
						if aObj.modBtns then
							aObj:skinStdButton{obj=btn.RequestJoin}
						end
						aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
							if shouldDisable then
								aObj:clrBBC(fObj.sf, "disabled")
							else
								aObj:clrBBC(fObj.sf, "gold")
							end
						end)
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=frame.PendingGuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
						aObj:addButtonBorder{obj=frame.PendingGuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
					end

					self:skinObject("scrollbar", {obj=frame.PendingCommunityCards.ScrollBar, fType=ftype})
					local function skinPendingElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element:DisableDrawLayer("BACKGROUND")
							element.LogoBorder:SetTexture(nil)
							aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.PendingCommunityCards.ScrollBox, skinPendingElement, aObj, true)

					skinReqToJoin(frame.RequestToJoinFrame)

					aObj:removeNineSlice(frame.InsetFrame.NineSlice)
					frame.InsetFrame.Bg:SetTexture(nil)

					frame.DisabledFrame:DisableDrawLayer("BACKGROUND")
					aObj:removeNineSlice(frame.DisabledFrame.NineSlice)

					-- Tabs (RHS)
					aObj:moveObject{obj=frame.ClubFinderSearchTab, x=1}
					aObj:removeRegions(frame.ClubFinderSearchTab, {1})
					aObj:removeRegions(frame.ClubFinderPendingTab, {1})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=frame.ClubFinderSearchTab}
						aObj:addButtonBorder{obj=frame.ClubFinderPendingTab}
						aObj:SecureHook(frame, "UpdatePendingTab", function(fObj)
							aObj:clrBtnBdr(fObj.ClubFinderPendingTab)
						end)
					end
				end

				self:SecureHookScript(this.GuildFinderFrame, "OnShow", function(fObj)
					skinCFGaCF(fObj)
					if self.modBtnBs then
						self:secureHook(fObj.GuildCards, "RefreshLayout", function(frame, _)
							self:clrBtnBdr(frame.PreviousPage, "gold")
							self:clrBtnBdr(frame.NextPage, "gold")
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildFinderFrame)

				self:SecureHookScript(this.CommunityFinderFrame, "OnShow", function(fObj)
					skinCFGaCF(fObj)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.CommunityFinderFrame)

				self:SecureHookScript(this.ClubFinderInvitationFrame, "OnShow", function(fObj)
					fObj.WarningDialog.BG.Bg:SetTexture(nil)
					self:removeNineSlice(fObj.WarningDialog.BG)
					self:skinObject("frame", {obj=fObj.WarningDialog, fType=ftype, kfs=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.WarningDialog.Accept, fType=ftype}
						self:skinStdButton{obj=fObj.WarningDialog.Cancel, fType=ftype}
					end
					self:removeInset(fObj.InsetFrame)
					fObj.IconRing:SetTexture(nil)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
						self:skinStdButton{obj=fObj.ApplyButton, fType=ftype}
						self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")

				end)

				self:SecureHookScript(this.GuildBenefitsFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("OVERLAY")
					self:keepFontStrings(fObj.Perks)
					self:skinObject("scrollbar", {obj=fObj.Perks.ScrollBar, fType=ftype})
					local function skinPerk(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							_, element, _ = ...
						end
						aObj:keepFontStrings(element)
						element.Icon:SetAlpha(1)
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
						end
						aObj:keepFontStrings(element.NormalBorder)
						aObj:keepFontStrings(element.DisabledBorder)
					end
					_G.ScrollUtil.AddInitializedFrameCallback(fObj.Perks.ScrollBox, skinPerk, aObj, true)
					self:keepFontStrings(fObj.Rewards)
					self:skinObject("scrollbar", {obj=fObj.Rewards.ScrollBar, fType=ftype})
					local function skinReward(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							_, element, _ = ...
						end
						aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, clr="sepia"})
						element.Icon:SetAlpha(1)
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(fObj.Rewards.ScrollBox, skinReward, aObj, true)
					fObj.FactionFrame.Bar:DisableDrawLayer("BORDER")
					fObj.FactionFrame.Bar.Progress:SetTexture(self.sbTexture)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildBenefitsFrame)

				self:SecureHookScript(this.GuildDetailsFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("OVERLAY")
					self:removeRegions(fObj.Info, {2, 3, 4, 5, 6, 7, 8, 9, 10})
					self:skinObject("scrollbar", {obj=fObj.Info.MOTDScrollFrame.ScrollBar, fType=ftype})
					self:skinObject("scrollbar", {obj=fObj.Info.DetailsFrame.ScrollBar, fType=ftype})
					fObj.News:DisableDrawLayer("BACKGROUND")
					self:skinObject("scrollbar", {obj=fObj.News.ScrollBar, fType=ftype})
					local function skinElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element.header:SetTexture(nil)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.News.ScrollBox, skinElement, aObj, true)
					self:skinObject("dropdown", {obj=fObj.News.DropDown, fType=ftype})
					self:keepFontStrings(fObj.News.BossModel)
					self:removeRegions(fObj.News.BossModel.TextFrame, {2, 3, 4, 5, 6}) -- border textures

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildDetailsFrame)

				self:SecureHookScript(this.GuildNameAlertFrame, "OnShow", function(fObj)
					self:skinObject("glowbox", {obj=fObj, fType=ftype})

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildNameAlertFrame)

				self:SecureHookScript(this.GuildNameChangeFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Button}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=fObj.CloseButton}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildNameChangeFrame)

				self:SecureHookScript(this.CommunityNameChangeFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Button, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.CommunityNameChangeFrame)

				self:SecureHookScript(this.GuildPostingChangeFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Button, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.GuildPostingChangeFrame)

				self:SecureHookScript(this.CommunityPostingChangeFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Button, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.CommunityPostingChangeFrame)

				self:SecureHookScript(this.RecruitmentDialog, "OnShow", function(fObj)
					self:skinObject("dropdown", {obj=fObj.ClubFocusDropdown, fType=ftype})
					self:skinObject("dropdown", {obj=fObj.LookingForDropdown, fType=ftype})
					self:skinObject("dropdown", {obj=fObj.LanguageDropdown, fType=ftype})
					fObj.RecruitmentMessageFrame:DisableDrawLayer("BACKGROUND")
					fObj.RecruitmentMessageFrame.RecruitmentMessageInput:DisableDrawLayer("BACKGROUND")
					self:skinObject("frame", {obj=fObj.RecruitmentMessageFrame, fType=ftype, kfs=true, fb=true, ofs=3})
					self:skinObject("editbox", {obj=fObj.MinIlvlOnly.EditBox, fType=ftype})
					fObj.MinIlvlOnly.EditBox.Text:ClearAllPoints()
					fObj.MinIlvlOnly.EditBox.Text:SetPoint("Left", fObj.MinIlvlOnly.EditBox, "Left", 6, 0)
					self:skinObject("frame", {obj=fObj.BG, fType=ftype, kfs=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Accept}
						self:skinStdButton{obj=fObj.Cancel}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=fObj.ShouldListClub.Button}
						self:skinCheckButton{obj=fObj.MaxLevelOnly.Button}
						self:skinCheckButton{obj=fObj.MinIlvlOnly.Button}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.RecruitmentDialog)

				-- N.B. hook DisplayMember rather than OnShow script
				self:SecureHook(this.GuildMemberDetailFrame, "DisplayMember", function(fObj, _)
					self:removeNineSlice(fObj.Border)
					self:skinObject("dropdown", {obj=fObj.RankDropdown, fType=ftype})
					self:skinObject("frame", {obj=fObj.NoteBackground, fType=ftype, fb=true, ofs=0})
					self:skinObject("frame", {obj=fObj.OfficerNoteBackground, fType=ftype, fb=true, ofs=0})
					self:adjWidth{obj=fObj.RemoveButton, adj=-4}
					self:adjWidth{obj=fObj.GroupInviteButton, adj=-4}
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=-7, x2=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.RemoveButton, fType=ftype, sechk=true}
						self:skinStdButton{obj=fObj.GroupInviteButton, fType=ftype, sechk=true}
					end

					self:Unhook(fObj, "DisplayMember")
				end)
				self:checkShown(this.GuildMemberDetailFrame)

			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CommunitiesFrame)

		self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
			this.IconPreviewRing:SetTexture(nil)
			self:skinObject("editbox", {obj=this.NameEdit, fType=ftype})
			self:skinObject("editbox", {obj=this.ShortNameEdit, fType=ftype})
			self:skinObject("frame", {obj=this.MessageOfTheDay, fType=ftype, kfs=true, fb=true, ofs=8, clr="grey"})
			self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=8, clr="grey"})
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-10})
			if self.modBtns then
				self:skinStdButton{obj=this.ChangeAvatarButton}
				self:skinStdButton{obj=this.Delete}
				self:skinStdButton{obj=this.Accept}
				self:skinStdButton{obj=this.Cancel}
			end
			if self.isRtl then
				self:keepFontStrings(this.BG)
				self:skinObject("editbox", {obj=this.MinIlvlOnly.EditBox, fType=ftype})
				this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
				this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
				self:skinObject("dropdown", {obj=this.ClubFocusDropdown, fType=ftype})
				self:skinObject("dropdown", {obj=this.LookingForDropdown, fType=ftype})
				self:skinObject("dropdown", {obj=this.LanguageDropdown, fType=ftype})
				if self.modChkBtns then
					self:skinCheckButton{obj=this.CrossFactionToggle.CheckButton, fType=ftype}
					self:skinCheckButton{obj=this.ShouldListClub.Button, fType=ftype}
					self:skinCheckButton{obj=this.AutoAcceptApplications.Button, fType=ftype}
					self:skinCheckButton{obj=this.MaxLevelOnly.Button, fType=ftype}
					self:skinCheckButton{obj=this.MinIlvlOnly.Button, fType=ftype}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
			if self.isRtl then
				self:removeNineSlice(this.Selector)
				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, elementData
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						_, element, elementData = ...
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=element, fType=ftype, clr="grey"}
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
				if self.modBtns then
					self:skinStdButton{obj=this.Selector.CancelButton}
					self:skinStdButton{obj=this.Selector.OkayButton}
				end
			else
				this.ScrollFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					for i = 1, 5 do
						for j = 1, 6 do
							self:addButtonBorder{obj=this.ScrollFrame.avatarButtons[i][j], fType=ftype, clr="grey"}
						end
					end
				end
				if self.modBtns then
					self:skinStdButton{obj=this.CancelButton}
					self:skinStdButton{obj=this.OkayButton}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-4})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesTicketManagerDialog, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.UsesDropDownMenu, fType=ftype})
			this.InviteManager.ArtOverlay:DisableDrawLayer("OVERLAY")
			skinColumnDisplay(this.InviteManager.ColumnDisplay)
			self:skinObject("scrollbar", {obj=this.InviteManager.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					aObj:skinStdButton{obj=element.CopyLinkButton}
					if aObj.modBtnBs then
						 aObj:addButtonBorder{obj=element.RevokeButton, ofs=0, clr="grey"}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.InviteManager.ScrollBox, skinElement, aObj, true)
			self:skinObject("dropdown", {obj=this.ExpiresDropDownMenu, fType=ftype})
			self:skinObject("frame", {obj=this.InviteManager, fType=ftype, kfs=true, fb=true, ofs=-4, x2=-7, y2=-5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-8, y2=6})
			if self.modBtns then
				self:skinStdButton{obj=this.LinkToChat, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.Copy, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.GenerateLinkButton}
				self:skinStdButton{obj=this.Close}
			end
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.MaximizeButton, ofs=0, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isRtl then
			self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
				self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
				if self.modBtns then
					self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
					self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button, uses same name as previous CB
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
				self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
				if self.modBtns then
					 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.CommunitiesGuildNewsFiltersFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
				if self.modChkBtns then
					self:skinCheckButton{obj=this.GuildAchievement}
					self:skinCheckButton{obj=this.Achievement}
					self:skinCheckButton{obj=this.DungeonEncounter}
					self:skinCheckButton{obj=this.EpicItemLooted}
					self:skinCheckButton{obj=this.EpicItemPurchased}
					self:skinCheckButton{obj=this.EpicItemCrafted}
					self:skinCheckButton{obj=this.LegendaryItemLooted}
				end

				self:Unhook(this, "OnShow")
			end)

		end

	end
end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.IsAddOnLoaded("Tukui")
	or _G.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(tObj, x1, x2, _)
			self.hooks[tObj].SetTexCoord(tObj, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)
		-- Display Frame
		self:keepFontStrings(this.displayFrame)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		if not self.isRtl then
			self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
			self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			end
		else
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.editMode, fType=ftype, sechk=true}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClscERA then
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
			end
			if self.isRtl then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
				local fObj = _G.CompactRaidFrameManager
				-- handle button skin frames not being created yet
				if fObj.displayFrame.leaderOptions.readyCheckButton.sb then
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.readyCheckButton)
					if not self.isClscERA then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.rolePollButton)
					end
					if self.isRtl then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.countdownButton)
					end
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

	local function skinUnit(unit)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
		    return
		end
		if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame")
		or unit.healthBar:GetStatusBarTexture():GetTexture() == 423819 -- interface/raidframe/raid-bar-hp-fill.blp
		then
			unit:DisableDrawLayer("BACKGROUND")
			unit.horizDivider:SetTexture(nil)
			unit.horizTopBorder:SetTexture(nil)
			unit.horizBottomBorder:SetTexture(nil)
			unit.vertLeftBorder:SetTexture(nil)
			unit.vertRightBorder:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=unit.healthBar, fi=0, bg=unit.healthBar.background})
			aObj:skinObject("statusbar", {obj=unit.powerBar, fi=0, bg=unit.powerBar.background})
		end
	end
	local grpName
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true}) --, ofs=1, y1=-1, x2=-4, y2=4})
		grpName = grp:GetName()
		if grpName ~= "CompactPartyFrame" then
			for i = 1, _G.MEMBERS_PER_RAID_GROUP do
				skinUnit(_G[grpName .. "Member" .. i])
			end
		end
	end
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	local function skinCRFCframes()
		for type, fTab in _G.pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
			for _, frame in _G.pairs(fTab) do
				if type == "normal" then
					if frame.borderFrame then -- group or party
						skinGrp(frame)
					else
						skinUnit(frame)
					end
				elseif type == "mini" then
					skinUnit(frame)
				end
			end
		end
	end
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, _)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
			skinCRFCframes()
		end
	end)
	-- skin any existing unit(s) [mini, normal]
	skinCRFCframes()
	self:skinObject("frame", {obj=_G.CompactRaidFrameContainer.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.lua
	local gemTypeInfo = {
		["Yellow"]          = {textureKit = "yellow", r = 0.97, g = 0.82, b = 0.29},
		["Red"]             = {textureKit = "red", r = 1, g = 0.47, b = 0.47},
		["Blue"]            = {textureKit = "blue", r = 0.47, g = 0.67, b = 1},
		["Meta"]            = {textureKit = "meta", r = 1, g = 1, b = 1},
		["Prismatic"]       = {textureKit = "prismatic", r = 1, g = 1, b = 1},
	}
	if self.isRtl then
		gemTypeInfo["Hydraulic"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1}
		gemTypeInfo["Cogwheel"]        = {textureKit = "cogwheel", r = 1, g = 1, b = 1}
		gemTypeInfo["PunchcardRed"]    = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["PunchcardYellow"] = {textureKit = "punchcard-yellow", r = 0.97, g = 0.82, b = 0.29}
		gemTypeInfo["PunchcardBlue"]   = {textureKit = "punchcard-blue", r = 0.47, g = 0.67, b = 1}
		gemTypeInfo["Domination"]      = {textureKit = "domination", r = 1, g = 1, b = 1}
		gemTypeInfo["Cypher"]          = {textureKit = "meta", r = 1, g = 1, b = 1}
		gemTypeInfo["Tinker"]          = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["Primordial"]      = {textureKit = "meta", r = 1, g = 1, b = 1}
	end
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		if self.isRtl then
			self:skinObject("scrollbar", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=30})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ItemSocketingCloseButton, fType=ftype}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemSocketingSocketButton, fType=ftype, schk=true}
			this.Sockets = this.Sockets or {_G.ItemSocketingSocket1, _G.ItemSocketingSocket2, _G.ItemSocketingSocket3}
			for _, socket in _G.ipairs(this.Sockets) do
				socket:DisableDrawLayer("BACKGROUND")
				socket:DisableDrawLayer("BORDER")
				self:skinObject("button", {obj=socket, fType=ftype, bd=10, ng=true}) -- ≈ fb option for frame
			end
			local function colourSockets()
				local numSockets = _G.GetNumSockets()
				for i, socket in _G.ipairs(_G.ItemSocketingFrame.Sockets) do
					if i <= numSockets then
						local clr = gemTypeInfo[_G.GetSocketTypes(i)]
						socket.sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
					end
				end
			end
			-- hook this to colour the button border
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets()
			end)
			colourSockets()
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	if not self.isRtl then
		for i = 1, 3 do
			objName = "MirrorTimer" .. i
			obj = _G[objName]
			self:removeRegions(obj, {3})
			obj:SetHeight(obj:GetHeight() * 1.25)
			self:moveObject{obj=_G[objName .. "Text"], y=-2}
			objBG = self:getRegion(obj, 1)
			objBG:SetWidth(objBG:GetWidth() * 0.75)
			objSB = _G[objName .. "StatusBar"]
			objSB:SetWidth(objSB:GetWidth() * 0.75)
			if self.prdb.MirrorTimers.glaze then
				self:skinObject("statusbar", {obj=objSB, fi=0, bg=objBG})
			end
		end
	else
		for _, timer in _G.pairs(_G.MirrorTimerContainer.mirrorTimers) do
			if timer.StatusBar then
				self:nilTexture(timer.TextBorder, true)
				self:nilTexture(timer.Border, true)
				if self.prdb.MirrorTimers.glaze then
					self:skinObject("statusbar", {obj=timer.StatusBar, fi=0, bg=self:getRegion(timer, 2), hookFunc=true})
				end
			end
		end
		if self.prdb.MirrorTimers.glaze then
			self:SecureHook(_G.MirrorTimerContainer, "SetupTimer", function(this, timer, _)
				local actTimer = this:GetActiveTimer(timer)
				if timer == "EXHAUSTION" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				elseif timer == "BREATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("light_blue"))
				elseif timer == "DEATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("blue"))
				else -- FEIGNDEATH
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				end
			end)
		end
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)
			_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
			if aObj.prdb.MirrorTimers.glaze then
				if not aObj.sbGlazed[timer.bar]	then
					aObj:skinObject("statusbar", {obj=timer.bar, fi=0, bg=aObj:getRegion(timer.bar, 1)})
				end
				timer.bar:SetStatusBarColor(aObj:getColourByName("red"))
			end
		end
		self:SecureHook("StartTimer_SetGoTexture", function(timer)
			skinTT(timer)
		end)
		-- skin existing timers
		for _, timer in _G.pairs(_G.TimerTracker.timerList) do
			skinTT(timer)
		end
	end

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.prdb.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	-- N.B. accessed via Raid tab on Friends Frame

	-- N.B. Pullout functionality commented out, therefore code removed from this function

	self:moveObject{obj=_G.RaidGroup1, x=3}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G["RaidGroup" .. i], fType=ftype, fb=true})
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		if not self.isRtl then
			_G["RaidGroupButton" .. i]:SetNormalTexture("")
		else
			_G["RaidGroupButton" .. i]:GetNormalTexture():SetTexture(nil)
		end
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if not self.isRtl then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.ReadyCheckListenerFrame, fType=ftype, kfs=true, x1=32})
		if self.modBtns then
			self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
			self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].RolePollPopup = function(self)
		if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
		self.initialized.RolePollPopup = true

		self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			-- TODO: Retail - skin role button textures
			if not self.isRtl then
				local roleBtn
				for _, type in _G.pairs{"Healer", "Tank", "DPS"} do
					roleBtn = _G["RolePollPopupRoleButton" .. type]
					roleBtn:SetNormalTexture(aObj.tFDIDs.lfgIR)
					roleBtn.cover:SetTexture(aObj.tFDIDs.lfgIR)
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, ofs=5})
			if self.modBtns then
				self:skinStdButton{obj=this.acceptButton}
				self:SecureHook("RolePollPopup_UpdateChecked", function(fObj)
					self:clrBtnBdr(fObj.acceptButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end
end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if self.isRtl then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, moveGEB=true})
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=_G.TradeFrameTradeButton}
			self:skinStdButton{obj=_G.TradeFrameCancelButton}
		end
		if self.modBtnBs then
			for i = 1, _G.MAX_TRADE_ITEMS do
				for _, type in _G.pairs{"Player", "Recipient"} do
					_G["Trade" .. type .. "Item" .. i .. "SlotTexture"]:SetTexture(nil)
					_G["Trade" .. type .. "Item" .. i .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G["Trade" .. type .. "Item" .. i .. "ItemButton"], ibt=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
