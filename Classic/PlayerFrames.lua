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

	aObj.blizzFrames[ftype].CastingBar = function(self)
		if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
		self.initialized.CastingBar = true

		if _G.C_AddOns.IsAddOnLoaded("Quartz")
		or _G.C_AddOns.IsAddOnLoaded("Dominos_Cast")
		then
			self.blizzFrames[ftype].CastingBar = nil
			return
		end

		local cbFrame
		for _, type in _G.pairs{"", "Pet"} do
			cbFrame = _G[type .. "CastingBarFrame"]
			cbFrame.Border:SetAlpha(0)
			self:changeShield(cbFrame.BorderShield, cbFrame.Icon)
			cbFrame.Flash:SetAllPoints()
			cbFrame.Flash:SetTexture(self.tFDIDs.w8x8)
			if self.prdb.CastingBar.glaze then
				self:skinObject("statusbar", {obj=cbFrame, fi=0, bg=self:getRegion(cbFrame, 1), nilFuncs=true})
			end
			-- adjust text and spark in Classic mode
			if not cbFrame.ignoreFramePositionManager then
				cbFrame.Text:SetPoint("TOP", 0, 2)
				cbFrame.Spark.offsetY = -1
			end
		end

		-- hook this to handle the CastingBar being attached to the Unitframe and then reset
		self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
			castBar.Border:SetAlpha(0)
			castBar.Flash:SetAllPoints()
			castBar.Flash:SetTexture(self.tFDIDs.w8x8)
			if look == "CLASSIC" then
				castBar.Text:SetPoint("TOP", 0, 2)
				castBar.Spark.offsetY = -1
			end
		end)

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
				if self.isClsc then
					self:skinObject("dropdown", {obj=_G.PlayerTitleDropDown, fType=ftype, y1=5, y2=13})
					self:skinObject("dropdown", {obj=_G.PlayerStatFrameLeftDropDown, fType=ftype})
					self:skinObject("dropdown", {obj=_G.PlayerStatFrameRightDropDown, fType=ftype})
				end
				if self.modBtnBs then
					for i = 1, _G.NUM_RESISTANCE_TYPES do
						self:addButtonBorder{obj=_G["MagicResFrame" .. i], es=24, ofs=2, x1=-1, y2=-4}
					end
					local btn
					for _, sName in _G.ipairs(pdfSlots) do
						btn = _G["Character" .. sName .. "Slot"]
						self:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.ignoreTexture}--[[--]]}
						_G.PaperDollItemSlotButton_Update(btn)
					end
					btn = _G.CharacterAmmoSlot
					btn:DisableDrawLayer("BACKGROUND")
					btn.icon = _G.CharacterAmmoSlotIconTexture
					self:addButtonBorder{obj=btn, reParent={btn.Count, self:getRegion(btn, 4)}}

					self:SecureHook("PaperDollItemSlotButton_Update", function(bObj)
						-- ignore buttons with no skin border
						if bObj.sbb then
							if not bObj.hasItem then
								self:clrBtnBdr(bObj, "grey")
								bObj.icon:SetTexture(nil)
							else
								bObj.sbb:SetBackdropBorderColor(bObj.icon:GetVertexColor())
							end
						end
					end)

					if _G.RuneFrameControlButton then -- ERA SoD
						self:addButtonBorder{obj=_G.RuneFrameControlButton, fType=ftype}
					end
					if _G.GearManagerToggleButton then -- Wrath
						self:addButtonBorder{obj=_G.GearManagerToggleButton, fType=ftype, x1=1, x2=-1}
					end
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
				local function skinPetFrame()
					aObj:skinObject("statusbar", {obj=_G.PetPaperDollFrameExpBar, regions={1, 2}, fi=0})
					aObj:makeMFRotatable(_G.PetModelFrame)
					_G.PetAttributesFrame:DisableDrawLayer("BACKGROUND")
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.PetPaperDollCloseButton, fType=ftype}
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=_G.PetPaperDollPetInfo, ofs=1, x2=0, clr="gold"}
						for i = 1, _G.NUM_PET_RESISTANCE_TYPES do
							aObj:addButtonBorder{obj=_G["PetMagicResFrame" .. i], es=24, ofs=2, y1=3, y2=-4}
						end
					end
				end
				self:keepFontStrings(this)
				if self.isClscERA then
					skinPetFrame()
				else
					-- Top Tabs
					self:skinObject("tabs", {obj=this, prefix=this:GetName(), numTabs=3, fType=ftype, lod=self.isTT and true, offsets={x1=6, y1=-6, x2=-6, y2=0}})
					self:SecureHookScript(_G.PetPaperDollFramePetFrame, "OnShow", function(fObj)
						skinPetFrame()
						self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=12, y1=-65, x2=-33, y2=76})

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.PetPaperDollFramePetFrame)
					self:SecureHookScript(_G.PetPaperDollFrameCompanionFrame, "OnShow", function(fObj)
						self:removeRegions(_G.PetPaperDollFrameCompanionFrame, {1, 2})
						self:makeMFRotatable(_G.CompanionModelFrame)
						self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=12, y1=-65, x2=-33, y2=76})
						if self.modBtns then
							self:skinStdButton{obj=_G.CompanionSummonButton, fType=ftype}
						end
						if self.modBtnBs then
							for i = 1, _G.NUM_COMPANIONS_PER_PAGE do
								self:addButtonBorder{obj=_G["CompanionButton" .. i], fType=ftype, sft=true}
							end
							self:addButtonBorder{obj=_G.CompanionPrevPageButton, ofs=-2, y1=-3, x2=-3}
							self:addButtonBorder{obj=_G.CompanionNextPageButton, ofs=-2, y1=-3, x2=-3}
							self:clrPNBtns("Companion")
							self:SecureHook("PetPaperDollFrame_SetCompanionPage", function(_)
								self:clrPNBtns("Companion")
							end)
						end

						self:Unhook(fObj, "OnShow")
					end)
					self:checkShown(_G.PetPaperDollFrameCompanionFrame)
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
							self:skinObject("statusbar", {obj=_G["ReputationBar" .. i], regions={1, 2}, fi=0})
							awc = self:getRegion(_G["ReputationBar" .. i .. "AtWarCheck"], 1)
							awc:SetTexture(self.tFDIDs.cbSC)
							awc:SetTexCoord(0, 1, 0, 1)
							awc:SetSize(32, 32)
						else
							self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], fType=ftype, onSB=true}
							self.modUIBtns:checkTex{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"]}
							self:skinObject("statusbar", {obj=_G["ReputationBar" .. i .. "ReputationBar"], regions={3, 4}, fi=0})
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
					self:skinObject("statusbar", {obj=_G["SkillRankFrame"  .. i], fi=0, other={_G["SkillRankFrame"  .. i .. "FillBar"]}})
				end
				self:skinObject("slider", {obj=_G.SkillListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("slider", {obj=_G.SkillDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:removeRegions(_G.SkillDetailStatusBar, {1})
				self:skinObject("statusbar", {obj=_G.SkillDetailStatusBar, fi=0, other={_G.SkillDetailStatusBarFillBar}})
				if self.modBtns then
					self:skinExpandButton{obj=_G.SkillFrameCollapseAllButton, fType=ftype, onSB=true, minus=true}
					self:skinStdButton{obj=_G.SkillFrameCancelButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.SkillDetailStatusBarUnlearnButton, fType=ftype, ofs=-4, x1=6, y2=7}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:skinObject("statusbar", {obj=_G.HonorFrameProgressBar, fi=0})

				self:Unhook(this, "OnShow")
			end)

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
			aObj:skinObject("frame", {obj=parent.frame.TabFrame, fb=true})
			aObj:skinObject("frame", {obj=parent.frame.ProfitFrame, kfs=true, ofs=0})
			aObj:skinObject("frame", {obj=parent.frame.SetFrame, kfs=true, ofs=0, y1=2})
			aObj:skinObject("slider", {obj=parent.frame.SetFrame.PhaseSlider})
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
			self:skinObject("statusbar", {obj=_G.CraftRankFrame, fi=0, bg=_G.CraftRankFrameBackground})
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
				self:addButtonBorder{obj=_G.CraftIcon, clr="gold"}
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
			if self.prdb.DUTexture then
				self:removeRegions(this, {1, 2, 3 ,4, 5})
			else
				self:keepFontStrings(this)
			end
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, x1=10, y1=-11, x2=-33, y2=71})
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
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2, x1=1, y1=-1}
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
				self:removeInset(_G.WhoFrameEditBoxInset)
				self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype})
				self:adjHeight{obj=_G.WhoFrameEditBox, adj=-10}
				if not self.isElvUI then
					_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() + 24)
					self:moveObject{obj=_G.WhoFrameEditBox, x=11, y=6}
				end
				self:skinObject("slider", {obj=_G.WhoListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton, fType=ftype}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton, fType=ftype}
					self:skinStdButton{obj=_G.WhoFrameWhoButton, fType=ftype}
					self:SecureHook("WhoList_Update", function()
						self:clrBtnBdr(_G.WhoFrameGroupInviteButton)
						self:clrBtnBdr(_G.WhoFrameAddFriendButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			if self.modBtns then
				self:SecureHook("GuildStatus_Update", function()
					if _G.GuildFrame.sf then
						self:clrBtnBdr(_G.GuildFrameControlButton)
						self:clrBtnBdr(_G.GuildFrameAddMemberButton)
					end
					if _G.GuildMemberDetailFrame.sf then
						self:clrBtnBdr(_G.GuildMemberRemoveButton)
						self:clrBtnBdr(_G.GuildMemberGroupInviteButton)
						self:clrBtnBdr(_G.GuildFramePromoteButton)
						self:clrBtnBdr(_G.GuildFrameDemoteButton)
					end
				end)
			end
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
					self:addButtonBorder{obj=_G.GuildFrameGuildListToggleButton, ofs=-2, clr="gold"}
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
				self:skinObject("frame", {obj=_G.GuildInfoTextBackground, fb=true})
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
					self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildMemberRemoveButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildMemberGroupInviteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFramePromoteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameDemoteButton, fType=ftype, schk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildEventLogFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=_G.GuildEventFrame, fType=ftype, kfs=true, fb=true, ofs=0})
				self:skinObject("slider", {obj=_G.GuildEventLogScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, ofs=-6})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildEventLogCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildEventLogCancelButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			-- tooltip
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
	end

	local function skinTalentBtns(frame)
		local fName = frame:GetName()
		local tName
		for i = 1, _G.MAX_NUM_TALENTS do
			tName = fName .. "Talent" .. i
			_G[tName .. "Slot"]:SetTexture(nil)
			aObj:changeTandC(_G[tName .. "RankBorder"])
			aObj:addButtonBorder{obj=_G[tName], fType=ftype, ibt=true, reParent={_G[tName .. "RankBorder"], _G[tName .. "Rank"]}, clr=_G[tName .. "Slot"]:GetVertexColor()}
		end
	end
	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-12, x2=-31, y2=74})

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

		if self.isClscERA then
			self:SecureHookScript(_G.InspectHonorFrame, "OnShow", function(this)
				self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7, 8})

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				-- TODO: skin PVPTeam buttons

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.InspectTalentFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("BORDER")
				-- Top Tabs
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=4, y1=-4, x2=-4, y2=-1}})
				_G.InspectTalentFramePointsBar:DisableDrawLayer("BACKGROUND")
				_G.InspectTalentFramePointsBar:DisableDrawLayer("BORDER")
				self:skinObject("frame", {obj=_G.InspectTalentFrameScrollFrame, fType=ftype, kfs=true, fb=true, x1=-11, y1=10, x2=32, y2=-5})
				self:skinObject("slider", {obj=_G.InspectTalentFrameScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				if self.modBtns then
					self:skinCloseButton{obj=_G.InspectTalentFrameCloseButton, fType=ftype}
				end
				if self.modBtnBs then
					skinTalentBtns(this)
					self:SecureHook("InspectTalentFrame_Update", function()
						skinTalentBtns(_G.InspectTalentFrame)
					end)
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
				self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2, clr="gold"}
				self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2, clr="gold"}
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
				aObj:addButtonBorder{obj=frame, relTo=frame.Icon}
			end
			aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
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
				 self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Item, relTo=this.Item.Icon}
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

	aObj.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		if aObj.isClsc then
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
						if self.isClsc then
							btn:GetNormalTexture():SetTexture(nil)
						end
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
						self:addButtonBorder{obj=tBtn, clr=tBtn.isOffSpec and "grey"}
					end
					if i == 1 then
						self:moveObject{obj=tBtn, x=2}
					end
				end

				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=2, y2=-3})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
					self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
					self:clrPNBtns("SpellBook")
					self:SecureHook("SpellBookFrame_UpdatePages", function()
						self:clrPNBtns("SpellBook")
					end)
					self:SecureHook("SpellBookFrame_UpdateSkillLineTabs", function()
						for i = 1, _G.MAX_SKILLLINE_TABS do
							self:clrBtnBdr(_G["SpellBookSkillLineTab" .. i], _G["SpellBookSkillLineTab" .. i].isOffSpec and "grey")
						end
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

				self:Unhook(this, "OnShow")
			end)
		else
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
					self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
					self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
					self:clrPNBtns("SpellBook")
					self:SecureHook("SpellBookFrame_UpdatePages", function()
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
						self:addButtonBorder{obj=btn, sft=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
					end
					updBtn(btn)
				end
				-- hook self to change text colour as required
				self:SecureHook("SpellButton_UpdateButton", function(splBtn)
					updBtn(splBtn)
				end)

				for i = 1, _G.MAX_SKILLLINE_TABS do
					self:removeRegions(_G["SpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
					if self.modBtnBs then
						self:addButtonBorder{obj=_G["SpellBookSkillLineTab" .. i]}
					end
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzLoDFrames[ftype].TalentUI = function(self)
		if not self.prdb.TalentUI or self.initialized.TalentUI then return end
		self.initialized.TalentUI = true

		if self.isClscERA then
			self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
				local fName = this:GetName()
				self:moveObject{obj=_G.PlayerTalentFrameTitleText, y=-2}
				self:skinObject("tabs", {obj=this, prefix=fName, fType=ftype, lod=self.isTT and true})
				self:skinObject("slider", {obj=_G[fName .. 'ScrollFrameScrollBar'], fType=ftype, rpTex="artwork"})
				-- keep background Texture
				self:skinObject("frame", {obj=this, fType=ftype, cb=true, x1=10, y1=-12, x2=-31, y2=74})
				self:removeRegions(this, {1, 3, 4, 5, 6})
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
				if self.modBtnBs then
					skinTalentBtns(this)
					self:SecureHook("TalentFrame_Update", function(fObj)
						skinTalentBtns(fObj)
					end)
				end

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
				-- PlayerSpecTab1/2
				self:removeMagicBtnTex(_G.PlayerTalentFrameResetButton)
				self:removeMagicBtnTex(_G.PlayerTalentFrameLearnButton)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=1, y2=-3})
				if self.modBtns then
					self:skinStdButton{obj=_G.PlayerTalentFrameActivateButton, fType=ftype}
					self:skinStdButton{obj=_G.PlayerTalentFrameResetButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.PlayerTalentFrameLearnButton, fType=ftype, schk=true}
				end

				self:skinObject("glowbox", {obj=_G.PlayerTalentFrameHeaderHelpBox, fType=ftype})

				self:Unhook(this, "OnShow")
			end)
			if self.modBtnBs then
				self:SecureHook("PlayerTalentFramePanel_Update", function(fObj)
					if fObj.HeaderIcon
					and not fObj.pet
					then
						if _G.PlayerTalentFrame.primaryTree == fObj.talentTree then
							aObj:clrBtnBdr(fObj.HeaderIcon.sbb, "gold")
						else
							aObj:clrBtnBdr(fObj.HeaderIcon.sbb, "silver")
						end
					end
				end)
			end
			local sab1, hIcon
			local function skinPanel(frame)
				frame.Summary.IconBorder:SetTexture(nil)
				sab1 = _G[frame:GetName() .. "SummaryActiveBonus1"]
				sab1.IconBorder:SetTexture(nil)
				hIcon = frame.HeaderIcon
				hIcon.PrimaryBorder:SetTexture(nil)
				hIcon.SecondaryBorder:SetTexture(nil)
				aObj:changeTandC(hIcon.PointsSpentBgGold)
				aObj:changeTandC(hIcon.PointsSpentBgSilver)
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=2})
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.SelectTreeButton, fType=ftype}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=sab1, fType=ftype, relTo=sab1.Icon, clr="gold", ofs=3}
					aObj:addButtonBorder{obj=hIcon, fType=ftype, relTo=hIcon.Icon, reParent={hIcon.PointsSpentBgGold, hIcon.PointsSpentBgSilver, hIcon.LockIcon, hIcon.PointsSpent}, ofs=3}
					-- TODO: skin talent buttons
				end
				-- display Talent Tree background
				frame.BgTopLeft:SetAlpha(1)
				frame.BgTopRight:SetAlpha(1)
				frame.BgBottomLeft:SetAlpha(1)
				frame.BgBottomRight:SetAlpha(1)
			end
			self:SecureHookScript(_G.PlayerTalentFrameTalents, "OnShow", function(this)
				skinPanel(_G.PlayerTalentFramePanel1)
				skinPanel(_G.PlayerTalentFramePanel2)
				skinPanel(_G.PlayerTalentFramePanel3)
				self:removeMagicBtnTex(_G.PlayerTalentFrameToggleSummariesButton)
				self:skinObject("glowbox", {obj=_G.PlayerTalentFrameLearnButtonTutorial, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=_G.PlayerTalentFrameToggleSummariesButton, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.PlayerTalentFramePetTalents, "OnShow", function(this)
				_G.PlayerTalentFramePetModelBg:SetTexture(nil)
				self:makeMFRotatable(_G.PlayerTalentFramePetModel)
				_G.PlayerTalentFramePetShadowOverlay:DisableDrawLayer("OVERLAY")
				_G.PlayerTalentFramePetIconBorder:SetTexture(nil)
				_G.PlayerTalentFramePetPanel.HeaderBackground:SetTexture(nil)
				_G.PlayerTalentFramePetPanel.HeaderBorder:SetTexture(nil)
				hIcon = _G.PlayerTalentFramePetPanel.HeaderIcon
				hIcon.Border:SetTexture(nil)
				aObj:changeTandC(hIcon.PointsSpentBgGold)
				self:skinObject("frame", {obj=_G._G.PlayerTalentFramePetPanel, fType=ftype, kfs=true, fb=true, ofs=0})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.PlayerTalentFramePetInfo, fType=ftype, relTo=_G.PlayerTalentFramePetIcon, clr="gold"}
					self:addButtonBorder{obj=_G.PlayerTalentFramePetDiet, fType=ftype, clr="gold", ofs=1}
					self:addButtonBorder{obj=hIcon, fType=ftype, relTo=hIcon.Icon, reParent={hIcon.PointsSpentBgGold, hIcon.PointsSpent}, clr="gold"}
				end
				-- display Talent Tree background
				_G.PlayerTalentFramePetPanelBackgroundTopLeft:SetAlpha(1)
				_G.PlayerTalentFramePetPanelBackgroundTopRight:SetAlpha(1)
				_G.PlayerTalentFramePetPanelBackgroundBottomLeft:SetAlpha(1)
				_G.PlayerTalentFramePetPanelBackgroundBottomRight:SetAlpha(1)

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
			self:skinObject("statusbar", {obj=_G.TradeSkillRankFrame, fi=0, bg=_G.TradeSkillRankFrameBackground})
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
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.TradeSkillSkillIcon, clr="gold"}
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
						self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], onSB=true}
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
					self:addButtonBorder{obj=_G.TradeSkillDecrementButton, ofs=0, clr="gold"}
					self:addButtonBorder{obj=_G.TradeSkillIncrementButton, ofs=0, clr="gold"}
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

			if self.modBtnBs then
				self:addButtonBorder{obj=_G.WatchFrameCollapseExpandButton, es=12, ofs=0, x1=-1}
				local function skinQuestBtns()
					local bName
					for i = 1, _G.WATCHFRAME_NUM_ITEMS do
						bName = "WatchFrameItem" .. i
						self:addButtonBorder{obj=_G[bName], fType=ftype, reParent={_G[bName .. "HotKey"], _G[bName .. "Count"], _G[bName .. "Stock"]}}
					end
					return 0, 0, 0
				end
				_G.WatchFrame_AddObjectiveHandler(skinQuestBtns)
			end

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
