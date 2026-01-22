if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupClassic_PlayerFrames = function()
	local ftype = "p"

	if aObj.isClsc then
		aObj.blizzLoDFrames[ftype].BarberShopUI = function(self)
			if not self.prdb.BarberShopUI or self.initialized.BarberShopUI then return end
			self.initialized.BarberShopUI = true

			self:SecureHookScript(_G.BarberShopFrame, "OnShow", function(this)
				_G.BarberShopFrameMaleButton:DisableDrawLayer("BACKGROUND") -- Shadow texture
				_G.BarberShopFrameFemaleButton:DisableDrawLayer("BACKGROUND") -- Shadow texture
				_G.BarberShopFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-15})
				if self.modBtns then
					self:skinStdButton{obj=_G.BarberShopFrameOkayButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.BarberShopFrameCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.BarberShopFrameResetButton, fType=ftype, schk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.BarberShopFrameMaleButton, fType=ftype}
					self:addButtonBorder{obj=_G.BarberShopFrameFemaleButton, fType=ftype}
					for _, btn in _G.pairs(_G.BarberShopFrame.Selector) do
						self:addButtonBorder{obj=btn.Prev, fType=ftype, ofs=-2, x1=1, clr="gold"}
						self:addButtonBorder{obj=btn.Next, fType=ftype, ofs=-2, x1=1, clr="gold"}
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.BarberShopFrame)

			self:SecureHookScript(_G.BarberShopBannerFrame, "OnShow", function(this)
				_G.BarberShopBannerFrameBGTexture:SetAlpha(0)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.BarberShopBannerFrame)

			self:SecureHookScript(_G.BarbersChoiceConfirmFrame, "OnShow", function(this)
				_G.BarbersChoiceConfirmFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-35})
				if self.modBtns then
					self:skinStdButton{obj=_G.BarbersChoiceConfirmFrameBarbersChoiceOkayButton, fType=ftype}
					self:skinStdButton{obj=_G.BarbersChoiceConfirmFrameBarbersChoiceCancelButton, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

		end
	end

	if not aObj.isClscBCA then
		aObj.blizzFrames[ftype].Buffs = function(self)
			if not self.prdb.Buffs or self.initialized.Buffs then return end
			self.initialized.Buffs = true

			if self.modBtnBs then
				local function skinBuffBtn(btn)
					if btn
					and not btn.sbb
					then
						aObj:addButtonBorder{obj=btn, fType=ftype, reParent={btn.count, btn.duration}, ofs=3}
					end
				end
				-- skin current Buffs
				for i = 1, _G.BUFF_MAX_DISPLAY do
					skinBuffBtn(_G["BuffButton" .. i])
				end
				-- if not all buff buttons created yet
				if not _G.BuffButton32 then
					-- hook this to skin new Buffs
					self:SecureHook("AuraButton_Update", function(buttonName, index, _)
						if buttonName == "BuffButton" then
							skinBuffBtn(_G[buttonName .. index])
						end
					end)
				end
			end

			-- Debuffs already have a coloured border
			-- Temp Enchants already have a coloured border

		end
	end

	aObj.blizzFrames[ftype].CastingBar = function(self)
		if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
		self.initialized.CastingBar = true

		if _G.C_AddOns.IsAddOnLoaded("Quartz")
		or _G.C_AddOns.IsAddOnLoaded("Dominos_Cast")
		then
			self.blizzFrames[ftype].CastingBar = nil
			return
		end

		local function setLook(castBar, look)
			castBar.Border:SetAlpha(0)
			castBar.Flash:SetAllPoints()
			castBar.Flash:SetTexture(self.tFDIDs.w8x8)
			if look == "CLASSIC" then
				castBar.Text:SetPoint("TOP", 0, 2)
				castBar.Spark.offsetY = -1
			end
		end
		local cbFrame
		for _, type in _G.pairs{"", "Pet"} do
			cbFrame = _G[type .. "CastingBarFrame"]
			if cbFrame then
				self:changeShield(cbFrame.BorderShield, cbFrame.Icon)
				if self.prdb.CastingBar.glaze then
					self:skinObject("statusbar", {obj=cbFrame, fType=ftype, fi=0, bg=self:getRegion(cbFrame, 1), nilFuncs=true})
				end
				-- adjust text and spark in Classic mode
				if not cbFrame.ignoreFramePositionManager then
					setLook(cbFrame)
				else
					setLook(cbFrame, "CLASSIC")
				end
				if cbFrame.SetLook then
					self:SecureHook(cbFrame, "SetLook", function(this, look)
						setLook(this, look)
					end)
				end
			end
		end

		-- hook this to handle the CastingBar being attached to the Unitframe and then reset
		if _G.CastingBarFrame_SetLook then
			self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
				setLook(castBar, look)
			end)
		end

	end

	if aObj.isClscERA then
		aObj.blizzFrames[ftype].CharacterFrames = function(self)
			if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
			self.initialized.CharacterFrames = true

			-- skin tabs here, so they show correct textures when selected
			self:skinObject("tabs", {obj=_G.CharacterFrame, prefix=_G.CharacterFrame:GetName(), fType=ftype, lod=self.isTT and true})

			self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-12, x2=-31, y2=74})

				self:Unhook(this, "OnShow")
			end)

			local pdfSlots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged"}
			self:SecureHookScript(_G.PaperDollFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:makeMFRotatable(_G.CharacterModelFrame)
				_G.CharacterAttributesFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					for i = 1, _G.NUM_RESISTANCE_TYPES do
						self:addButtonBorder{obj=_G["MagicResFrame" .. i], fType=ftype, es=24, ofs=2, x1=-1, y2=-4}
					end
					self:SecureHook("PaperDollItemSlotButton_Update", function(bObj)
						if bObj.sbb then
							if not bObj.hasItem then
								self:clrBtnBdr(bObj, "grey")
								bObj.icon:SetTexture(nil)
							else
								bObj.sbb:SetBackdropBorderColor(bObj.icon:GetVertexColor())
							end
						end
					end)
					local btn
					for _, sName in _G.ipairs(pdfSlots) do
						btn = _G["Character" .. sName .. "Slot"]
						self:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.ignoreTexture}}
						_G.PaperDollItemSlotButton_Update(btn)
					end
					btn = _G.CharacterAmmoSlot
					btn:DisableDrawLayer("BACKGROUND")
					btn.icon = _G.CharacterAmmoSlotIconTexture
					self:addButtonBorder{obj=btn, fType=ftype, reParent={self:getRegion(btn, 4)}, ofs=3}
					_G.PaperDollItemSlotButton_Update(btn)
					self:addButtonBorder{obj=_G.RuneFrameControlButton, fType=ftype}
				end
				if self.isClscBCA then
					self:skinObject("ddbutton", {obj=this.Attributes.LeftPlayerStatDropdown, fType=ftype})
					self:skinObject("ddbutton", {obj=this.Attributes.RightPlayerStatDropdown, fType=ftype})
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:skinObject("statusbar", {obj=_G.PetPaperDollFrameExpBar, fType=ftype, regions={1, 2}, fi=0})
				self:makeMFRotatable(_G.PetModelFrame)
				_G.PetAttributesFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinStdButton{obj=_G.PetPaperDollCloseButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.PetPaperDollPetInfo, fType=ftype, ofs=1, x2=0, clr="gold"}
					for i = 1, _G.NUM_PET_RESISTANCE_TYPES do
						self:addButtonBorder{obj=_G["PetMagicResFrame" .. i], fType=ftype, es=24, ofs=2, y1=3, y2=-4}
					end
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				local awc
				for i = 1, _G.NUM_FACTIONS_DISPLAYED do
					if self.modBtns then
						if self.isClscERA then
							self:skinExpandButton{obj=_G["ReputationHeader" .. i], fType=ftype, onSB=true}
							self.modUIBtns:checkTex{obj=_G["ReputationHeader" .. i]}
							self:skinObject("statusbar", {obj=_G["ReputationBar" .. i], fType=ftype, regions={1, 2}, fi=0})
							awc = self:getRegion(_G["ReputationBar" .. i .. "AtWarCheck"], 1)
							awc:SetTexture(self.tFDIDs.cbSC)
							awc:SetTexCoord(0, 1, 0, 1)
							awc:SetSize(32, 32)
						else
							self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], fType=ftype, onSB=true}
							self.modUIBtns:checkTex{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"]}
							self:skinObject("statusbar", {obj=_G["ReputationBar" .. i .. "ReputationBar"], fType=ftype, regions={3, 4}, fi=0})
							self:removeRegions(_G["ReputationBar" .. i], {1, 2, 3})
						end
					end
				end
				self:skinObject("slider", {obj=_G.ReputationListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("frame", {obj=_G.ReputationDetailFrame, fType=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6})
				if self.modBtns then
					self:skinCloseButton{obj=_G.ReputationDetailCloseButton, fType=ftype}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckbox, fType=ftype}
					self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckbox, fType=ftype}
					self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckbox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.SkillFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				_G.SkillFrameExpandButtonFrame:DisableDrawLayer("BACKGROUND")
				for i = 1, _G.SKILLS_TO_DISPLAY do
					if self.modBtns then
						 self:skinExpandButton{obj=_G["SkillTypeLabel"  .. i], fType=ftype, onSB=true, minus=true}
					end
					_G["SkillRankFrame"  .. i .. "BorderNormal"]:SetTexture(nil)
					self:skinObject("statusbar", {obj=_G["SkillRankFrame"  .. i], fType=ftype, fi=0, other={_G["SkillRankFrame"  .. i .. "FillBar"]}})
				end
				self:skinObject("slider", {obj=_G.SkillListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("slider", {obj=_G.SkillDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:removeRegions(_G.SkillDetailStatusBar, {1})
				self:skinObject("statusbar", {obj=_G.SkillDetailStatusBar, fType=ftype, fi=0, other={_G.SkillDetailStatusBarFillBar}})
				if self.modBtns then
					self:skinExpandButton{obj=_G.SkillFrameCollapseAllButton, fType=ftype, onSB=true, minus=true}
					self:skinStdButton{obj=_G.SkillFrameCancelButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.SkillDetailStatusBarUnlearnButton, fType=ftype, ofs=-4, x1=6, y2=7}
				end

				self:Unhook(this, "OnShow")
			end)

			if not self.isClscBCA then
				self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
					self:keepFontStrings(this)
					self:skinObject("statusbar", {obj=_G.HonorFrameProgressBar, fType=ftype, fi=0})

					self:Unhook(this, "OnShow")
				end)
			else
				self:SecureHookScript(_G.PVPFrame, "OnShow", function(this)
					self:keepFontStrings(this)

				    self:Unhook(this, "OnShow")
				end)
			end

		end
	end

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		local function skinBag(frame, _)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=8, y1=-4, x2=-3})
			-- resize and move the bag name to make it more readable
			local objName = frame:GetName()
			_G[objName .. "Name"]:SetWidth(137)
			aObj:moveObject{obj=_G[objName .. "Name"], x=-17}
			if aObj.modBtns then
				_G[objName .. "AddSlotsButton"]:DisableDrawLayer("OVERLAY")
				aObj:skinStdButton{obj=_G[objName .. "AddSlotsButton"], fType=ftype}
			end
			if aObj.modBtnBs then
				local bo
				for i = 1, _G.MAX_CONTAINER_ITEMS do
					bo = _G[objName .. "Item" .. i]
					aObj:addButtonBorder{obj=bo, fType=ftype, ibt=true, reParent={bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
					aObj:add2Table(aObj.btnIgnore, bo)
				end
				-- update Button quality borders
				_G.ContainerFrame_Update(frame)
			end
			if objName == "ContainerFrame1" then
				aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
			end
		end
		self:SecureHook("ContainerFrame_GenerateFrame", function(fObj, id)
			-- skin the frame if required
			if not fObj.sf then
				skinBag(fObj, id)
			end
		end)

		if self.modBtns then
			self:SecureHookScript(_G.BagHelpBox, "OnShow", function(this)
				self:skinCloseButton{obj=this.CloseButton, fType=ftype, noSkin=true}

				self:Unhook(this, "OnShow")
			end)
		end

	end

	local function skinaTS(parent)
		if _G.C_AddOns.IsAddOnLoaded("alaTradeSkill") then
			aObj:keepFontStrings(parent.frame.TextureBackground)
			parent.frame.TabFrame:ClearAllPoints()
			parent.frame.TabFrame:SetPoint("BOTTOM", parent, "TOP", 0, -13)
			aObj:skinObject("frame", {obj=parent.frame.TabFrame, fType=ftype, fb=true})
			aObj:skinObject("frame", {obj=parent.frame.ProfitFrame, fType=ftype, kfs=true, ofs=0})
			aObj:skinObject("frame", {obj=parent.frame.SetFrame, fType=ftype, kfs=true, ofs=0, y1=2})
			aObj:skinObject("slider", {obj=parent.frame.SetFrame.PhaseSlider, fType=ftype})
		end
	end
	aObj.blizzLoDFrames[ftype].CraftUI = function(self)
		if not self.prdb.CraftUI or self.initialized.CraftUI then return end
		self.initialized.CraftUI = true

		self:SecureHookScript(_G.CraftFrame, "OnShow", function(this)
			if self.isClsc then
				self:skinObject("dropdown", {obj=_G.CraftFrameFilterDropDown, fType=ftype})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.CraftFrameAvailableFilterCheckButton, fType=ftype}
				end
			end
			self:skinObject("statusbar", {obj=_G.CraftRankFrame, fType=ftype, fi=0, bg=_G.CraftRankFrameBackground})
			_G.CraftRankFrameBorder:GetNormalTexture():SetTexture(nil)
			self:keepFontStrings(_G.CraftExpandButtonFrame)
			self:keepFontStrings(_G.CraftDetailScrollChildFrame)
			local x1, y1, x2, y2
			if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -31, 71
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.CraftIcon, fType=ftype, clr="gold"}
			end
			if not _G.C_AddOns.IsAddOnLoaded("alaTradeSkill") then
				self:skinObject("slider", {obj=_G.CraftListScrollFrameScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("slider", {obj=_G.CraftDetailScrollFrameScrollBar, fType=ftype, rpTex="background"})
				local btnName
				for i = 1, _G.MAX_CRAFT_REAGENTS do
					btnName = "CraftReagent" .. i
					_G[btnName].NameFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=_G[btnName], fType=ftype, libt=true, clr={_G[btnName .. "IconTexture"]:GetVertexColor()}}
					end
				end
				if self.modBtns then
					self:skinCloseButton{obj=_G.CraftFrameCloseButton, fType=ftype}
					self:skinExpandButton{obj=_G.CraftCollapseAllButton, fType=ftype, onSB=true}
					self:skinStdButton{obj=_G.CraftCreateButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.CraftCancelButton, fType=ftype}
				end
			else
				skinaTS(this)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if _G.C_AddOns.IsAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			_G.SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND") -- model controls background
			self:removeRegions(_G.SideDressUpModelCloseButton, {5}) -- corner texture
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=1, y1=-3, x2=-2})
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpModelResetButton, fType=ftype}
				self:skinCloseButton{obj=_G.SideDressUpModelCloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:makeMFRotatable(_G.DressUpModelFrame)
			if not self.prdb.DUTexture then
				self:keepFontStrings(this)
			end
			if self.prdb.DUTexture then
				self:keepRegions(this, {8, 19, 20, 21, 22, 23, 24})
			end
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=_G.DressUpFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=this.ResetButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClscERA then
		aObj.blizzLoDFrames[ftype].EngravingUI = function(self) -- Runes panel next to Character frame
			if not self.prdb.CharacterFrames or self.initialized.EngravingUI then return end
			self.initialized.EngravingUI = true

			self:SecureHookScript(_G.EngravingFrame, "OnShow", function(this)
				self:removeInset(this.sideInset)
				self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype})
				self:skinObject("editbox", {obj=_G.EngravingFrameSearchBox, fType=ftype, si=true})
				self:skinObject("dropdown", {obj=_G.EngravingFrameFilterDropDown, fType=ftype})
				self:skinObject("slider", {obj=_G.EngravingFrameScrollFrameScrollBar, fType=ftype})
				self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, rns=true, ofs=1, y2=1})
				local i = 1
				local hdr = _G["EngravingFrameHeader" .. i]
				while hdr do
					hdr.middle:SetTexture(nil)
					hdr.leftEdge:SetTexture(nil)
					hdr.rightEdge:SetTexture(nil)
					i = i + 1
					hdr = _G["EngravingFrameHeader" .. i]
				end
				for _, bObj in _G.ipairs(this.scrollFrame.buttons) do
					bObj:GetNormalTexture():SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=bObj, fType=ftype, relTo=bObj.icon, clr="white"}
					end
				end

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=_G.FriendsDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.TravelPassDropDown, fType=ftype})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1, y2=self.isClscERA and -1 or -2})

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(fObj)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, fType=ftype, kfs=true, fb=true, ofs=4})
				if self.modBtns then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, fType=ftype, ofs=-2, x1=1, y1=-1}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton, fType=ftype}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton, fType=ftype}
				end
				_G.FriendsFrameBattlenetFrame.BroadcastFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, fType=ftype, ofs=-10})
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.StatusDropdown, fType=ftype})
				self:skinObject("editbox", {obj=_G.FriendsFrameBroadcastInput, fType=ftype})
				_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BT:GetRGB())
				-- Top Tabs
				self:skinObject("tabs", {obj=fObj, prefix=fObj:GetName(), numTabs=2, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=0, y1=-5, x2=0, y2=-4}})
				_G.RaiseFrameLevel(fObj)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(fObj)
				_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
				self:skinObject("slider", {obj=_G.FriendsFrameFriendsScrollFrame.scrollBar, fType=ftype, rpTex="background"})
				local btn
				for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
					btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
					btn.background:SetAlpha(0)
					if self.modBtnBs then
						-- N.B. DON'T skin btn.gameIcon
						self:addButtonBorder{obj=btn.travelPassButton, fType=ftype, schk=true, ofs=0, y1=3, y2=-2}
						self:addButtonBorder{obj=btn.summonButton, fType=ftype, schk=true}
					end
				end
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, y1=-81, x2=-1, y2=self.isClscERA and 1 or 0})
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton, fType=ftype}
					self:skinStdButton{obj=self:getChild(fObj.RIDWarning, 1), fType=ftype} -- unnamed parent frame
					for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
						self:skinStdButton{obj=invite.DeclineButton, fType=ftype}
						self:skinStdButton{obj=invite.AcceptButton, fType=ftype}
					end
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("slider", {obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, y1=-81, x2=-1})
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton, fType=ftype}
					self:SecureHook("IgnoreList_Update", function()
						self:clrBtnBdr(_G.FriendsFrameUnsquelchButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(fObj)
				self:removeInset(_G.WhoFrameListInset)
				for i = 1, 4 do
					_G["WhoFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					if i == 2 then
						_G.WhoFrameDropdown:DisableDrawLayer("BACKGROUND")
						self:skinObject("ddbutton", {obj=_G.WhoFrameDropdown, fType=ftype})
						self:moveObject{obj=_G.WhoFrameDropdown, x=20}
					else
						self:skinObject("frame", {obj=_G["WhoFrameColumnHeader" .. i], fType=ftype, y2=-2})
					end
				end
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
				self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype, si=true, y1=-6, y2=6})
				self:skinObject("slider", {obj=_G.WhoListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.WhoFrameWhoButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildFrame, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				_G.GuildFrameLFGFrame:DisableDrawLayer("BACKGROUND")
				for i = 1, 4 do
					_G["GuildFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					_G["GuildFrameGuildStatusColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					self:skinObject("frame", {obj=_G["GuildFrameColumnHeader" .. i], fType=ftype, ofs=0})
					self:skinObject("frame", {obj=_G["GuildFrameGuildStatusColumnHeader" .. i], fType=ftype, ofs=0})
				end
				self:skinObject("slider", {obj=_G.GuildListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				if self.modBtns then
					self:skinStdButton{obj=_G.GuildFrameImpeachButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildFrameControlButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameAddMemberButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameGuildInformationButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.GuildFrameGuildListToggleButton, fType=ftype, ofs=-2, clr="gold"}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.GuildFrameLFGButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildControlPopupFrame, "OnShow", function(fObj)
				self:skinObject("ddbutton", {obj=_G.GuildControlPopupFrameDropdown, fType=ftype})
				self:skinObject("editbox", {obj=_G.GuildControlPopupFrameEditBox, fType=ftype, regions={3, 4}, y1=-4, y2=4})
				if self.isClsc then
					self:skinObject("editbox", {obj=_G.GuildControlWithdrawGoldEditBox, fType=ftype, y1=-4, y2=4})
					self:skinObject("editbox", {obj=_G.GuildControlWithdrawItemsEditBox, fType=ftype, y1=-4, y2=4})
					for i = 1, _G.MAX_GUILDBANK_TABS do
						self:keepFontStrings(_G["GuildBankTabPermissionsTab" .. i])
					end
					self:skinObject("frame", {obj=_G.GuildControlPopupFrameTabPermissions, fType=ftype, fb=true})
					if self.modBtns then
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsViewTab, fType=ftype}
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsDepositItems, fType=ftype}
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsUpdateText, fType=ftype}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.GuildControlPopupFrameCheckbox15, fType=ftype} -- Repair
						self:skinCheckButton{obj=_G.GuildControlPopupFrameCheckbox16, fType=ftype} -- Withdraw Gold
					end
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4, y2=25})
				else
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4})
				end
				if self.modBtns then
					self:skinStdButton{obj=_G.GuildControlPopupFrameCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildControlPopupAcceptButton, fType=ftype, schk=true}
					self:skinExpandButton{obj=_G.GuildControlPopupFrameAddRankButton, fType=ftype, plus=true, ofs=0}
					self:skinExpandButton{obj=_G.GuildControlPopupFrameRemoveRankButton, fType=ftype, ofs=0}
					self:SecureHook("GuildControlPopupFrameRemoveRankButton_OnUpdate", function()
						self:clrBtnBdr(_G.GuildControlPopupFrameRemoveRankButton)
					end)
				end
				if self.modChkBtns then
					for i = 1, _G.GUILD_NUM_RANK_FLAGS do
						self:skinCheckButton{obj=_G["GuildControlPopupFrameCheckbox" .. i], fType=ftype}
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(fObj)
				self:moveObject{obj=fObj, y=-2}
				self:skinObject("slider", {obj=_G.GuildInfoFrameScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("frame", {obj=_G.GuildInfoTextBackground, fType=ftype, fb=true})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-2})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildInfoCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoSaveButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoGuildEventButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildMemberDetailFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("OVERLAY")
				self:skinObject("frame", {obj=_G.GuildMemberNoteBackground, fType=ftype, fb=true})
				self:skinObject("frame", {obj=_G.GuildMemberOfficerNoteBackground, fType=ftype, fb=true})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton, fType=ftype} -- N.B. name DOESN'T contain Frame
					self:skinStdButton{obj=_G.GuildMemberRemoveButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildMemberGroupInviteButton, fType=ftype, schk=true}
				end
				-- TODO: skin small Promote/Demote buttons
				-- GuildFramePromoteButton
				-- GuildFrameDemoteButton

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildEventLogFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=_G.GuildEventFrame, fType=ftype, kfs=true, fb=true, ofs=0})
				self:skinObject("slider", {obj=_G.GuildEventLogScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, ofs=-6})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildEventLogCloseButton, fType=ftype} -- N.B. name DOESN'T contain Frame
					self:skinStdButton{obj=_G.GuildEventLogCancelButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=_G.AddFriendNameEditBox, fType=ftype})
			self:skinObject("slider", {obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=_G.AddFriendNoteFrame, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton, fType=ftype}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton, fType=ftype, clr="disabled"}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton, fType=ftype}
				self:SecureHookScript(_G.AddFriendNameEditBox, "OnTextChanged", function(_)
					self:clrBtnBdr(_G.AddFriendEntryFrameAcceptButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.FriendsDropdown, fType=ftype})
			self:skinObject("frame", {obj=_G.FriendsFriendsList, fType=ftype, fb=true})
			self:skinObject("slider", {obj=_G.FriendsFriendsScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFriendsSendRequestButton, fType=ftype}
				self:skinStdButton{obj=_G.FriendsFriendsCloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 1), fType=ftype} -- Send Request
				self:skinStdButton{obj=self:getChild(this, 2), fType=ftype} -- Cancel
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			self:skinObject("slider", {obj=this.ChannelList.ScrollBar, fType=ftype})
			self:skinObject("slider", {obj=this.ChannelRoster.ScrollFrame.scrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x1=-5, x2=1, y2=-1})
			-- Create Channel Popup
			self:skinObject("editbox", {obj=_G.CreateChannelPopup.Name, fType=ftype, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.CreateChannelPopup.Password, fType=ftype, y1=4, y2=-4})
			self:skinObject("frame", {obj=_G.CreateChannelPopup, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.CreateChannelPopup.OKButton, fType=ftype}
				self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton, fType=ftype}
				self:skinStdButton{obj=this.NewButton, fType=ftype}
				self:skinStdButton{obj=this.SettingsButton, fType=ftype}
				self:skinCloseButton{obj=this.Tutorial.CloseButton, fType=ftype, noSkin=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.ChannelFrame.ChannelList, "Update", function(this)
			for header in this.headerButtonPool:EnumerateActive() do
				header:GetNormalTexture():SetTexture(nil)
			end
			-- for textChannel in this.textChannelButtonPool:EnumerateActive() do
			-- end
			-- for voiceChannel in this.voiceChannelButtonPool:EnumerateActive() do
			-- end
			-- for communityChannel in this.communityChannelButtonPool:EnumerateActive() do
			-- end
		end)

		self:SecureHookScript(_G.VoiceChatPromptActivateChannel, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, cbns=true})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton, fType=ftype}
			end
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, cbns=true})
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzLoDFrames[ftype].GlyphUI = function(self)
			if not self.prdb.TalentUI or self.initialized.GlyphUI then return end
			self.initialized.GlyphUI = true

			local clrBB, fName
			if self.modBtnBs then
				function clrBB(btn)
					if btn.sbb then
						if btn.disabledBG:IsShown() then
							aObj:clrBtnBdr(btn.sbb, "grey")
						else
							aObj:clrBtnBdr(btn.sbb, "white")
						end
					end
				end
				self:SecureHook("GlyphFrame_UpdateGlyphList", function()
					for _, btn in _G.pairs(_G.GlyphFrame.scrollFrame.buttons) do
						clrBB(btn)
					end
				end)
			else
				clrBB = _G.nop
			end
			self:SecureHookScript(_G.GlyphFrame, "OnShow", function(this)
				fName = this:GetName()
				self:keepFontStrings(this)
				self:removeInset(this.sideInset)
				self:skinObject("editbox", {obj=_G[fName .. "SearchBox"], fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype})
				self:skinObject("slider", {obj=_G[fName .. "ScrollFrameScrollBar"], fType=ftype, rpTex="background", x1=2, x2=-3})
				for i = 1, #_G.GLYPH_TYPE_INFO do
					self:removeRegions(_G[fName .. "Header" .. i], {1, 2, 3})
				end
				for _, btn in _G.pairs(this.scrollFrame.buttons) do
					btn:GetNormalTexture():SetTexture(nil)
					btn.disabledBG:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, fType=ftype, relTo=btn.icon}
						clrBB(btn)
					end
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=this.clearInfo, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.GlyphFrame)
		end

		-- Hook this here as it is used by both the InspectUI & TalentUI
		local talentInfoQuery, btn, colour = {}
		aObj:SecureHook("TalentFrame_Update", function(frame, talentUnit)
			for tier = 1, _G.MAX_NUM_TALENT_TIERS do
				aObj:keepFontStrings(frame["tier" .. tier])
				for column = 1, _G.NUM_TALENT_COLUMNS do
					_G.wipe(talentInfoQuery)
					talentInfoQuery.tier       = tier
					talentInfoQuery.column     = column
					talentInfoQuery.groupIndex = frame.talentGroup
					talentInfoQuery.isInspect  = frame.inspect
					talentInfoQuery.target     = talentUnit
					local talentInfo = _G.C_SpecializationInfo.GetTalentInfo(talentInfoQuery)
					btn = frame["tier" .. tier]["talent" .. column]
					if btn.knownSelection then
						btn.knownSelection:SetTexture(nil)
					end
					if btn.border then
						btn.border:SetTexture(nil)
					end
					colour = "default"
					if talentInfo.selected then
						colour = "gold"
					elseif frame.inspect
					or btn.disabled
					then
						colour = "disabled"
					end
					if aObj.modBtnBs then
						if not btn.sbb then
							aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.icon, clr=colour, x2=frame.inspect and 3 or nil}
						else
							aObj:clrBBC(colour)
						end
					end
				end
			end
		end)
	end

	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1, y2=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			self:makeMFRotatable(_G.InspectModelFrame)
			this:DisableDrawLayer("BORDER")
			for _, btn in _G.ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
				end
			end
			if self.modBtnBs then
				self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
						btn.icon:SetTexture(nil)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isClscERA
		and not self.isClscBCA
		then
			self:SecureHookScript(_G.InspectHonorFrame, "OnShow", function(this)
				self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7, 8})

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
				self:keepFontStrings(this)

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.InspectTalentFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				if not aObj.isClscBCA then
					this.InspectSpec.ring:SetTexture(nil)
				else
					self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}, offsets={x1=2, y1=-2, x2=-2, y2=0}})
					self:skinObject("slider", {obj=_G.InspectTalentFrameScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
					self:keepFontStrings(_G.InspectTalentFramePointsBar)
					self:skinObject("frame", {obj=_G.InspectTalentFrameScrollFrame, fType=ftype, fb=true, x1=-8, y1=11, x2=31, y2=-7})
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			for i = 1, _G.LOOTFRAME_NUMBUTTONS do
				_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["LootButton" .. i]}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
			if self.modBtnBs then
				self:SecureHook("LootFrame_Update", function()
					for i = 1, _G.LOOTFRAME_NUMBUTTONS do
						if _G["LootButton" .. i].quality then
							_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
						end
					end
				end)
				self:addButtonBorder{obj=_G.LootFrameDownButton, fType=ftype, ofs=-2, clr="gold"}
				self:addButtonBorder{obj=_G.LootFrameUpButton, fType=ftype, ofs=-2, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinGroupLoot(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			local fName = frame:GetName()
			_G[fName .. "SlotTexture"]:SetTexture(nil)
			_G[fName .. "NameFrame"]:SetTexture(nil)
			_G[fName .. "Corner"]:SetAlpha(0)
			frame.Timer:DisableDrawLayer("ARTWORK")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame.Icon}
			end
			aObj:skinObject("statusbar", {obj=frame.Timer, fType=ftype, fi=0, bg=frame.Timer.Background})
			frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.PassButton}
			end
			if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=-3, y2=-3})
			else -- Micro
				aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
				frame.Name:SetAlpha(0)
				frame.NeedButton:ClearAllPoints()
				frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
				frame.PassButton:ClearAllPoints()
				frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
				frame.GreedButton:ClearAllPoints()
				frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
				aObj:adjWidth{obj=frame.Timer, adj=-30}
				frame.Timer:ClearAllPoints()
				frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=97, y2=8})
			end
		end
		for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				skinGroupLoot(this)

				self:Unhook(this, "OnShow")
			end)
			-- hook this to show the Timer
			aObj:SecureHook(_G["GroupLootFrame" .. i], "Show", function(this)
				this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
			end)
		end

		self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.Item.NameBorderLeft:SetTexture(nil)
			this.Item.NameBorderRight:SetTexture(nil)
			this.Item.NameBorderMid:SetTexture(nil)
			this.Item.IconBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				 self:skinCloseButton{obj=self:getChild(this, 3), fType=ftype} -- unamed close button
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Item, fType=ftype, relTo=this.Item.Icon}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.LootHistoryFrame, "OnShow", function(this)
			this.Divider:SetTexture(nil)
			self:skinObject("dropdown", {obj=_G.LootHistoryDropDown, fType=ftype})
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("frame", {obj=this, fType=ftype, rns=true, cb=true})
			if self.modBtnBs then
				local function skinLootItems(frame)
					for _, btn in _G.pairs(frame.itemFrames) do
						aObj:removeRegions(btn, {1, 3, 4, 5, 6})
						aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon}
						aObj:skinExpandButton{obj=btn.ToggleButton, fType=ftype, onSB=true}
					end
				end
				skinLootItems(this)
				self:SecureHook("LootHistoryFrame_FullUpdate", function(fObj)
					skinLootItems(fObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].PVPUI = function(self)
		if not self.prdb.PVEFrame or self.initialized.PVPUI then return end
		self.initialized.PVPUI = true

		-- N.B. copied from Blizzard_PVPUI.lua [line 33]
		local pvpFrames = { "HonorQueueFrame", "ConquestQueueFrame", "WarGamesQueueFrame", "LFGListPVPStub" }

		self:SecureHookScript(_G.PVPQueueFrame, "OnShow", function(this)
			for i = 1, #pvpFrames do
				this["CategoryButton" .. i].Background:SetTexture(nil)
				this["CategoryButton" .. i].Ring:SetTexture(nil)
				self:changeTex(this["CategoryButton" .. i]:GetHighlightTexture())
				self:makeIconSquare(this["CategoryButton" .. i], "Icon", "gold")
			end

			self:SecureHookScript(_G.HonorQueueFrame, "OnShow", function(fObj)
				self:removeInset(fObj.RoleInset)
				self:skinObject("dropdown", {obj=_G.HonorQueueFrameTypeDropDown, fType=ftype})
				self:removeInset(fObj.Inset)
				self:skinObject("slider", {obj=_G.HonorQueueFrameSpecificFrameScrollBar, fType=ftype})
				for _, btn in _G.pairs(fObj.SpecificFrame.buttons) do
					btn.Bg:SetTexture(nil)
					btn.Border:SetTexture(nil)
				end
				self:keepFontStrings(fObj.BonusFrame)
				self:keepFontStrings(fObj.BonusFrame.ShadowOverlay)
				self:skinObject("dropdown", {obj=fObj.BonusFrame.IncludedBattlegroundsDropDown, fType=ftype})
				for _, fName in _G.pairs{"CallToArmsButton", "RandomBGButton", "WorldPVP2Button", "WorldPVP1Button"} do
					self:skinObject("frame", {obj=fObj.BonusFrame[fName], fType=ftype, kfs=true, fb=true, ofs=0})
					fObj.BonusFrame[fName]:GetNormalTexture():SetTexture(nil)
				end
				self:removeMagicBtnTex(fObj.SoloQueueButton)
				self:removeMagicBtnTex(fObj.GroupQueueButton)
				if self.modBtns then
					self:skinStdButton{obj=fObj.SoloQueueButton, fType=ftype, schk=true}
					self:skinStdButton{obj=fObj.GroupQueueButton, fType=ftype, schk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.BonusFrame.DiceButton, fType=ftype, clr="gold"}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.RoleInset.TankIcon.checkButton, fType=ftype}
					self:skinCheckButton{obj=fObj.RoleInset.HealerIcon.checkButton, fType=ftype}
					self:skinCheckButton{obj=fObj.RoleInset.DPSIcon.checkButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.HonorQueueFrame)

			self:SecureHookScript(_G.ConquestQueueFrame, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				self:keepFontStrings(fObj.ShadowOverlay)
				fObj.ConquestBar:DisableDrawLayer("BORDER")
				self:removeRegions(fObj.ConquestBar, {4, 6})
				fObj.ConquestBar.progress:SetTexture(self.sbTexture)
				self:removeInset(fObj.Inset)
				for _, bName in _G.pairs{"Arena2v2", "Arena3v3", "Arena5v5", "RatedBG"} do
					self:skinObject("frame", {obj=fObj[bName], fType=ftype, kfs=true, fb=true, ofs=0})
				end
				self:removeMagicBtnTex(fObj.JoinButton)
				if self.modBtns then
					self:skinStdButton{obj=fObj.JoinButton, fType=ftype, schk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.WarGamesQueueFrame, "OnShow", function(fObj)
				fObj.InfoBG:SetTexture(nil)
				self:removeInset(fObj.RightInset)
				self:skinObject("slider", {obj=_G.WarGamesQueueFrameScrollFrameScrollBar, fType=ftype, rpTex={"background", "artwork"}})
				for _, btn in _G.pairs(fObj.scrollFrame.buttons) do
					btn.Entry.Bg:SetTexture(nil)
					btn.Entry.Border:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn.Entry, fType=ftype, relTo=btn.Entry.Icon}
					end
					if self.modBtns then
						self:skinExpandButton{obj=btn.Header, fType=ftype, onSB=true}
					end
				end
				-- N.B. The following 2 lines refer to two different objects (should be the same one)
				_G.WarGamesQueueFrameInfoScrollFrame.ScrollBar.Background:DisableDrawLayer("ARTWORK")
				self:skinObject("slider", {obj=_G.WarGamesQueueFrameInfoScrollFrameScrollBar, fType=ftype})
				fObj.HorizontalBar:DisableDrawLayer("ARTWORK")
				self:removeMagicBtnTex(self:getLastChild(fObj)) -- WarGameStartButton
				if self.modBtns then
					self:skinStdButton{obj=self:getLastChild(fObj), fType=ftype} -- WarGameStartButton
				end

				self:Unhook(fObj, "OnShow")
			end)

		end)

		_G.C_Timer.After(0.1, function()
		    self:add2Table(self.ttList, _G.ConquestTooltip)
		end)

	end

	aObj.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		if aObj.isClscERA then
			self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)
				this.numTabs = 3
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, lod=self.isTT and true, offsets={x1=13, y1=-14, x2=-13, y2=16}, regions={1, 3}, track=false})
				if self.isTT then
					local function setTab(bookType)
						local tab
						for i = 1, this.numTabs do
							tab = _G["SpellBookFrameTabButton" .. i]
							if tab.bookType == bookType then
								self:setActiveTab(tab.sf)
							else
								self:setInactiveTab(tab.sf)
							end
						end
					end
					-- hook to handle tabs
					self:SecureHook("ToggleSpellBook", function(bookType)
						setTab(bookType)
					end)
					-- set correct tab
					setTab(this.bookType)
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=73})
				if self.modBtns then
					self:skinCloseButton{obj=_G.SpellBookCloseButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.SpellBookPrevPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3}
					self:addButtonBorder{obj=_G.SpellBookNextPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3}
					self:clrPNBtns("SpellBook")
					self:SecureHook(this, "UpdatePages", function()
						self:clrPNBtns("SpellBook")
					end)
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.ShowAllSpellRanksCheckbox, fType=ftype}
				end

				local function updBtn(btn)
					-- handle in combat
					if _G.InCombatLockdown() then
					    aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
					    return
					end
					if aObj.modBtnBs
					and btn.sbb -- allow for not skinned during combat
					then
						if not btn:IsEnabled() then
							btn.sbb:Hide()
						else
							btn.sbb:Show()
						end
						aObj:clrBtnBdr(btn)
					end
					local spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
					if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
						spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					else
						spellString:SetTextColor(aObj.HT:GetRGB())
						subSpellString:SetTextColor(aObj.BT:GetRGB())
					end
				end
				_G.SpellBookPageText:SetTextColor(self.BT:GetRGB())
				local btn
				for i = 1, _G.SPELLS_PER_PAGE do
					btn = _G["SpellButton" .. i]
					btn:DisableDrawLayer("BACKGROUND")
					btn:GetNormalTexture():SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, fType=ftype, sft=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
					end
					updBtn(btn)
					-- hook self to change text colour as required
					self:SecureHook(btn, "UpdateButton", function(bObj)
						updBtn(bObj)
					end)
				end

				for i = 1, _G.MAX_SKILLLINE_TABS do
					self:removeRegions(_G["SpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
					if self.modBtnBs then
						self:addButtonBorder{obj=_G["SpellBookSkillLineTab" .. i], fType=ftype}
					end
				end

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)
				this.numTabs = 5
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, track=false})
				if self.isTT then
					local function setTab(bookType)
						local tab
						for i = 1, this.numTabs do
							tab = _G["SpellBookFrameTabButton" .. i]
							if tab.bookType == bookType then
								self:setActiveTab(tab.sf)
							else
								self:setInactiveTab(tab.sf)
							end
						end
					end
					-- hook to handle tabs
					self:SecureHook("ToggleSpellBook", function(bookType)
						setTab(bookType)
					end)
					-- set correct tab
					setTab(this.bookType)
				end
				-- Spellbook Panel
				local bName, spellString, subSpellString
				local function updBtn(btn)
					-- handle in combat
					if _G.InCombatLockdown() then
					    aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
					    return
					end
					bName = btn:GetName()
					spellString, subSpellString = _G[bName .. "SpellName"], _G[bName .. "SubSpellName"]
					if _G[bName .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
						spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
						btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					else
						spellString:SetTextColor(aObj.HT:GetRGB())
						subSpellString:SetTextColor(aObj.BT:GetRGB())
					end
					 -- allow for not skinned during combat
					if btn.sbb then
						if btn:IsEnabled() then
							btn.sbb:Show()
						else
							btn.sbb:Hide()
							return
						end
						if _G[bName .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
							aObj:clrBtnBdr(btn, "disabled")
						else
							aObj:clrBtnBdr(btn)
						end
					end
				end
				_G.SpellBookPageText:SetTextColor(self.BT:GetRGB())
				local btn
				for i = 1, _G.SPELLS_PER_PAGE do
					btn = _G["SpellButton" .. i]
					btn:DisableDrawLayer("BACKGROUND")
					btn:DisableDrawLayer("BORDER")
					_G["SpellButton" .. i .. "SlotFrame"]:SetAlpha(0)
					btn.UnlearnedFrame:SetAlpha(0)
					btn.TrainFrame:SetAlpha(0)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, fType=ftype, sft=true, reParent={btn.FlyoutArrow, _G["SpellButton" .. i .. "AutoCastable"]}, ofs=3}
						btn:GetNormalTexture():SetTexture(nil)
						btn.sbb:SetShown(btn:IsEnabled())
					end
					updBtn(btn)
					self:SecureHook(btn, "UpdateButton", function(bObj)
						updBtn(bObj)
					end)
				end
				-- Tabs (side)
				local tBtn
				for i = 1, _G.MAX_SKILLLINE_TABS do
					tBtn = _G["SpellBookSkillLineTab" .. i]
					tBtn:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						self:addButtonBorder{obj=tBtn, clr=tBtn.isOffSpec and "grey", ofs=3}
					end
				end

				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=2, y2=-3})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.SpellBookPrevPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3}
					self:addButtonBorder{obj=_G.SpellBookNextPageButton, fType=ftype, ofs=-2, y1=-3, x2=-3}
					self:clrPNBtns("SpellBook")
					self:SecureHook(this, "UpdatePages", function()
						self:clrPNBtns("SpellBook")
					end)
				end

				self:SecureHookScript(_G.SpellBookProfessionFrame, "OnShow", function(fObj)
					local function skinProf(type, times)
						local objName, obj
						for i = 1, times do
							objName = type .. "Profession" .. i
							obj =_G[objName]
							if type == "Primary" then
								_G[objName .. "IconBorder"]:Hide()
								-- make icon square
								aObj:makeIconSquare(obj, "icon")
								if not obj.missingHeader:IsShown() then
									obj.icon:SetDesaturated(nil) -- show in colour
									if aObj.modBtnBs then
										aObj:clrBtnBdr(obj)
									end
								else
									if aObj.modBtnBs then
										aObj:clrBtnBdr(obj, "disabled")
									end
								end
							else
								obj.missingHeader:SetTextColor(aObj.HT:GetRGB())
							end
							obj.missingText:SetTextColor(aObj.BT:GetRGB())
							local pBtn
							for j = 1, 2 do
								pBtn = obj["SpellButton" .. j]
								pBtn:DisableDrawLayer("BACKGROUND")
								pBtn.subSpellString:SetTextColor(aObj.BT:GetRGB())
								if aObj.modBtnBs then
									aObj:addButtonBorder{obj=pBtn, sft=true}
								end
							end
							aObj:removeRegions(obj.statusBar, {2, 3, 4, 5, 6})
							aObj:skinObject("statusbar", {obj=obj.statusBar, fi=0})
							obj.statusBar:SetStatusBarColor(0, 1, 0, 1)
							obj.statusBar:SetHeight(12)
							obj.statusBar.rankText:SetPoint("CENTER", 0, 0)
							aObj:moveObject{obj=obj.statusBar, x=-12}
						end
					end
					skinProf("Primary", 2)
					skinProf("Secondary", 4)
					if self.modBtnBs then
						self:SecureHook("SpellBook_UpdateProfTab", function()
							local prof1, prof2, _, _, _ = _G.GetProfessions()
							self:clrBtnBdr(_G.PrimaryProfession1, not prof1 and "disabled")
							self:clrBtnBdr(_G.PrimaryProfession2, not prof2 and "disabled")
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.SpellBookProfessionFrame)

				self:SecureHookScript(_G.SpellBookCoreAbilitiesFrame, "OnShow", function(fObj)
					fObj.SpecName:SetTextColor(self.HT:GetRGB())
					self:SecureHook(fObj, "UpdateTabs", function(frame)
						for _, sTab in _G.pairs(frame.SpecTabs) do
							sTab:DisableDrawLayer("BACKGROUND")
							if self.modBtnBs then
								self:addButtonBorder{obj=sTab, clr=sTab.isOffSpec and "grey"}
							end
						end
					end)
					self:SecureHook("SpellBook_UpdateCoreAbilitiesTab", function()
						for _, sBtn in _G.pairs(fObj.Abilities) do
							sBtn.EmptySlot:SetTexture(nil)
							sBtn.ActiveTexture:SetTexture(nil)
							sBtn.FutureTexture:SetTexture(nil)
							sBtn.Name:SetTextColor(self.HT:GetRGB())
							sBtn.InfoText:SetTextColor(self.BT:GetRGB())
							sBtn.RequiredLevel:SetTextColor(self.BT:GetRGB())
							if self.modBtnBs then
								self:addButtonBorder{obj=sBtn, fType=ftype, sft=true, clr="gold"}
							end
						end
					end)

					self:Unhook(fObj, "OnShow")
				end)
				self:SecureHookScript(_G.SpellBookWhatHasChanged, "OnShow", function(fObj)
					fObj.ClassName:SetTextColor(self.HT:GetRGB())
					self:SecureHook("SpellBook_UpdateWhatHasChangedTab", function()
						for _, item in _G.pairs(fObj.ChangedItems) do
							item:DisableDrawLayer("BACKGROUND")
							item.Ring:SetTexture(nil)
							item.Title:SetTextColor(self.HT:GetRGB())
							item:SetTextColor("P", self.BT:GetRGB())
						end

					end)

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzLoDFrames[ftype].TalentUI = function(self)
		if not self.prdb.TalentUI or self.initialized.TalentUI then return end
		self.initialized.TalentUI = true

		if self.isClscERA then
			local tName
			local function skinTalentBtns()
				for i = 1, _G.MAX_NUM_TALENTS do
					tName = "PlayerTalentFrameTalent" .. i
					_G[tName .. "Slot"]:SetTexture(nil)
					aObj:changeTandC(_G[tName .. "RankBorder"])
					if aObj.modBtnBs then
						if not _G[tName].sbb then
							aObj:addButtonBorder{obj=_G[tName], fType=ftype, ibt=true, reParent={_G[tName .. "RankBorder"], _G[tName .. "Rank"]}, clr={_G[tName .. "Slot"]:GetVertexColor()}}
						else
							_G[tName].sbb:SetBackdropBorderColor(_G[tName .. "Slot"]:GetVertexColor())
						end
					end
				end
			end
			self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
				local fName = this:GetName()
				self:moveObject{obj=_G.PlayerTalentFrameTitleText, y=-2}
				self:skinObject("tabs", {obj=this, prefix=fName, fType=ftype, lod=self.isTT and true})
				self:skinObject("slider", {obj=_G[fName .. 'ScrollFrameScrollBar'], fType=ftype, rpTex="artwork"})
				-- keep background Texture
				self:removeRegions(this, {1, 2, 3, 4, 5})
				self:skinObject("frame", {obj=this, fType=ftype, cb=true, x1=10, y1=-12, x2=-31, y2=74})
				self:keepFontStrings(_G.PlayerTalentFramePointsBar)
				_G.PlayerTalentFramePreviewBar:DisableDrawLayer("BORDER")
				_G.PlayerTalentFramePreviewBarFiller:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinStdButton{obj=_G.PlayerTalentFrameResetButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.PlayerTalentFrameLearnButton, fType=ftype, schk=true}
				end
				for i = 1, 3 do
					self:removeRegions(_G["PlayerSpecTab" .. i], {1}) -- N.B. other regions are icon and highlight
					if self.modBtnBs then
						self:addButtonBorder{obj=_G["PlayerSpecTab" .. i]}
					end
				end
				skinTalentBtns()
				self:SecureHook("TalentFrame_Update", function(fObj)
					skinTalentBtns()
				end)

				self:Unhook(this, "OnShow")
			end)
		else
			local btn
			self:SecureHook("PlayerTalentFrame_UpdateSpecFrame", function(frame, _)
				for i = 1, 10 do
					btn = frame.spellsScroll.child["abilityButton" .. i]
					if btn then
						btn.ring:SetTexture(nil)
					end
				end
				if self.modBtnBs then
					for i = 1, _G.GetNumSpecializations(nil, frame.isPet) do
						self:removeRegions(frame["specButton" .. i], {1, 2, 3, 8})
						if frame["specButton" .. i].sbb then
							self:clrBBC(frame["specButton" .. i].sbb, frame["specButton" .. i].disabled and "disabled" or "gold")
						end
					end
					if frame.spellsScroll.child.sbb then
						self:clrBBC(frame.spellsScroll.child.sbb, frame.disabled and "disabled" or "gold")
					end
				end

			end)
			self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
				for i = 1, _G.TalentUIUtil.GetNumSpecTabs() do
					_G["PlayerSpecTab" .. i]:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						self:addButtonBorder{obj=_G["PlayerSpecTab" .. i], ofs=3}
					end

				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y2=-4})
				self:removeMagicBtnTex(_G.PlayerTalentFrameActivateButton)
				if self.modBtns then
					self:skinStdButton{obj=_G.PlayerTalentFrameActivateButton, fType=ftype}
				end

				local function skinSpecFrame(frame)
					frame.MainHelpButton.Ring:SetTexture(nil)
					frame:DisableDrawLayer("BORDER")
					frame:DisableDrawLayer("ARTWORK")
					aObj:getPenultimateChild(frame):DisableDrawLayer("OVERLAY")
					frame.MainHelpButton.Ring:SetTexture(nil)
					aObj:removeMagicBtnTex(frame.learnButton)
					for i = 1, _G.GetNumSpecializations(nil, frame.isPet) do
						aObj:removeRegions(frame["specButton" .. i], {1, 2, 3, 8})
						aObj:makeIconSquare(frame["specButton" .. i], "specIcon", frame["specButton" .. i].disabled and "disabled" or "gold")
					end
					aObj:skinObject("slider", {obj=frame.spellsScroll.ScrollBar, fType=ftype, rpTex="artwork"})
					frame.spellsScroll.child:DisableDrawLayer("BORDER")
					frame.spellsScroll.child.ring:SetTexture(nil)
					frame.spellsScroll.child.specIcon:SetDrawLayer("ARTWORK")
					aObj:makeIconSquare(frame.spellsScroll.child, "specIcon", frame.disabled and "disabled" or "gold")
					if aObj.modBtns then
						aObj:skinStdButton{obj=frame.learnButton, fType=ftype, schk=true}
					end
				end
				self:SecureHookScript(_G.PlayerTalentFrameSpecialization, "OnShow", function(fObj)
					skinSpecFrame(fObj)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.PlayerTalentFrameSpecialization)

				self:SecureHookScript(_G.PlayerTalentFramePetSpecialization, "OnShow", function(fObj)
					skinSpecFrame(fObj)

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(_G.PlayerTalentFrameTalents, "OnShow", function(fObj)
					self:keepFontStrings(fObj)
					fObj.MainHelpButton.Ring:SetTexture(nil)
					self:removeMagicBtnTex(fObj.learnButton)
					if self.modBtns then
						self:skinStdButton{obj=fObj.learnButton, fType=ftype, schk=true}
					end

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(this, "OnShow")
			end)

		end

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].TokenUI = function(self) -- Currency tab on Character frame
			if not self.prdb.CharacterFrames or self.initialized.TokenUI then return end
			self.initialized.TokenUI = true

			self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:skinObject("slider", {obj=_G.TokenFrameContainerScrollBar, fType=ftype, rpTex="background"})
				for _, btn in _G.pairs(_G.TokenFrameContainer.buttons) do
					btn.categoryLeft:SetTexture(nil)
					btn.categoryRight:SetTexture(nil)
					if btn.categoryMiddle then
						btn.categoryMiddle:SetTexture(nil)
					end
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.TokenFramePopup, "OnShow", function(this)
				if this.Border then
					self:keepFontStrings(this.Border)
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-6})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.TokenFramePopupInactiveCheckbox, fType=ftype}
					self:skinCheckButton{obj=_G.TokenFramePopupBackpackCheckbox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.BackpackTokenFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
		if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
		self.initialized.TradeSkillUI = true

		self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)
			if self.isClsc then
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.TradeSkillFrameAvailableFilterCheckButton, fType=ftype}
				end
				self:skinObject("editbox", {obj=_G.TradeSkillFrameEditBox, fType=ftype})
			end
			self:skinObject("statusbar", {obj=_G.TradeSkillRankFrame, fType=ftype, fi=0, bg=_G.TradeSkillRankFrameBackground})
			if self.isClscERA then
				_G.TradeSkillRankFrameBorder:GetNormalTexture():SetTexture(nil)
			else
				_G.TradeSkillRankFrameBorder:SetTexture(nil)
			end
			self:keepFontStrings(_G.TradeSkillExpandButtonFrame)
			self:keepFontStrings(_G.TradeSkillDetailScrollChildFrame)
			local btnName
			for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
				btnName = "TradeSkillReagent" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtnBs then
					 self:addButtonBorder{obj=_G[btnName], fType=ftype, libt=true}
					 _G[btnName].sbb:SetBackdropBorderColor(_G[btnName .. "IconTexture"]:GetVertexColor())
				end
			end
			self:skinObject("editbox", {obj=_G.TradeSkillInputBox, fType=ftype})
			self:skinObject("editbox", {obj=_G.TradeSkillFrameSearchBox, fType=ftype, si=true})
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.TradeSkillSkillIcon, fType=ftype, clr="gold"}
			end
			local x1, y1, x2, y2
			if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -32, 70
			end
			if not _G.C_AddOns.IsAddOnLoaded("alaTradeSkill") then
				self:skinObject("ddbutton", {obj=this.InvSlotDropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=this.SubClassDropdown, fType=ftype})
				self:skinObject("slider", {obj=_G.TradeSkillListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("slider", {obj=_G.TradeSkillDetailScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=x1, y1=y1, x2=x2, y2=y2})
				if self.modBtns then
					self:skinExpandButton{obj=_G.TradeSkillCollapseAllButton, fType=ftype, onSB=true}
					for i = 1, _G.TRADE_SKILLS_DISPLAYED do
						self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], fType=ftype, onSB=true}
						self:checkTex{obj=_G["TradeSkillSkill" .. i]}
					end
					self:SecureHook("TradeSkillFrame_Update", function()
						for i = 1, _G.TRADE_SKILLS_DISPLAYED do
							self:checkTex{obj=_G["TradeSkillSkill" .. i]}
						end
					end)
					self:skinStdButton{obj=_G.TradeSkillCreateAllButton, fType=ftype, ofs=0}
					self:skinStdButton{obj=_G.TradeSkillCreateButton, fType=ftype, ofs=0}
					self:skinStdButton{obj=_G.TradeSkillCancelButton, fType=ftype, ofs=0}
					self:SecureHook("TradeSkillFrame_SetSelection", function(_)
						self:clrBtnBdr(_G.TradeSkillCreateButton)
						self:clrBtnBdr(_G.TradeSkillCreateAllButton)
					end)
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.TradeSkillDecrementButton, fType=ftype, ofs=0, clr="gold"}
					self:addButtonBorder{obj=_G.TradeSkillIncrementButton, fType=ftype, ofs=0, clr="gold"}
				end
			else
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=4, y1=y1, x2=x2, y2=y2})
				skinaTS(this)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].WatchFrame = function(self)
			if not self.prdb.WatchFrame or self.initialized.WatchFrame then return end
			self.initialized.WatchFrame = true

			self:SecureHookScript(_G.WatchFrame, "OnShow", function(this)
				_G.WatchFrameLines.Shadow:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.WatchFrameCollapseExpandButton, fType=ftype, es=12, ofs=0, x1=-1}
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.WatchFrame)

			local aqPopup
			local function skinWatchFrameObjects(_, nextAnchor, _, _)
				for i = 1, _G.GetNumAutoQuestPopUps() do
					aqPopup =_G["WatchFrameAutoQuestPopUp" .. i]
					aObj:skinObject("frame", {obj=aqPopup.ScrollChild, fType=ftype, kfs=true})
					aqPopup.ScrollChild.Exclamation:SetAlpha(1)
					aqPopup.ScrollChild.QuestionMark:SetAlpha(1)
					if aqPopup.type == "COMPLETE" then
						aqPopup.ScrollChild.QuestionMark:Show()
					else
						aqPopup.ScrollChild.Exclamation:Show()
					end
				end
				_G.WatchFrameScenarioFrame.ScrollChild.BlockHeader:DisableDrawLayer("BACKGROUND")
				_G.WatchFrameScenarioFrame.ScrollChild.BlockHeader:DisableDrawLayer("BORDER")
				_G.WatchFrameScenarioBonusHeader:DisableDrawLayer("BACKGROUND")
				_G.WatchFrameScenarioBonusHeader:DisableDrawLayer("BORDER")
				if aObj.modBtnBs then
					for i = 1, _G.WATCHFRAME_NUM_ITEMS do
						aObj:addButtonBorder{obj=_G["WatchFrameItem" .. i], fType=ftype}
					end
				end
				return nextAnchor, 0, 0, 0
			end
			_G.WatchFrame_AddObjectiveHandler(skinWatchFrameObjects)

		end
	end

end

aObj.SetupClassic_PlayerFramesOptions = function(self)

	local optTab = {
		["Barber Shop UI"]  = self.isClsc and true or nil,
		["Craft UI"]        = true,
		["SpellBook Frame"] = {desc = "SpellBook & Abilities"},
		["Talent UI"]       = true,
		["Trade Skill UI"]  = {desc = "Trade Skills UI"},
		["Watch Frame"]     = self.isClsc and true or nil,
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

end
