local _, aObj = ...
if not aObj:isAddonEnabled("Leatrix_Plus") then return end
local _G = _G

aObj.addonsToSkin.Leatrix_Plus = function(self) -- v 11.0.17/4.0.34/1.15.59

	local lpPanels = {
		-- All versions
		"SoundPanel",
		"WowheadPanel",
		"QuestPanel",
		"SellJunkFrame",
		"RepairPanel",
		"ChainPanel",
		"ClassFrame",
		"QuestTextPanel",
		"MailTextPanel",
		"MuteCustomPanel",
		"SideMinimap",
		"ExcludedButtonsPanel",
		"ChatFilterPanel",
		"AcceptResPanel",
		"DressupPanel",
		"ReleasePanel",
		"weatherPanel",
		"CooldownPanel",
		"SideTip",
		"InvPanel",
		-- ClassicERA only
		"FlightPanel",
		-- Classic only
		"VehiclePanel",
		"FocusPanel",
		-- ClassicERA/Classic only
		"BookTextPanel",
		"DurabilityPanel",
		"TimerPanel",
		"TrainerPanel",
		"EnhanceQuestPanel",
		"DismountFrame",
		"BuffPanel",
		"SideFrames",
		"WidgetPanel",
		"SideViewport",
		-- Retail only
		"MountPanel",
		"FasterLootPanel",
		"ChatFontSizePanel",
		"transPanel",
		"WidgetTopPanel",
		"ControlPanel",
		"HideChatButtonsPanel",
		"bordersPanel",
	}

	self:SecureHookScript(_G.LeaPlusGlobalPanel, "OnShow", function(this)
		local function skinKids(frame, _)
			aObj.RegisterCallback("LeatrixPlus", frame:GetDebugName() .. "_GetChildren", function(_, child, _)
				if child:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=child})
				elseif child:IsObjectType("ScrollFrame") then
					aObj:skinObject("scrollbar", {obj=child.ScrollBar, x1=2, x2=4})
				elseif child:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=child})
					child.f:SetBackdrop(nil)
				elseif child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("Button")
				and child.tiptext
				and aObj.modBtns
				then
					-- ignore Sell Junk Exclusions Help button
					if not child.t then
						aObj:skinStdButton{obj=child}
					end
				elseif child:IsObjectType("Button")
				and child.intrinsic == "DropdownButton"
				then
					aObj:skinObject("ddbutton", {obj=child})
				elseif child:IsObjectType("Frame")
				and child.scroll -- MuteCustomSounds
				then
					aObj:skinObject("scrollbar", {obj=child.scroll.ScrollBar})
					aObj:skinObject("frame", {obj=child, rb=true, fb=true, ofs=0})
				end
			end)
			aObj:scanChildren{obj=frame, cbstr=frame:GetDebugName() .. "_GetChildren"}
		end
		skinKids(this)

		-- LeaPlusScrollFrame
		this.t:SetTexture(nil)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1})
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(this, 2), noSkin=true}
		end
		for _, frame in _G.ipairs{this:GetChildren()} do
			if frame:IsObjectType("Frame") then
				skinKids(frame)
			end
		end
		local sideF
		for _, frameRef in _G.pairs(lpPanels) do
			sideF = _G["LeaPlusGlobalPanel_" .. frameRef]
			if sideF then
				skinKids(sideF, frameRef)
				-- if scrolling
				if sideF.backFrame then
					self:removeBackdrop(sideF.backFrame)
					aObj:skinObject("scrollbar", {obj=sideF.scrollFrame.ScrollBar})
					skinKids(sideF.scrollChild)
				end
				sideF.t:SetTexture(nil)
				self:skinObject("frame", {obj=sideF, kfs=true, ofs=-1})
				if self.modBtns then
					self:skinCloseButton{obj=sideF.c, noSkin=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- Enhanced Dressup (changes in DressUp frames)
	if _G.LeaPlusDB["EnhanceDressup"] == "On"
	and self.modBtns
	then
		self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 1)}
		self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 2)}
		self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 3)}
		if self.isRtl then
			self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 4)}
			self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 5)}
		else
			self:skinStdButton{obj=self:getChild(_G.SideDressUpFrame.ResetButton, 1)}
			self:skinStdButton{obj=self:getChild(_G.SideDressUpFrame.ResetButton, 2)}
		end
	end

	-- Enhanced QuestLog
	if _G.LeaPlusDB["EnhanceQuestLog"] == "On"
	and _G.LeaPlusDB["EnhanceQuestTaller"] == "On"
	and self.prdb.QuestLog
	then
		if self.isClscERA
		and self.modBtns
		then
			self:skinStdButton{obj=self:getPenultimateChild(_G.QuestLogFrame)} -- Map button
		end
	end

	-- Enhanced Professions (changes in CraftUI & TradeSkillUI)

	-- Enhanced Trainers [handled in ClassTrainerFrame skin code]

	-- Volume slider (Character frame)
	if _G.LeaPlusDB["ShowVolume"] == "On"
	and self.prdb.CharacterFrames
	then
		self:skinObject("slider", {obj=_G.LeaPlusGlobalSliderLeaPlusMaxVol})
	end

	-- Auction Controls (changes in AuctionUI)

	-- Durability status (PaperDollFrame)
	if _G.LeaPlusDB["DurabilityStatus"] == "On"
	and self.prdb.CharacterFrames
	and self.modBtnBs
	then
		local child = self.isRtl and 7 or self.isClscERA and 5 or 6
		self:addButtonBorder{obj=self:getChild(_G.PaperDollFrame, child), ofs=-2, clr="gold"}
	end

	-- Vanity controls (PaperDollFrame) [Classic ONLY]
	if _G.LeaPlusDB["ShowVanityControls"] == "On"
	and self.prdb.CharacterFrames
	and self.modChkBtns
	then
		self:skinCheckButton{obj=self:getPenultimateChild(_G.PaperDollFrame)}
		self:skinCheckButton{obj=self:getLastChild(_G.PaperDollFrame)}
	end

	-- Bag Search Box
	if _G.LeaPlusDB["ShowBagSearchBox"] == "On" then
		if self.prdb.ContainerFrames.skin then
			self:skinObject("editbox", {obj=_G.BagItemSearchBox, si=true})
			self:moveObject{obj=_G.BagItemSearchBox, x=7, y=3}
		end
		if self.prdb.BankFrame then
			self:skinObject("editbox", {obj=_G.BankItemSearchBox, si=true})
			self:moveObject{obj=_G.BankItemSearchBox, x=10, y=6}
		end
	end

end
