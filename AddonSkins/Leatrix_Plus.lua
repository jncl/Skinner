local _, aObj = ...
if not aObj:isAddonEnabled("Leatrix_Plus") then return end
local _G = _G

aObj.addonsToSkin.Leatrix_Plus = function(self) -- v 9.1.13/1.13.106/2.5.61

	self:SecureHookScript(_G.LeaPlusGlobalPanel, "OnShow", function(this)
		local function skinKids(frame)
			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=child})
				elseif child:IsObjectType("ScrollFrame") then
					aObj:skinObject("slider", {obj=child.ScrollBar})
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={6}} -- 6 is text
					child.f:SetBackdrop(nil)
				elseif child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("Button")
				and child.tiptext
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=child}
				elseif child:IsObjectType("Frame")
				and child:GetNumChildren() == 2
				and aObj:getChild(child, 1):GetNumRegions() == 5
				then
					local dd = aObj:getChild(child, 1) -- dropdown frame
					dd.Left = aObj:getRegion(dd, 1)
					dd.Right = aObj:getRegion(dd, 2)
					dd.Button = aObj:getChild(dd, 1)
					aObj:skinObject("dropdown", {obj=dd})
					aObj:skinObject("frame", {obj=aObj:getChild(child, 2), kfs=true, ofs=0}) -- dropdown list
				end
			end
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
		for _, frameRef in _G.pairs{"SoundPanel", "QuestPanel", "ChainPanel", "ClassFrame", "SideMinimap", "QuestTextPanel", "MailTextPanel", "BookTextPanel", "weatherPanel", "BuffPanel", "SideFrames", "WidgetPanel", "FocusPanel", "CooldownPanel", "SideTip", "SideViewport", "InvPanel"} do
			sideF = _G["LeaPlusGlobalPanel_" .. frameRef]
			if sideF then
				skinKids(sideF)
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
		if self.isRtl then
			self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 1)}
			self:skinStdButton{obj=self:getChild(_G.DressUpFrame.ResetButton, 2)}
		else
			if not _G.DressUpFrame.sf then
				self:skinStdButton{obj=self:getPenultimateChild(_G.DressUpFrame)}
				self:skinStdButton{obj=self:getLastChild(_G.DressUpFrame)}
			end
		end
	end

	-- Enhanced QuestLog
	if _G.LeaPlusDB["EnhanceQuestLog"] == "On"
	and self.prdb.QuestLog
	then
		self:skinStdButton{obj=self:getPenultimateChild(_G.QuestLogFrame)} -- Map button
	end
	-- Enhanced Professions (changes in CraftUI & TradeSkillUI)

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
		if self.isClscBC then
			self:addButtonBorder{obj=self:getChild(_G.PaperDollFrame, 6), ofs=-2, clr="gold"}
		elseif self.isClsc then
			self:addButtonBorder{obj=self:getChild(_G.PaperDollFrame, 5), ofs=-2, clr="gold"}
		else
			self:addButtonBorder{obj=self:getLastChild(_G.PaperDollFrame), ofs=-2, clr="gold"}
		end
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
			-- self:skinEditBox{obj=_G.BagItemSearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			self:moveObject{obj=_G.BagItemSearchBox, x=7, y=3}
		end
		if self.prdb.BankFrame then
			self:skinObject("editbox", {obj=_G.BankItemSearchBox, si=true})
			-- self:skinEditBox{obj=_G.BankItemSearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			self:moveObject{obj=_G.BankItemSearchBox, x=10, y=6}
		end
	end

end
