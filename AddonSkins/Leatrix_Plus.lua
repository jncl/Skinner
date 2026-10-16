local _, aObj = ...
if not aObj:isAddonEnabled("Leatrix_Plus") then return end
local _G = _G

aObj.addonsToSkin.Leatrix_Plus = function(self) -- v 12.1.09/5.1.59/2.5.44/1.60.19/1.15.160

	local function skinKids(frame)
		for _, child in _G.ipairs_reverse{frame:GetChildren()} do
			if child:IsObjectType("Slider") then
				aObj:skinObject("slider", {obj=child})
			elseif child:IsObjectType("ScrollFrame") then
				aObj:skinObject("scrollbar", {obj=child.ScrollBar})
			elseif child:IsObjectType("EditBox") then
				aObj:skinObject("editbox", {obj=child, x1=-4, x2=4})
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
		end
	end
	local function skinPanels(MainPanel, configPanels)
		-- Main Panel
		self:skinObject("editbox", {obj=self:getLastChild(MainPanel)})
		self:keepFontStrings(MainPanel, true) -- hide textures as alpha values are changed in code
		self:skinObject("frame", {obj=MainPanel, ofs=-1})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(MainPanel, 1)} -- reload button
			self:skinCloseButton{obj=self:getChild(MainPanel, 2)} -- close button
		end
		-- skin results frame
		local results = self:getChild(MainPanel, 23)
		local backFrame = self:getChild(results, 1)
		self:removeBackdrop(backFrame)
		self:skinObject("scrollbar", {obj=self:getChild(backFrame, 1).ScrollBar})
		skinKids(self:getChild(self:getChild(backFrame, 1), 1))
		-- skin Page0..9 frames
		for i = 3, 23, 2 do
			skinKids(self:getChild(MainPanel, i))
		end
		-- configuration panels
		for _, cPanel in _G.pairs(configPanels) do
			skinKids(cPanel)
			if cPanel.backFrame then
				self:removeBackdrop(cPanel.backFrame)
				self:skinObject("scrollbar", {obj=cPanel.scrollFrame.ScrollBar})
				skinKids(cPanel.scrollChild)
			end
			self:keepFontStrings(cPanel, true) -- hide textures as alpha values are changed in code
			self:skinObject("frame", {obj=cPanel, kfs=true, ofs=-1})
			if cPanel.c
			and self.modBtns
			then
				self:skinCloseButton{obj=cPanel.c}
			end
		end
	end
	local cnt, configPanels, MainPanel = 0, {}
	self.RegisterCallback("Leatrix_Plus", "UIParent_GetChildren", function(_, child, _)
		if (child.t
			and child.mt
			and child.v)
		then
			cnt = cnt + 1
			MainPanel = child
		elseif (child.t
			and child.c
			and child.r
			and child.h
			and child.b)
		then
			cnt = cnt + 1
			self:add2Table(configPanels, child)
		end
		if MainPanel
		and #configPanels == (cnt - 1)
		then
			self.UnregisterCallback("Leatrix_Plus", "UIParent_GetChildren")
			skinPanels(MainPanel, configPanels)
		end
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

	-- Enhanced Trainers
	if _G.LeaPlusDB["EnhanceTrainers"] == "On"
	and self.isClscERA
	and self.modBtns
	then
		self:skinStdButton{obj=_G.LeaPlusGlobalTrainAllButton, sechk=true} -- Train All button
	end

	-- Volume slider (Character frame)
	if _G.LeaPlusDB["ShowVolume"] == "On"
	and self.prdb.CharacterFrames
	then
		self:skinObject("slider", {obj=_G.LeaPlusGlobalSliderLeaPlusMaxVol})
	end

	-- Auction Controls
	if _G.LeaPlusDB["AhExtras"] == "On" then
		self:skinStdButton{obj=self:getLastChild(_G.AuctionFrameAuctions)}
		if self.modChkBtns then
			self:skinCheckButton{obj=self:getPenultimateChild(_G.AuctionFrameAuctions)}
			self:skinCheckButton{obj=self:getChild(_G.AuctionFrameAuctions, _G.AuctionFrameAuctions:GetNumChildren() - 2)}
		end
	end

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
