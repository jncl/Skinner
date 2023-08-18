local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.SetupClassic_UIFrames = function()
	local ftype = "u"

	aObj.blizzFrames[ftype].BattlefieldFrame = function(self)
		if not self.prdb.BattlefieldFrame or self.initialized.BattlefieldFrame then return end
		self.initialized.BattlefieldFrame = true

		self:SecureHookScript(_G.BattlefieldFrame, "OnShow", function(this)
			if not aObj.isClsc then
				self:skinObject("slider", {obj=_G.BattlefieldListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			else
				self:skinObject("slider", {obj=_G.BattlefieldFrameTypeScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("slider", {obj=_G.BattlefieldFrameInfoScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				_G.BattlefieldFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BT:GetRGB())
				_G.BattlefieldFrameInfoScrollFrameChildFrameRewardsInfoTitle:SetTextColor(self.BT:GetRGB())
				_G.BattlefieldFrameInfoScrollFrameChildFrameRewardsInfoRewardsLabel:SetTextColor(self.BT:GetRGB())
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-12, x2=-32, y2=74})
			_G.BattlefieldFrameCloseButton:Hide()
			if self.modBtns then
				self:skinStdButton{obj=_G.BattlefieldFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=_G.BattlefieldFrameJoinButton, fType=ftype}
				self:skinStdButton{obj=_G.BattlefieldFrameGroupJoinButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].BindingUI = function(self)
		if not self.prdb.BindingUI or self.initialized.BindingUI then return end
		self.initialized.BindingUI = true

		self:SecureHookScript(_G.KeyBindingFrame, "OnShow", function(this)
			if self.isRtl then
				self:removeNineSlice(this.BG)
			end
			self:skinObject("frame", {obj=this.categoryList, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this.bindingsContainer, fType=ftype, kfs=true, fb=true})
			self:skinObject("slider", {obj=this.scrollFrame.ScrollBar, rpTex={"background", "border"}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
			if self.modBtns then
				for _, row in _G.pairs(this.keyBindingRows) do
					self:skinStdButton{obj=row.key1Button}
					self:skinStdButton{obj=row.key2Button}
					row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
					row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
					if self.isRtl then
						self:SecureHook(row, "Update", function(fObj)
							self:clrBtnBdr(fObj.key2Button)
							fObj.key1Button.sb:SetAlpha(fObj.key1Button:GetAlpha())
							fObj.key2Button.sb:SetAlpha(fObj.key2Button:GetAlpha())
						end)
					end
				end
				self:skinStdButton{obj=this.unbindButton}
				self:skinStdButton{obj=this.okayButton}
				self:skinStdButton{obj=this.cancelButton}
				self:skinStdButton{obj=this.defaultsButton}
				-- hook this to handle custom buttons (e.g. Voice Chat: Push to Talk)
				self:SecureHook("BindingButtonTemplate_SetupBindingButton", function(_, button)
					if button.GetCustomBindingType then
						self:skinStdButton{obj=button}
					end
				end)
				if self.isRtl then
					self:skinStdButton{obj=this.quickKeybindButton}
					self:SecureHook(this, "UpdateUnbindKey", function(fObj)
						self:clrBtnBdr(fObj.unbindButton)
					end)
					self:skinStdButton{obj=this.clickCastingButton, fType=ftype}
				else
					self:SecureHook("KeyBindingFrame_Update", function()
						for _, row in _G.pairs(_G.KeyBindingFrame.keyBindingRows) do
							self:clrBtnBdr(row.key2Button)
							row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
							row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
						end
					end)
					self:SecureHook("KeyBindingFrame_UpdateUnbindKey", function()
						self:clrBtnBdr(_G.KeyBindingFrame.unbindButton)
					end)
				end
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.characterSpecificButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.bottomButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.downButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.upButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2, x=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, ofs=-1}
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=1, clr="grey"}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2, x1=1, clr="grey"}
			self:addButtonBorder{obj=_G.TextToSpeechButton, ofs=1, clr="grey"}
		end

	end

	local checkChild, skinKids, cName
	if not aObj.isClscERAPTR then
		aObj.blizzLoDFrames[ftype].GMSurveyUI = function(self)
			if not self.prdb.GMSurveyUI or self.initialized.GMSurveyUI then return end
			self.initialized.GMSurveyUI = true

			self:SecureHookScript(_G.GMSurveyFrame, "OnShow", function(this)
				self:skinObject("slider", {obj=_G.GMSurveyScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				for i = 1, _G.MAX_SURVEY_QUESTIONS do
					self:skinObject("frame", {obj=_G["GMSurveyQuestion" .. i], fType=ftype, kfs=true, fb=true})
					_G["GMSurveyQuestion" .. i].SetBackdropColor = _G.nop
					_G["GMSurveyQuestion" .. i].SetBackdropBorderColor = _G.nop
				end
				self:skinObject("slider", {obj=_G.GMSurveyCommentScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=_G.GMSurveyCommentFrame, fType=ftype, kfs=true, fb=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, y1=-6, x2=-45})

				self:Unhook(this, "OnShow")
			end)

		end

		-- These functions are used by the InterfaceOptions & SystemOptions functions
		function checkChild(child, frameType)
			cName = child:GetName()
			if aObj:isDropDown(child) then
				aObj:skinObject("dropdown", {obj=child, fType=frameType, x2=aObj.iofDD[cName]})
			elseif child:IsObjectType("Slider") then
				aObj:skinObject("slider", {obj=child, fType=frameType})
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child, fType=frameType, hf=true} -- handle hide/show
			elseif child:IsObjectType("EditBox") then
				aObj:skinObject("editbox", {obj=child, fType=frameType})
			elseif child:IsObjectType("Button")
			and aObj.modBtns
			and not aObj.iofBtn[child]
			then
				aObj:skinStdButton{obj=child, fType=ftype}
			end
		end
		function skinKids(obj, frameType)
			-- wait for all objects to be created
			_G.C_Timer.After(0.1, function()
				for _, child in _G.ipairs{obj:GetChildren()} do
					checkChild(child, frameType)
				end
			end)
		end
		aObj.blizzFrames[ftype].InterfaceOptions = function(self)
			if not self.prdb.InterfaceOptions or self.initialized.InterfaceOptions then return end
			self.initialized.InterfaceOptions = true

			-- Interface
			self:SecureHookScript(_G.InterfaceOptionsFrame, "OnShow", function(this)
				if self.isRtl then
					self:removeNineSlice(this.Border)
				end
				-- Top Tabs
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=9, y1=self.isTT and 0 or -4, x2=-9, y2=self.isTT and -5 or 0}})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
				if self.modBtns then
					self:skinStdButton{obj=_G.InterfaceOptionsFrameCancel, fType=ftype}
					self:skinStdButton{obj=_G.InterfaceOptionsFrameOkay, fType=ftype}
					self:skinStdButton{obj=_G.InterfaceOptionsFrameDefaults, fType=ftype}
				end
				-- LHS panel (Game Tab)
				self:SecureHookScript(_G.InterfaceOptionsFrameCategories, "OnShow", function(fObj)
					self:skinObject("slider", {obj=_G.InterfaceOptionsFrameCategoriesListScrollBar, fType=ftype, x1=4, x2=-5})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1})

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.InterfaceOptionsFrameCategories)
				-- LHS panel (AddOns tab)
				self:SecureHookScript(_G.InterfaceOptionsFrameAddOns, "OnShow", function(fObj)
					self:skinObject("slider", {obj=_G.InterfaceOptionsFrameAddOnsListScrollBar, fType=ftype, x1=4, x2=-5})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1})
					if self.modBtns then
						-- skin toggle buttons
						for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
							self:skinExpandButton{obj=btn.toggle, fType=ftype, onSB=true, noHook=true}
							self:checkTex{obj=btn.toggle}
						end
						self:SecureHook("InterfaceAddOnsList_Update", function()
							for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
								self:checkTex{obj=btn.toggle}
							end
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.InterfaceOptionsFrameAddOns)
				-- RHS Panel
				self:skinObject("frame", {obj=_G.InterfaceOptionsFramePanelContainer, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1, y2=0})
				-- Social Browser Frame (Twitter integration)
				self:SecureHookScript(_G.SocialBrowserFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, x2=1})

					self:Unhook(fObj, "OnShow")
				end)
				if self.modBtns then
					self:SecureHook(_G.InterfaceOptionsSocialPanel.EnableTwitter, "setFunc", function(_)
						-- N.B. gets called when panel not skinned
						if _G.InterfaceOptionsSocialPanel.TwitterLoginButton.sb then
							self:clrBtnBdr(_G.InterfaceOptionsSocialPanel.TwitterLoginButton)
						end
					end)
					self:SecureHook(_G.InterfaceOptionsAccessibilityPanelConfigureTextToSpeech, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
					self:SecureHook(_G.InterfaceOptionsAccessibilityPanelRemoteTextToSpeechVoicePlaySample, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
				end

				self:Unhook(this, "OnShow")
			end)

			-- skin extra elements
			self.RegisterCallback("IONP", "IOFPanel_After_Skinning", function(_, panel)
				if panel ~= _G.InterfaceOptionsNamesPanel then return end
				skinKids(_G.InterfaceOptionsNamesPanelFriendly, ftype)
				skinKids(_G.InterfaceOptionsNamesPanelEnemy, ftype)
				skinKids(_G.InterfaceOptionsNamesPanelUnitNameplates, ftype)

				self.UnregisterCallback("IONP", "IOFPanel_After_Skinning")
			end)

			self.RegisterCallback("CUFP", "IOFPanel_After_Skinning", function(_, panel)
				if panel ~= _G.CompactUnitFrameProfiles then
					return
				end
				if self.isRtl then
					self:removeNineSlice(_G.CompactUnitFrameProfiles.newProfileDialog.Border)
					self:removeNineSlice(_G.CompactUnitFrameProfiles.deleteProfileDialog.Border)
					self:removeNineSlice(_G.CompactUnitFrameProfiles.unsavedProfileDialog.Border)
				end
				skinKids(_G.CompactUnitFrameProfiles.newProfileDialog, ftype)
				self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.newProfileDialog, fType=ftype, ofs=0})
				skinKids(_G.CompactUnitFrameProfiles.deleteProfileDialog, ftype)
				self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.deleteProfileDialog, fType=ftype, ofs=0})
				skinKids(_G.CompactUnitFrameProfiles.unsavedProfileDialog, ftype)
				self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.unsavedProfileDialog, fType=ftype, ofs=0})
				skinKids(_G.CompactUnitFrameProfiles.optionsFrame, ftype)
				if self.modBtns then
					self:skinStdButton{obj=_G.CompactUnitFrameProfilesDeleteButton, fType=ftype}
					self:skinStdButton{obj=_G.CompactUnitFrameProfilesSaveButton, fType=ftype}
					self:SecureHook("CompactUnitFrameProfiles_UpdateManagementButtons", function()
						self:clrBtnBdr(_G.CompactUnitFrameProfilesDeleteButton)
						self:clrBtnBdr(_G.CompactUnitFrameProfilesSaveButton)
					end)
					self:SecureHook("CompactUnitFrameProfiles_UpdateNewProfileCreateButton", function()
						self:clrBtnBdr(_G.CompactUnitFrameProfiles.newProfileDialog.createButton)
					end)
				end
				_G.CompactUnitFrameProfiles.optionsFrame.autoActivateBG:SetTexture(nil)

				self.UnregisterCallback("CUFP", "IOFPanel_After_Skinning")
			end)

			-- hook this to skin Interface Option panels
			self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
				-- let AddOn skins know when IOF panel is going to be skinned
				self.callbacks:Fire("IOFPanel_Before_Skinning", panel)
				-- don't skin a panel twice
				if not self.iofSkinnedPanels[panel] then
					skinKids(panel, panel.GetName and panel:GetName() and panel:GetName():find("InterfaceOptions") and ftype)
					self.iofSkinnedPanels[panel] = true
				end
				-- let AddOn skins know when IOF panel has been skinned
				self.callbacks:Fire("IOFPanel_After_Skinning", panel)

			end)

		end
	end

	if _G.C_LFGList.IsLookingForGroupEnabled() then
		if aObj.isClscERA then
			aObj.blizzFrames[ftype].LFGFrame = function(self)
				if not self.prdb.LFGLFM or self.initialized.LFGFrame then return end
				self.initialized.LFGFrame = true

				self:SecureHookScript(_G.LFGParentFrame, "OnShow", function(this)
					self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true})
					self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-11, x2=-29, y2=70})
					if self.modBtns then
						self:skinCloseButton{obj=self:getChild(this, self.isClscERA and 3 or 1), fType=ftype}
					end

					self:SecureHookScript(_G.LFMFrame, "OnShow", function(fObj)
						self:skinObject("dropdown", {obj=_G.LFMFrameEntryDropDown, fType=ftype})
						self:removeInset(_G.LFMFrameInset)
						self:skinObject("dropdown", {obj=_G.LFMFrameTypeDropDown, fType=ftype})
						self:skinObject("dropdown", {obj=_G.LFMFrameActivityDropDown, fType=ftype})
						for i = 1, 4 do
							_G["LFMFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
							self:skinObject("frame", {obj=_G["LFMFrameColumnHeader" .. i], fType=ftype, ofs=0})
						end
						self:skinObject("slider", {obj=_G.LFMListScrollFrame.ScrollBar, fType=ftype})
						self:moveObject{obj=_G.LFMFrameGroupInviteButton, x=-4}
						if self.modBtns then
							self:skinStdButton{obj=_G.LFMFrameGroupInviteButton, fType=ftype}
							self:skinStdButton{obj=_G.LFMFrameSendMessageButton, fType=ftype}
							self:skinStdButton{obj=_G.LFMFrameSearchButton, fType=ftype}
							self:SecureHook(_G.LFMFrameGroupInviteButton, "SetEnabled", function(btn)
								self:clrBtnBdr(btn)
							end)
							self:SecureHook(_G.LFMFrameSendMessageButton, "SetEnabled", function(btn)
								self:clrBtnBdr(btn)
							end)
						end

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.LFMFrame)
					self:SecureHookScript(_G.LFGFrame, "OnShow", function(fObj)
						for _, dd in _G.pairs(fObj.TypeDropDown) do
							self:skinObject("dropdown", {obj=dd, fType=ftype})
						end
						for _, dd in _G.pairs(fObj.ActivityDropDown) do
							self:skinObject("dropdown", {obj=dd, fType=ftype})
						end
						self:skinObject("editbox", {obj=fObj.Comment, fType=ftype, chginset=false, x1=-5})
						self:moveObject{obj=_G.LFGFramePostButton, x=-10}
						if self.modBtns then
							self:skinStdButton{obj=_G.LFGFrameClearAllButton, fType=ftype}
							self:skinStdButton{obj=_G.LFGFramePostButton, fType=ftype}
							self:SecureHook(_G.LFGFramePostButton, "SetEnabled", function(btn, _)
								self:clrBtnBdr(btn)
							end)
						end
						if self.modBtnBs then
							for i = 1, 3 do
								self:addButtonBorder{obj=_G["LFGSearchIcon" .. i .. "Shine"], fType=ftype, x1=-6, y1=3, x2=6, y2=-4, clr="grey"}
							end
							self:SecureHook(fObj, "UpdateActivityIcon", function(frame, i)
								local activityID = _G.UIDropDownMenu_GetSelectedValue(frame.ActivityDropDown[i])
								if activityID then
									self:clrBtnBdr(_G["LFGSearchIcon" .. i .. "Shine"])
								else
									self:clrBtnBdr(_G["LFGSearchIcon" .. i .. "Shine"], "grey")
								end
							end)
						end

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.LFGFrame)

					self:Unhook(this, "OnShow")
				end)
			end
		else
			aObj.blizzLoDFrames[ftype].LookingforGroupUI = function(self)
				if not self.prdb.LookingforGroupUI or self.initialized.LookingforGroupUI then return end
				self.initialized.LookingforGroupUI = true

				self:SecureHookScript(_G.LFGParentFrame, "OnShow", function(this)
					_G.LFGParentFramePortrait:DisableDrawLayer("BACKGROUND")
					_G.LFGParentFramePortrait:DisableDrawLayer("ARTWORK")
					self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true})
					self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-11, x2=-29, y2=71})
					if self.modBtns then
						self:skinCloseButton{obj=self:getChild(this, self.isClscERA and 3 or 1), fType=ftype}
					end

					self:SecureHookScript(_G.LFGListingFrame, "OnShow", function(fObj)
						self:keepFontStrings(fObj)
						for _, roleBtn in pairs(fObj.SoloRoleButtons.RoleButtons) do
							roleBtn:DisableDrawLayer("BACKGROUND")
							roleBtn:SetNormalTexture(self.tFDIDs.lfgIR)
							roleBtn.cover:SetTexture(self.tFDIDs.lfgIR)
							if self.modChkBtns then
								self:skinCheckButton{obj=roleBtn.CheckButton, fType=ftype}
							end
						end
						fObj.GroupRoleButtons.RoleIcon:DisableDrawLayer("BACKGROUND")
						fObj.GroupRoleButtons.RoleIcon:SetNormalTexture(self.tFDIDs.lfgIR)
						fObj.GroupRoleButtons.RoleIcon.cover:SetTexture(self.tFDIDs.lfgIR)

						fObj.NewPlayerFriendlyButton:SetNormalTexture(self.tFDIDs.lfgIR)
						fObj.NewPlayerFriendlyButton.cover:SetTexture(self.tFDIDs.lfgIR)

						for _, btn in pairs(fObj.CategoryView.CategoryButtons) do
							self:keepFontStrings(btn)
							if self.modBtns then
								self:skinStdButton{obj=btn, fType=ftype}
							end
						end
						-- ActivityView
						fObj.ActivityView:DisableDrawLayer("OVERLAY")
						self:skinObject("scrollbar", {obj=fObj.ActivityView.ScrollBar, fType=ftype})
						self:skinObject("frame", {obj=fObj.ActivityView.Comment, fType=ftype, kfs=true, fb=true, ofs=6})

						if self.modBtns then
							self:skinStdButton{obj=fObj.BackButton, fType=ftype, sechk=true}
							self:skinStdButton{obj=fObj.PostButton, fType=ftype, sechk=true}
							self:skinStdButton{obj=fObj.GroupRoleButtons.RolePollButton, fType=ftype, sechk=true}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=fObj.NewPlayerFriendlyButton.CheckButton, fType=ftype}
						end

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.LFGListingFrame)
					if self.modBtnBs
					or self.modChkBtns
					then
						self:SecureHook("LFGListingActivityView_InitActivityGroupButton", function(button, _)
							if self.modBtnBs then
								self:skinExpandButton{obj=button.ExpandOrCollapseButton, fType=ftype, onSB=true}
							end
							if self.modChkBtns then
								self:skinCheckButton{obj=button.CheckButton, fType=ftype}
							end
						end)
						self:SecureHook("LFGListingActivityView_InitActivityButton", function(button, _)
							if self.modChkBtns then
								self:skinCheckButton{obj=button.CheckButton, fType=ftype}
							end
						end)
					end
					self:SecureHookScript(_G.LFGBrowseFrame, "OnShow", function(fObj)
						self:keepFontStrings(fObj)
						self:skinObject("dropdown", {obj=fObj.SearchEntryDropDown, fType=ftype})
						self:skinObject("dropdown", {obj=fObj.CategoryDropDown, fType=ftype})
						self:skinObject("dropdown", {obj=fObj.ActivityDropDown, fType=ftype})
						self:SecureHook("LFGBrowseActivityDropDown_Initialize", function(dropDown, _)
							self:checkDisabledDD(dropDown)
						end)
						self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
						if self.modBtns then
							self:skinStdButton{obj=fObj.SendMessageButton, fType=ftype, sechk=true}
							self:skinStdButton{obj=fObj.GroupInviteButton, fType=ftype, sechk=true}
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=fObj.RefreshButton, fType=ftype, sechk=true, ofs=-2, x1=1, clr="gold"}
						end

						-- tooltip
						_G.C_Timer.After(0.1, function()
							self:add2Table(self.ttList, _G.LFGBrowseSearchEntryTooltip)
						end)

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.LFGBrowseFrame)

					self:Unhook(this, "OnShow")
				end)

				if self.prdb.MinimapButtons.skin
				and self.modBtns
				then
					_G.MiniMapLFGFrameBorder:SetTexture(nil)
					self:skinObject("button", {obj=_G.MiniMapLFGFrame, fType=ftype, ofs=-0})
					self:moveObject{obj=_G.MiniMapLFGFrame, x=-20}
				end

			end
		end
	end

	aObj.blizzFrames[ftype].MainMenuBar = function(self)
		if self.initialized.MainMenuBar then return end
		self.initialized.MainMenuBar = true

		if _G.IsAddOnLoaded("Dominos") then
			self.blizzFrames[ftype].MainMenuBar = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			local skinABBtn, skinMultiBarBtns
			if self.modBtnBs then
				function skinABBtn(btn)
					btn.Border:SetAlpha(0) -- texture changed in blizzard code
					btn.FlyoutBorder:SetTexture(nil)
					btn.FlyoutBorderShadow:SetTexture(nil)
					aObj:addButtonBorder{obj=btn, sabt=true, ofs=3}
					_G[btn:GetName() .. "NormalTexture"]:SetTexture(nil)
				end
				function skinMultiBarBtns(type)
					local bName
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						bName = "MultiBar" .. type .. "Button" .. i
						if not _G[bName].noGrid then
							_G[bName .. "FloatingBG"]:SetAlpha(0)
						end
						skinABBtn(_G[bName])
					end
				end
			end
			self:SecureHookScript(_G.MainMenuBar, "OnShow", function(this)
				_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
				_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
				_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
				_G.MainMenuExpBar:SetSize(1011, 13)
				self:moveObject{obj=_G.MainMenuExpBar, x=1, y=2}
				self:skinObject("statusbar", {obj=_G.MainMenuExpBar, bg=self:getRegion(_G.MainMenuExpBar, 6), other={_G.ExhaustionLevelFillBar}})
				_G.MainMenuBarMaxLevelBar:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarLeftEndCap:SetTexture(nil)
				_G.MainMenuBarRightEndCap:SetTexture(nil)
				local rwbSB = _G.ReputationWatchBar.StatusBar
				self:removeRegions(rwbSB, {1, 2, 3, 4, 5, 6, 7, 8, 9})
				rwbSB:SetSize(1011, 8)
				self:moveObject{obj=rwbSB, x=1, y=2}
				self:skinObject("statusbar", {obj=rwbSB, bg=rwbSB.Background, other={rwbSB.Underlay, rwbSB.Overlay}})
				if self.modBtnBs then
					for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
						skinABBtn(_G["ActionButton" .. i])
					end
					self:addButtonBorder{obj=_G.ActionBarUpButton, ofs=-4, clr="gold"}
					self:addButtonBorder{obj=_G.ActionBarDownButton, ofs=-4, clr="gold"}
					skinMultiBarBtns("BottomLeft")
					skinMultiBarBtns("BottomRight")
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.MainMenuBar)
			if self.modBtnBs then
				skinMultiBarBtns("Right")
				skinMultiBarBtns("Left")
				for _, bName in _G.pairs(_G.MICRO_BUTTONS) do
					self:addButtonBorder{obj=_G[bName], es=24, ofs=2, y1=-18, reParent={_G[bName].QuickKeybindHighlightTexture}, clr="grey"}
				end

				self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true, ofs=3}
				self:addButtonBorder{obj=_G.KeyRingButton, ofs=2, clr="grey"}
			end
		end

		-- this is done here as other AddOns may require it to be skinned
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, clr="grey"}
		end

	end

	aObj.blizzFrames[ftype].MainMenuBarCommon = function(self)
		if self.initialized.MainMenuBarCommon then return end
		self.initialized.MainMenuBarCommon = true

		if _G.IsAddOnLoaded("Bartender4") then
			self.blizzFrames[ftype].MainMenuBarCommon = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			self:SecureHookScript(_G.StanceBarFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				if self.modBtnBs then
					for _, btn in _G.pairs(this.StanceButtons) do
						self:addButtonBorder{obj=btn, abt=true, sft=true, ofs=3, x1=-4}
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.StanceBarFrame)
			-- TODO: change button references when PetActionButtonTemplate & ActionButtonTemplate are fixed
			self:SecureHookScript(_G.PetActionBarFrame, "OnShow", function(this)
				self:keepFontStrings(_G.PetActionBarFrame)
				if self.modBtnBs then
					local bName
					for i = 1, _G.NUM_PET_ACTION_SLOTS do
						bName = "PetActionButton" .. i
						self:addButtonBorder{obj=_G[bName], abt=true, sft=true, reParent={_G[bName .. "AutoCastable"], _G[bName .. "Shine"]}, ofs=3, x2=2}
						_G[bName .. "NormalTexture2"]:SetTexture(nil)
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.PetActionBarFrame)
			if not self.isClscERA then
				self:SecureHookScript(_G.PossessBarFrame, "OnShow", function(this)
					self:keepFontStrings(this)
					if self.modBtnBs then
						for i = 1, _G.NUM_POSSESS_SLOTS do
							self:addButtonBorder{obj=_G["PossessButton" .. i], abt=true, sft=true, ofs=3}
						end
					end

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.PossessBarFrame)
			end
		end

	end

	aObj.blizzFrames[ftype].ProductChoice = function(self)
		if not self.prdb.ProductChoice or self.initialized.ProductChoice then return end
		self.initialized.ProductChoice = true

		self:SecureHookScript(_G.ProductChoiceFrame, "OnShow", function(this)
			for _, btn in _G.pairs(this.Inset.Buttons) do
				btn.IconBorder:SetTexture(nil)
				self:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true})
				btn.Icon:SetAlpha(1)
			end
			self:skinObject("frame", {obj=this.Inset.NoTakeBacksies.Dialog, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Inset.NoTakeBacksies.Dialog.AcceptButton, fType=ftype}
				self:skinStdButton{obj=this.Inset.NoTakeBacksies.Dialog.DeclineButton, fType=ftype}
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=this.Inset.ClaimButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Inset.PrevPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3, clr="gold"}
				self:addButtonBorder{obj=this.Inset.NextPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].PVPFrame = function(self)
			if not self.prdb.PVPFrame or self.initialized.PVPFrame then return end
			self.initialized.PVPFrame = true

			self:SecureHookScript(_G.PVPParentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-12, x2=-32, y2=74})

				self:SecureHookScript(_G.PVPFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj)
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.PVPFrameToggleButton, fType=ftype, clr="gold", x2=1}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.PVPFrame)

				self:SecureHookScript(_G.PVPTeamDetails, "OnShow", function(fObj)
					self:skinObject("dropdown", {obj=_G.PVPDropDown, fType=ftype})
					for i = 1, 5 do
						_G["PVPTeamDetailsFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
						self:skinObject("frame", {obj=_G["PVPTeamDetailsFrameColumnHeader" .. i], fType=ftype, ofs=-1})
					end
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=-2})
					if self.modBtns then
						self:skinStdButton{obj=_G.PVPTeamDetailsAddTeamMember, fType=ftype}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.PVPTeamDetailsToggleButton, fType=ftype, clr="gold", ofs=-1, y1=-2, x2=-2}
					end

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].PVPHelper = function(self)
		if self.initialized.PVPHelper then return end
		self.initialized.PVPHelper = true

		self:SecureHookScript(_G.PVPFramePopup, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			this.RolelessButton.Texture:SetTexture(self.tFDIDs.lfgIR)
			_G.PVPFramePopupRing:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				self:skinOtherButton{obj=this.closeButton, text=self.modUIBtns.minus}
				self:skinStdButton{obj=_G.PVPFramePopupAcceptButton}
				self:skinStdButton{obj=_G.PVPFramePopupDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPReadyDialog, "OnShow", function(this)
			this.Separator:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.enterButton}
				self:skinStdButton{obj=this.hideButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PVPReadyDialog)

	end

	aObj.blizzFrames[ftype].QuestLog = function(self)
		if not self.prdb.QuestLog or self.initialized.QuestLog then return end
		self.initialized.QuestLog = true

		if _G.IsAddOnLoaded("QuestLogEx") then
			self.blizzFrames[ftype].QuestLog = nil
			return
		end

		if self.isClscERA then
			self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
				_G.QuestLogCollapseAllButton:DisableDrawLayer("BACKGROUND")
				self:keepFontStrings(_G.EmptyQuestLogFrame)
				self:skinObject("slider", {obj=_G.QuestLogListScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype})
				_G.QuestLogQuestTitle:SetTextColor(self.HT:GetRGB())
				_G.QuestLogObjectivesText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogTimerText:SetTextColor(self.BT:GetRGB())
				for i = 1, _G.MAX_OBJECTIVES do
					_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
				end
				_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogDescriptionTitle:SetTextColor(self.HT:GetRGB())
				_G.QuestLogQuestDescription:SetTextColor(self.BT:GetRGB())
				_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
				_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogSpellLearnText:SetTextColor(self.BT:GetRGB())
				for i = 1, _G.MAX_NUM_ITEMS do
					_G["QuestLogItem" .. i .. "NameFrame"]:SetTexture(nil)
					if self.modBtns then
						 self:addButtonBorder{obj=_G["QuestLogItem" .. i], libt=true, clr="grey"}
					end
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=-33, y2=48})
				if self.modBtns then
					self:skinExpandButton{obj=_G.QuestLogCollapseAllButton, fType=ftype, onSB=true}
					for i = 1, _G.QUESTS_DISPLAYED do
						self:skinExpandButton{obj=_G["QuestLogTitle" .. i], fType=ftype, noddl=true, onSB=true}
						self:checkTex{obj=_G["QuestLogTitle" .. i]}
					end
					self:SecureHook("QuestLog_Update", function()
						for i = 1, _G.QUESTS_DISPLAYED do
							self:checkTex{obj=_G["QuestLogTitle" .. i]}
						end
					end)
					self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, schk=true, x1=2, x2=-2}
					self:skinStdButton{obj=_G.QuestFrameExitButton, fType=ftype}
					self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, schk=true, x1=2, x2=-2}
				end

				self:SecureHook("QuestLog_UpdateQuestDetails", function(_)
					for i = 1, _G.MAX_OBJECTIVES do
						_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
					end
					_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
					_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
					_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
					_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
				end)

				self:Unhook(this, "OnShow")
			end)
		else
			if self.modBtns then
				self:SecureHookScript(_G.QuestLogControlPanel, "OnShow", function(this)
					self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, fType=ftype, schk=true, x1=2, x2=-2}
					self:skinStdButton{obj=_G.QuestLogFrameTrackButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.QuestFramePushQuestButton, fType=ftype, schk=true, x1=2, x2=-2}

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.QuestLogControlPanel)
			end
			self:SecureHookScript(_G.QuestLogDetailFrame, "OnShow", function(this)
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=1, y1=-11})

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
				self:keepFontStrings(_G.EmptyQuestLogFrame)
				self:keepFontStrings(_G.QuestLogCount)
				self:skinObject("slider", {obj=_G.QuestLogListScrollFrame.scrollBar, fType=ftype})
				self:skinObject("slider", {obj=_G.QuestLogDetailScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=0, y2=4})
				if self.modBtns then
					for _, btn in _G.pairs(_G.QuestLogListScrollFrame.buttons) do
						self:skinExpandButton{obj=btn, fType=ftype, noddl=true, onSB=true}
						self:checkTex{obj=btn}
					end
					self:SecureHook(_G.QuestLogListScrollFrame, "update", function()
						for _, btn in _G.pairs(_G.QuestLogListScrollFrame.buttons) do
							self:checkTex{obj=btn}
						end
					end)
					self:skinStdButton{obj=_G.QuestLogFrameCancelButton, fType=ftype, x1=2, x2=-2}
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	if aObj.isClscERA then
		aObj.blizzFrames[ftype].QuestTimer = function(self)
			if not self.prdb.QuestTimer or self.initialized.QuestTimer then return end
			self.initialized.QuestTimer = true

			self:SecureHookScript(_G.QuestTimerFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=20, y1=4, x2=-20, y2=10})

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].RaidFrame = function(self)
		if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
		self.initialized.RaidFrame = true

		self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.RaidInfoScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=_G.RaidInfoFrame, fType=ftype, kfs=true, hdr=true})
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton, fType=ftype, schk=true}
				self:SecureHook("RaidFrame_Update", function()
					self:clrBtnBdr(_G.RaidFrameConvertToRaidButton)
				end)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if not aObj.isClscERAPTR then
		aObj.blizzFrames[ftype].SystemOptions = function(self)
			if not self.prdb.SystemOptions or self.initialized.SystemOptions then return end
			self.initialized.SystemOptions = true

			self:SecureHookScript(_G.VideoOptionsFrame, "OnShow", function(this)
				if self.isRtl then
					self:removeNineSlice(this.Border)
				end
				self:skinObject("frame", {obj=_G.VideoOptionsFrameCategoryFrame, fType=ftype, kfs=true, rns=true, fb=true})
				self:skinObject("slider", {obj=_G.VideoOptionsFrameCategoryFrameListScrollBar, fType=ftype, x1=4, x2=-5})
				self:skinObject("frame", {obj=_G.VideoOptionsFramePanelContainer, fType=ftype, kfs=true, rns=true, fb=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
				_G.VideoOptionsFrameApply:SetFrameLevel(2) -- make it appear above the PanelContainer
				if self.modBtns then
					self:skinStdButton{obj=_G.VideoOptionsFrameApply, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.VideoOptionsFrameCancel, fType=ftype}
					self:skinStdButton{obj=_G.VideoOptionsFrameOkay, fType=ftype}
					self:skinStdButton{obj=_G.VideoOptionsFrameDefaults, fType=ftype}
					if not self.isRtl then
						self:skinStdButton{obj=_G.VideoOptionsFrameClassic, fType=ftype}
					end
				end
				-- Top Tabs
				self:skinObject("tabs", {obj=_G.Display_, tabs={_G.GraphicsButton, _G.RaidButton}, fType=ftype, upwards=true, offsets={x1=4, y1=0, x2=0, y2=self.isTT and -3 or 2}, track=false, func=function(tab) tab:SetFrameLevel(20) tab.SetFrameLevel = _G.nop end})
				if self.isTT then
					self:SecureHook("GraphicsOptions_SelectBase", function()
						self:setActiveTab(_G.GraphicsButton.sf)
						self:setInactiveTab(_G.RaidButton.sf)
					end)
					self:SecureHook("GraphicsOptions_SelectRaid", function()
						if _G.Display_RaidSettingsEnabledCheckBox:GetChecked() then
							self:setActiveTab(_G.RaidButton.sf)
							self:setInactiveTab(_G.GraphicsButton.sf)
						end
					end)
				end
				skinKids(_G.Display_, ftype)
				self:skinObject("frame", {obj=_G.Display_, fType=ftype, kfs=true, rns=true, fb=true})
				skinKids(_G.Graphics_, ftype)
				self:skinObject("frame", {obj=_G.Graphics_, fType=ftype, kfs=true, rns=true, fb=true})
				skinKids(_G.RaidGraphics_, ftype)
				self:skinObject("frame", {obj=_G.RaidGraphics_, fType=ftype, kfs=true, rns=true, fb=true})

				self:Unhook(this, "OnShow")
			end)
			self:SecureHook("VideoOptionsDropDownMenu_DisableDropDown", function(dropDown)
				self:checkDisabledDD(dropDown)
			end)
			self:SecureHook("VideoOptionsDropDownMenu_EnableDropDown", function(dropDown)
				self:checkDisabledDD(dropDown)
			end)

			-- Advanced
			self:SecureHookScript(_G.Advanced_, "OnShow", function(this)
				skinKids(this, ftype)

				self:Unhook(this, "OnShow")
			end)
			-- Network
			self:SecureHookScript(_G.NetworkOptionsPanel, "OnShow", function(this)
				skinKids(this, ftype)

				self:Unhook(this, "OnShow")
			end)
			-- Languages
			self:SecureHookScript(_G.InterfaceOptionsLanguagesPanel, "OnShow", function(this)
				skinKids(this, ftype)

				self:Unhook(this, "OnShow")
			end)
			-- Keyboard
			self:SecureHookScript(_G.MacKeyboardOptionsPanel, "OnShow", function(this)
				-- Languages
				skinKids(this, ftype)

				self:Unhook(this, "OnShow")
			end)
			-- Sound
			self:SecureHookScript(_G.AudioOptionsSoundPanel, "OnShow", function(this)
				skinKids(this, ftype)
				self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelPlayback, fType=ftype, kfs=true, rns=true, fb=true})
				self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelHardware, fType=ftype, kfs=true, rns=true, fb=true})
				self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelVolume, fType=ftype, kfs=true, rns=true, fb=true})

				self:Unhook(this, "OnShow")
			end)
			-- Voice
			self:SecureHookScript(_G.AudioOptionsVoicePanel, "OnShow", function(this)
				self.iofBtn[this.PushToTalkKeybindButton] = true
				skinKids(this, ftype)
				this.TestInputDevice.ToggleTest:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=this.TestInputDevice.VUMeter, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtnBs then
					self:addButtonBorder{obj=this.TestInputDevice.ToggleTest, fType=ftype, ofs=0, y2=-2}
					self:skinStdButton{obj=this.PushToTalkKeybindButton, fType=ftype}
					this.PushToTalkKeybindButton.KeyLabel:SetDrawLayer("ARTWORK")
				end

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].Tutorial = function(self)
		if not self.prdb.Tutorial or self.initialized.Tutorial then return end
		self.initialized.Tutorial = true

		self:SecureHookScript(_G.TutorialFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.TutorialFrameOkayButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.TutorialFrameCheckButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		if self.modBtns then
			_G.C_Timer.After(0.5, function()
				local btn
				for i = 1, 10 do
					btn = _G["TutorialFrameAlertButton" .. i]
					self:moveObject{obj=btn:GetHighlightTexture(), x=3}
					self:skinOtherButton{obj=btn, fType=ftype, sap=true, font="ZoneTextFont", text="!"}
				end
			end)
		end

	end

	aObj.blizzFrames[ftype].WorldMap = function(self)
		if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
		self.initialized.WorldMap = true

		self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)
			if not _G.IsAddOnLoaded("Mapster")
			and not _G.IsAddOnLoaded("AlleyMap")
			then
				self:keepFontStrings(_G.WorldMapFrame)
				self:skinObject("frame", {obj=_G.WorldMapFrame.BorderFrame, fType=ftype, kfs=true, ofs=1})
				-- make sure map textures are displayed
				_G.WorldMapFrame.BorderFrame.sf:SetFrameStrata("LOW")
			end

			self:skinObject("dropdown", {obj=_G.WorldMapContinentDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.WorldMapZoneDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.WorldMapZoneMinimapDropDown, fType=ftype})
			if self.modBtns then
				self:skinCloseButton{obj=_G.WorldMapFrameCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.WorldMapZoomOutButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].WorldStateScoreFrame = function(self)
		if not self.prdb.WorldStateScoreFrame or self.initialized.WorldStateScoreFrame then return end
		self.initialized.WorldStateScoreFrame = true

		self:SecureHookScript(_G.WorldStateScoreFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.WorldStateScoreScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-15, x2=-114, y2=70})
			if self.modBtns then
				self:skinStdButton{obj=_G.WorldStateScoreFrameLeaveButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	-- TODO:
		-- UnitPopup

	-- VideoOptionsFrame, wait for variable to be populated
	if aObj.modBtns then
		_G.C_Timer.After(1, function()
			aObj:skinStdButton{obj=_G.VideoOptionsFrameClassic, fType=ftype}
		end)
	end

end

aObj.SetupClassic_UIFramesOptions = function(self)

	local optTab = {
		["Battlefield Frame"]       = true,
		["Binding UI"]              = {desc = "Key Bindings UI"},
		["GM Survey UI"]            = self.isClscERA and true or nil,
		["Interface Options"]       = true,
		["LookingforGroupUI"]       = self.isClsc and _G.C_LFGList.IsLookingForGroupEnabled() and {desc = "Group Finder"} or nil,
		["LFGLFM"]                  = self.isClscERA and _G.C_LFGList.IsLookingForGroupEnabled() or nil,
		["Product Choice"]          = {suff = "Frame"},
		["PVP Frame"]               = self.isClsc and true or nil,
		["Quest Log"]               = true,
		["Quest Timer"]             = true,
		["System Options"]          = true,
		["World State Score Frame"] = {desc = "Battle Score Frame"},
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end

