local _, aObj = ...
if not aObj:isAddonEnabled("BtWQuests") then return end
local _G = _G

aObj.addonsToSkin.BtWQuests = function(self) -- v 1.66

	local function skinDDlist(frame)
		frame.list.Backdrop:SetBackdrop(nil)
		frame.list.MenuBackdrop:SetBackdrop(nil)
		aObj:addSkinFrame{obj=frame.list, ft="a", kfs=true, nb=true}
	end
	local function hookGLF(frame)
		aObj:SecureHook(frame, "GetListFrame", function(this)
			aObj:Unhook(this, "GetListFrame")
			skinDDlist(this)
		end)
	end
	hookGLF(_G.BtWQuestsOptionsMenu)

	self:SecureHookScript(_G.BtWQuestsFrame, "OnShow", function(this)

		self:skinEditBox{obj=this.SearchBox, regs={6}} -- 6 is text
		self:addSkinFrame{obj=this.SearchPreview, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=this.SearchResults, ft="a", kfs=true, nb=true}

		hookGLF(this.CharacterDropDown)
		this.navBar:DisableDrawLayer("BACKGROUND")
		this.navBar:DisableDrawLayer("BORDER")
		this.navBar.overlay:DisableDrawLayer("OVERLAY")
		this.navBar.home:DisableDrawLayer("OVERLAY")
		this.navBar.home:GetNormalTexture():SetAlpha(0)
		this.navBar.home:GetPushedTexture():SetAlpha(0)
		this.navBar.home.text:SetPoint("RIGHT", -20, 0)
		hookGLF(this.navBar.dropDown)
		hookGLF(this.ExpansionDropDown)

		local skinBtn, abb2eb
		if self.modBtnBs then
			function skinBtn(btn)
				btn:SetNormalTexture(nil)
				aObj:addButtonBorder{obj=btn, nc=true, ofs=-1, clr=btn.Active and btn.Active:IsShown() and "green" or btn.Acive and btn.Acive:IsShown() and "green"}
				if btn.Active then
					btn.Active:Hide()
				end
				if btn.Acive then
					btn.Acive:Hide()
				end
				if btn.Background then
					btn.Background:SetAlpha(1)
				end
			end
			function abb2eb(expn)
				for btn in expn.buttonPool:EnumerateActive() do
					skinBtn(btn)
				end
			end
			self:SecureHook(this, "DisplayExpansionList", function(this, scrollTo)
				for _, expn in _G.pairs(this.ExpansionList.Expansions) do
					abb2eb(expn)
				end
			end)
		end

		for _, expn in _G.pairs(this.ExpansionList.Expansions) do
			self:addFrameBorder{obj=expn, ft="a"}
			expn.Background:SetAlpha(1)
			if self.modBtns then
				self:skinStdButton{obj=expn.ViewAll, aso={ng=true}, ofs=-3}
				self:skinStdButton{obj=expn.Load, aso={ng=true}, ofs=-3}
			end
			if self.modBtnBs then
				abb2eb(expn)
			end
			if self.modChkBtns then
				expn.AutoLoad:SetSize(20, 20)
				self:skinCheckButton{obj=expn.AutoLoad}
			end
		end

		self:skinSlider{obj=_G.BtWQuestsFrameCategoryScrollBar, wdth=-4}
		self:addFrameBorder{obj=this.Category, ft="a", ofs=2, x2=5}
		if self.modBtnBs then
			for btn in this.categoryItemPool:EnumerateActive() do
				skinBtn(btn)
			end
			self:SecureHook(this, "DisplayItemList", function(this, items, scrollTo)
				for btn in this.categoryItemPool:EnumerateActive() do
					skinBtn(btn)
				end
			end)
		end

		-- TODO: skin chain buttons ??
		self:skinSlider{obj=_G.BtWQuestsChainScrollFrame.ScrollBar, wdth=-4}
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, y1=3}
		if self.modBtnBs then
			self:addButtonBorder{obj=this.NavBack, ofs=-4, x1=3, clr="grey"}
			self:addButtonBorder{obj=this.NavForward, ofs=-4, x1=3, clr="grey"}
			self:SecureHook(this, "UpdateHistoryButtons", function(this)
				self:clrBtnBdr(this.NavBack, "gold")
				self:clrBtnBdr(this.NavForward, "gold")
			end)
			self:addButtonBorder{obj=this.NavHere, ofs=-4, x1=3}
			self:SecureHook(this, "UpdateHereButton", function(this)
				self:clrBtnBdr(this.NavHere, "gold")
			end)
			self:addButtonBorder{obj=this.CharacterDropDown.Button, ofs=-1, x1=0}
			self:addButtonBorder{obj=this.OptionsButton, ofs=-4, x1=3}
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.BtWQuestsTooltip)
		self:add2Table(self.ttList, _G.BtWQuestsFrame.Tooltip)
		_G.BtWQuestsFrame.Chain.Tooltip.ofs = -1
		self:add2Table(self.ttList, _G.BtWQuestsFrame.Chain.Tooltip)
	end)

end
