local aName, aObj = ...
if not aObj:isAddonEnabled("AphesLootBrowser") then return end

function aObj:AphesLootBrowser()

	-- Vendor frame
	ALBVendor.BG:SetBackdrop(nil)
	self:getChild(ALBVendorScroll, 3):SetBackdrop(nil)
	self:skinScrollBar{obj=ALBVendorScroll}
	self:addSkinFrame{obj=ALBVendor}
	self:SecureHook(AphesLootBrowser, "MERCHANT_SHOW", function(this)
		for i = 1, 9 do
			ALBVendor[i].BG:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=ALBVendor[i].Icon}
			end
		end
		self:Unhook(AphesLootBrowser, "MERCHANT_SHOW")
	end)

	local function skinFrames()
		-- Main Menu
		self:adjWidth{obj=ALBMainMenu_Close, adj=-11}
		self:adjHeight{obj=ALBMainMenu_Close, adj=-11}
		self:moveObject{obj=ALBMainMenu_Close, x=-2}
		for k, v in pairs{"Browser", "Search", "Upgrade", "Detail", "Wishlist"} do
			_G["ALBMainMenu"..v.."Background"]:SetTexture(nil)
			_G["ALBMainMenu"..v.."ActiveBackground"]:SetTexture(nil)
			_G["ALBMainMenu"..v.."Texture"]:SetTexture(nil)
			self:addSkinFrame{obj=_G["ALBMainMenu"..v], x1=3, y1=-3, x2=-3, y2=7}
		end
		self:addSkinFrame{obj=ALBMainMenu, y1=-2, y2=2}
		-- Browser Menu
		for i = 1, 20 do
			if self.modBtns then
				self:skinButton{obj=_G["ALBBrowserMenu"..i.."ExpandOrCollapseButton"], mp2=true, plus=true}
			end
			_G["ALBBrowserMenu"..i.."BarRightTexture"]:SetTexture(nil)
			_G["ALBBrowserMenu"..i.."LeftLine"]:SetTexture(nil)
			_G["ALBBrowserMenu"..i.."BottomLine"]:SetTexture(nil)
			_G["ALBBrowserMenu"..i.."Background"]:SetTexture(nil)
		end
		self:skinScrollBar{obj=ALBBrowserMenuScroll}
		self:addSkinFrame{obj=ALBBrowserMenu}
		-- Browser Detail
		for i = 1, 24 do
			_G["ALBBrowserItem"..i]:GetNormalTexture():SetTexture(nil)
			_G["ALBBrowserItem"..i]:GetPushedTexture():SetTexture(nil)
		end
		self:skinScrollBar{obj=ALBBrowserScroll}
		self:glazeStatusBar(ALBBrowserRep, 0, ALBBrowserRepFillBar)
		self:addSkinFrame{obj=ALBBrowser}
		self:keepRegions(ALBFrameOptions, {4, 5}) -- N.B. region 4 is text, 5 is highlight
		ALBFrameOptions.tabSF = self:addSkinFrame{obj=ALBFrameOptions, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=2}
		if self.isTT then
			self:setInactiveTab(ALBFrameOptions.tabSF)
		end
		ALBBrowserMoveIndicator:SetBackdropBorderColor(unpack(aObj.bbColour))
		self:addSkinFrame{obj=ALBBrowserMove, aso={bd=9, ng=true}, ofs=-3}
	end
	self:SecureHook(AphesLootBrowser, "OpenWindow", function(this)
		skinFrames()
		self:Unhook(AphesLootBrowser, "OpenWindow")
		self:Unhook(AphesLootBrowser, "ToggleWindow")
	end)
	self:SecureHook(AphesLootBrowser, "ToggleWindow", function(this)
		skinFrames()
		self:Unhook(AphesLootBrowser, "ToggleWindow")
		self:Unhook(AphesLootBrowser, "OpenWindow")
	end)

	local function skinDropDown(obj)
		obj:SetBackdrop(nil)
		if not aObj.db.profile.TexturedDD
		and not aObj.db.profile.DropDownButtons
		then
			return
		end
		obj.tbg = obj:CreateTexture(nil, "BACKGROUND")
		obj.tbg:SetTexture(self.itTex)
		obj.tbg:SetPoint("RIGHT", obj, "RIGHT", -4, 0)
		obj.tbg:SetWidth(obj:GetWidth() - 12)
		obj.tbg:SetHeight(18)
		if self.db.profile.DropDownButtons then
			self:addSkinFrame{obj=obj, aso={ng=true}, x1=4, y1=-3, x2=-1, y2=3}
		end
	end
	local function skinSearchFrame()
		self:skinEditBox{obj=ALBSearchName, regs={9}, noHeight=true, noWidth=true}
		self:skinEditBox{obj=ALBSearchilvlfrom, regs={9}, noHeight=true, noWidth=true}
		self:skinEditBox{obj=ALBSearchilvlto, regs={9}, noHeight=true, noWidth=true}
		self:skinEditBox{obj=ALBSearchlvlfrom, regs={9}, noHeight=true, noWidth=true}
		self:skinEditBox{obj=ALBSearchlvlto, regs={9}, noHeight=true, noWidth=true}
		skinDropDown(ALBSearchClassDropDown)
		local bNames = {"Name", "Custom", "Level", "Ilvl", "Type", "Loc", "Fac", "Source"}
		for i = 0, 10 do
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["ALBSearchItem"..i.."Icon"]}
			end
			for k, v in pairs(bNames) do
				_G["ALBSearchItem"..i..v.."Highlight"]:SetTexture(nil)
			end
		end
		self:skinScrollBar{obj=ALBSearchScroll}
		self:adjHeight{obj=ALBSearchCustom, adj=10}
		self:adjWidth{obj=ALBSearchCustom, adj=4}
		ALBSearchCustomButton:SetPoint("RIGHT", -2, 0)
		skinDropDown(ALBSearchCustom)
		self:addSkinFrame{obj=ALBSearch}
	end
	self:SecureHook(AphesLootBrowser, "MainMenuClick", function(this, ...)
		self:Debug("AphesLootBrowser MainMenuClick: [%s, %s]", this, this:GetID())
		local id = this:GetID()
		if id == 2
		and not self.skinFrame[ALBSearch]
		then
			skinSearchFrame()
		elseif id == 3
		and not self.skinFrame[ALBDetail]
		then
			if self.modBtnBs then
				self:addButtonBorder{obj=ALBDetailIcon, ofs=1}
			end
			ALBDetailIcon.sbb:Hide()
			self:SecureHook(ALBDetailIcon, "SetNormalTexture", function(this, tex)
				ALBDetailIcon.sbb:Show()
				self:Unhook(ALBDetailIcon, "SetNormalTexture")
			end)
			if self.db.profile.Tooltips.skin then
				if self.db.profile.Tooltips.style == 3 then ALBDetailTooltip:SetBackdrop(self.Backdrop[1]) end
				self:SecureHookScript(ALBDetailTooltip, "OnShow", function(this)
					self:skinTooltip(this)
				end)
			end
			self:skinScrollBar{obj=ALBDetailScroll}
			for i = 1, 8 do
				_G["ALBDetailSource"..i.."Highlight"]:SetTexture(nil)
			end
			self:skinEditBox{obj=ALBDetailLink, regs={9}}
			self:skinEditBox{obj=ALBDetailWowhead, regs={9}}
			self:skinEditBox{obj=ALBDetailDeWowhead, regs={9}}
			self:skinEditBox{obj=ALBDetailBuffed, regs={9}}
			self:addSkinFrame{obj=ALBDetail}
		elseif id == 4
		and not self.skinFrame[ALBUpgrade]
		then
			-- equipment selection table
			for i = 1, 12 do
				self:getRegion(_G["ALBUpgradeItem"..i.."Info"], 1):SetTexture(nil)
				if self.modBtns then
					self:getRegion(_G["ALBUpgradeItem"..i].Upgrade, 1):SetTexture(nil)
					self:skinButton{obj=_G["ALBUpgradeItem"..i].Upgrade, ob="+", x1=-2, y1=2, x2=2, y2=-2}
					_G["ALBUpgradeItem"..i].Upgrade:SetNormalFontObject(CombatTextFont)
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["ALBUpgradeItem"..i].Icon}
				end
				self:addSkinFrame{obj=_G["ALBUpgradeItem"..i].Hint}
			end
			-- item upgrade table
			--- column 2
			for i = 1, 13 do
				self:getRegion(_G["ALBUpgradeStats"..i], 1):SetTexture(nil)
			end
			--- columns 1, 3-5
			for i = 1, 4 do
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["ALBUpgradeTable"..(i-1)].Icon}
				end
				for j = 1, 13 do
					self:getRegion(_G["ALBUpgradeTable"..(i-1)..j], 1):SetTexture(nil)
				end
			end
			self:addSkinFrame{obj=ALBUpgrade}
			-- don't apply a backdrop or gradient texture so text can be seen
			self:addSkinFrame{obj=self:getChild(ALBUpgrade, 1), aso={bd=8, ng=true}}
			self:addSkinFrame{obj=ALBUpgradeInfo}
			if not self.skinFrame[ALBSearch] then
				skinSearchFrame()
			end
		elseif id == 5
		and not self.skinFrame[ALBWishlist]
		then
			-- menu frame
			local function skinWishList()
				for i = 1, 13 do
					if _G["ALBWishlistSelection"..i] then
						_G["ALBWishlistSelection"..i.."BG"]:SetTexture(nil)
					end
				end
			end
			skinWishList()
			self:SecureHook(AphesLootBrowser, "RedrawWishlists", function(this)
				skinWishList()
			end)
			self:addSkinFrame{obj=ALBWishlistSelection}
			ALBWishlistMoveIndicator:SetBackdropBorderColor(unpack(aObj.bbColour))
			self:addSkinFrame{obj=ALBWishlistMove, aso={bd=9, ng=true}, ofs=-3}
			-- detail frame
			self:skinScrollBar{obj=ALBWishlistScroll}
			self:skinEditBox{obj=ALBWishlistName, regs={9}}
			for i = 1, 24 do
				_G["ALBWishlistItem"..i]:GetNormalTexture():SetTexture(nil)
				_G["ALBWishlistItem"..i]:GetPushedTexture():SetTexture(nil)
			end
			self:addSkinFrame{obj=ALBWishlist}
		end
	end)
	local function skinWishlistPopup()
		if not self.skinFrame[ALBWishlistPopup] then
			self:skinEditBox{obj=ALBWishlistPopupName, regs={9}}
			self:addSkinFrame{obj=ALBWishlistPopup}
		end
	end
	local function skinVersionCheck()
		if not self.skinFrame[ALBVersionCheck] then
			self:skinScrollBar{obj=ALBVersionCheckScroll}
			-- don't apply a backdrop or gradient texture so text can be seen
			self:addSkinFrame{obj=ALBVersionList, aso={bd=8, ng=true}}
			self:addSkinFrame{obj=ALBVersionCheck}
		end
	end
	self:SecureHook(AphesLootBrowser, "CreateNewWishlist", function(this)
		skinWishlistPopup()
		self:Unhook(AphesLootBrowser, "CreateNewWishlist")
	end)
	self:SecureHook(AphesLootBrowser, "CreateNewSubscription", function(this)
		skinWishlistPopup()
		skinVersionCheck()
		self:Unhook(AphesLootBrowser, "CreateNewSubscription")
	end)
	self:SecureHook(AphesLootBrowser, "CheckVersions", function(this)
		skinVersionCheck()
		self:Unhook(AphesLootBrowser, "CheckVersions")
	end)
	self:SecureHook(AphesLootBrowser, "ExportWishlist", function(this)
		self:skinScrollBar{obj=ALBExportScroll}
		self:addSkinFrame{obj=ALBExportText}
		self:addSkinFrame{obj=ALBWishlistExportFrame}
		self:Unhook(AphesLootBrowser, "ExportWishlist")
	end)
	self:SecureHook(AphesLootBrowser, "ShowSearchFilter", function(this)
		skinDropDown(ALBFilterDropDown)
		skinDropDown(ALBFilterStatcompare)
		self:addSkinFrame{obj=ALBSearchFilterPopup}
		self:Unhook(AphesLootBrowser, "ShowSearchFilter")
	end)
	self:SecureHook(AphesLootBrowser, "OptionsShow", function(this)
		self:addSkinFrame{obj=ALBOptions, kfs=true}
		if self.isTT then
			self:setActiveTab(ALBFrameOptions.tabSF)
			self:SecureHook(ALBOptions, "Hide", function(this)
				self:setInactiveTab(ALBFrameOptions.tabSF)
			end)
			self:SecureHook(ALBOptions, "Show", function(this)
				self:setActiveTab(ALBFrameOptions.tabSF)
			end)
		end
		self:Unhook(AphesLootBrowser, "OptionsShow")
	end)

	-- Group Loot Roll Wishlist frame
	self:SecureHook(AphesLootBrowser, "START_LOOT_ROLL", function(this, ...)
		if ALB_SETTINGS.RollFrameWishlists then
			for i = 1, 4 do
				self:addSkinFrame{obj=_G["ALB"..i].wishframe}
			end
			self:Unhook(AphesLootBrowser, "START_LOOT_ROLL")
		end
	end)

end
