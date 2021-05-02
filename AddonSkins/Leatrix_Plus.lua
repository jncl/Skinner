local aName, aObj = ...
if not aObj:isAddonEnabled("Leatrix_Plus") then return end
local _G = _G

aObj.addonsToSkin.Leatrix_Plus = function(self) -- v 9.0.26/1.13.103

	self:SecureHookScript(_G.LeaPlusGlobalPanel, "OnShow", function(this)
		local function skinKids(frame)
			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("Slider") then
					aObj:skinSlider{obj      = child, hgt=-4}
				elseif child:IsObjectType("ScrollFrame") then
					aObj:skinSlider{obj      = child.ScrollBar}
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj     = child, regs={6}} -- 6 is text
					child.f:SetBackdrop(nil)
				elseif child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj = child}
				elseif child:IsObjectType("Button")
				and child.tiptext
				and aObj.modBtns
				then
					aObj:skinStdButton{obj   = child}
				elseif child:IsObjectType("Frame")
				and child:GetNumChildren() == 2
				and aObj:getChild(child, 1):GetNumRegions() == 5
				then
					local dd                 = aObj:getChild(child, 1) -- dropdown frame
					dd.Left                  = aObj:getRegion(dd, 1)
					dd.Right                 = aObj:getRegion(dd, 2)
					dd.Button                = aObj:getChild(dd, 1)
					aObj:skinDropDown{obj    = dd}
					aObj:addSkinFrame{obj    = aObj:getChild(child, 2), ft="a", kfs=true, nb=true, ofs=0} -- dropdown list
					dd                       = nil
				end
			end
		end

		-- LeaPlusGlobalPanel
		skinKids(_G.LeaPlusGlobalPanel)
		self:addSkinFrame{obj=_G.LeaPlusGlobalPanel, ft="a", kfs=true, nb=true, ofs=-1}
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.LeaPlusGlobalPanel, 2)}
		end

		-- Pages
		for _, frame in _G.ipairs{_G.LeaPlusGlobalPanel:GetChildren()} do
			if frame:IsObjectType("Frame") then
				skinKids(frame)
			end
		end

		-- Side frames
		for _, frameRef in pairs{"ChainPanel", "SideMinimap", "QuestTextPanel", "MailTextPanel", "SideFrames", "CooldownPanel", "SideTip", "SideViewport", "InvPanel"} do
			local sideF = _G["LeaPlusGlobalPanel_" .. frameRef]
			if sideF then
				skinKids(sideF)
				self:addSkinFrame{obj=sideF, ft="a", kfs=true, nb=true}
				if self.modBtns then
					self:skinCloseButton{obj=sideF.c}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- Enhanced Dressup (changes in DressUp frames)
	if _G.LeaPlusDB["EnhanceDressup"] == "On"
	and self.modBtns
	then
		self:skinStdButton{obj=self:getChild(_G.DressUpFrame, 9)}
		self:skinStdButton{obj=self:getChild(_G.DressUpFrame, 10)}
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
		self:skinSlider{obj=_G.LeaPlusGlobalSliderLeaPlusMaxVol, hgt=-6}
	end
	-- Auction Controls (changes in AuctionUI)
	-- Durability status (Character frame)
	if _G.LeaPlusDB["DurabilityStatus"] == "On"
	and self.prdb.CharacterFrames
	and self.modBtnBs
	then
		self:addButtonBorder{obj=self:getLastChild(_G.PaperDollFrame), ofs=-2, clr="gold"}
	end
	-- Vanity controls (Character frame)
	if _G.LeaPlusDB["ShowVanityControls"] == "On"
	and self.prdb.CharacterFrames
	and self.modChkBtns
	then
		self:skinCheckButton{obj=self:getChild(_G.CharacterFrame, 13)}
		self:skinCheckButton{obj=self:getChild(_G.CharacterFrame, 14)}
	end
	-- Bag Search Box
	if _G.LeaPlusDB["ShowBagSearchBox"] == "On" then
		if self.prdb.ContainerFrames.skin then
			self:skinEditBox{obj=_G.BagItemSearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			self:moveObject{obj=_G.BagItemSearchBox, x=7, y=3}
		end
		if self.prdb.BankFrame then
			self:skinEditBox{obj=_G.BankItemSearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			self:moveObject{obj=_G.BankItemSearchBox, x=10, y=6}
		end
	end
	-- Free bag slots (nothing to do)
	-- Wowhead links (nothing to do)

end
