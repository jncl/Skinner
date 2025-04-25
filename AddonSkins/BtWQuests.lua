local _, aObj = ...
if not aObj:isAddonEnabled("BtWQuests") then return end
local _G = _G

aObj.addonsToSkin.BtWQuests = function(self) -- v 2.50.2

	local function hookDDList(frame)
		aObj:RawHook(frame, "GetListFrame", function(this)
			local list = aObj.hooks[this].GetListFrame(this)
			aObj:removeBackdrop(list.Backdrop)
			aObj:removeBackdrop(list.MenuBackdrop)
			aObj:skinObject("frame", {obj=list, kfs=true, ofs=0})
			aObj:Unhook(this, "GetListFrame")
			return list
		end, true)
	end

	hookDDList(_G.BtWQuestsOptionsMenu)

	local function skinCategoryEntries(frame)
		for btn in frame.categoryItemPool:EnumerateActive() do
			-- ignore Header(s)
			if btn.item.item.type ~= "header" then
				btn:GetNormalTexture():SetAlpha(0)
				aObj:skinObject("frame", {obj=btn, fb=true, ofs=-2})
			end
		end
	end
	local function skinChainEntries(frame)
		for btn in frame.itemPool:EnumerateActive() do
			btn.Icon:SetTexture(nil)
			btn.Cover:SetTexture(nil)
			aObj:skinObject("frame", {obj=btn, ofs=0})
		end
	end
	self:SecureHookScript(_G.BtWQuestsFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		self:skinObject("frame", {obj=this.SearchPreview, kfs=true, ofs=5})
		self:skinObject("slider", {obj=this.SearchResults.scrollFrame.scrollBar})
		self:skinObject("frame", {obj=this.SearchResults, kfs=true, cb=true, x1=-4, y1=1, x2=6, y2=-3})
		self:skinObject("dropdown", {obj=this.CharacterDropDown, ddtx1=-4, ddty1=4, ddtx2=12, ddty2=4, x2=11})
		self:moveObject{obj=this.CharacterDropDown.Button, y=-1}
		self:skinNavBar(this.navBar)
		hookDDList(this.CharacterDropDown)
		hookDDList(this.navBar.dropDown)
		hookDDList(this.ExpansionDropDown)
		self:removeInset(this.Inset)
		local eFrame
		for i = 1, 3 do
			eFrame = this.ExpansionList["Expansion" .. i]
			self:skinObject("frame", {obj=eFrame, kfs=true, fb=true, ofs=0, clr="grey"})
			if self.modBtns then
				self:skinStdButton{obj=eFrame.ViewAll, ofs=0}
				self:skinStdButton{obj=eFrame.Load, ofs=0}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=eFrame.AutoLoad}
				eFrame.AutoLoad:SetSize(20, 20)
			end
		end
		self:skinObject("slider", {obj=this.Category.Scroll.ScrollBar})
		self:skinObject("slider", {obj=this.Chain.Scroll.ScrollBar})
		self:skinObject("frame", {obj=this, kfs=true, cbns=true})
		if self.modBtns then
			self:skinOtherButton{obj=this.NavBack, font=self.fontS, disfont=self.fontDS, text=self.larrow, noSkin=true}
			self:skinOtherButton{obj=this.NavForward, font=self.fontS, disfont=self.fontDS, text=self.rarrow, noSkin=true}
			self:skinOtherButton{obj=this.NavHere, font=self.fontS, disfont=self.fontDS, text=self.swarrow, noSkin=true}
			self:skinOtherButton{obj=this.OptionsButton, font=self.fontS, disfont=self.fontDS, text=self.gearcog, noSkin=true}
			self:moveObject{obj=this.OptionsButton, y=-3}
			self:SecureHook(this, "DisplayItemList", function(fObj, ...)
				skinCategoryEntries(fObj)
			end)
			skinCategoryEntries(this)
			self:SecureHook(this.Chain.Scroll, "SetChain", function(fObj, ...)
				skinChainEntries(fObj)
			end)
		end

		-- tooltips
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.BtWQuestsFrameChainTooltip)
			self:add2Table(self.ttList, _G.BtWQuestsFrameTooltip)
		end)

		self:Unhook(this, "OnShow")
	end)

	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.BtWQuestsTooltip)
	end)

	self.mmButs["BtWQuests"] = _G.BtWQuestsMinimapButton
	_G.BtWQuestsMinimapButton:SetSize(24, 24)
	_G.BtWQuestsMinimapButtonIcon:SetDrawLayer("ARTWORK")
	self:moveObject{obj=_G.BtWQuestsMinimapButtonIcon, x=-5, y=5}

end
