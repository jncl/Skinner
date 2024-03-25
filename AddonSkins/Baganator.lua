local _, aObj = ...
if not aObj:isAddonEnabled("Baganator") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Baganator = function(self) -- v 216

	local skinBtns, skinBags = _G.nop, _G.nop
	if self.modBtnBs then
		function skinBtns(frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ItemLevel, btn.BindingText, btn.UpgradeArrow}}
				aObj:clrButtonFromBorder(btn)
			end
		end
		function skinBags(frame)
			if frame.CollapsingBags then
				for _, layout in _G.ipairs(frame.CollapsingBags) do
					skinBtns(layout.live)
					skinBtns(layout.cached)
					aObj:skinStdButton{obj=layout.button, ofs=0} -- Show Reagents button
				end
			end
			if frame.CollapsingBankBags then
				for _, layout in _G.ipairs(frame.CollapsingBankBags) do
					skinBtns(layout.live)
					skinBtns(layout.cached)
					aObj:skinStdButton{obj=layout.button, ofs=0} -- Show Reagents button
				end
			end
		end
	end

	local function skinFrame(frame, type)
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		if not aObj.isRtl then
			frame.TitleText:SetDrawLayer("BACKGROUND")
		end
		aObj:skinObject("editbox", {obj=frame.SearchBox, si=true})
		aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true, x2=1})
		if aObj.modBtns then
			-- Backpack & Bank only
			if frame.AllFixedButtons then
				for _, btn in _G.pairs(frame.AllFixedButtons) do
					aObj:skinStdButton{obj=btn}
				end
				for _, btn in _G.pairs(frame.TopButtons) do
					aObj:skinStdButton{obj=btn}
				end
			end
			-- GuildView only
			if frame.FixedButtons then
				for _, btn in _G.pairs(frame.FixedButtons) do
					aObj:skinStdButton{obj=btn}
				end
				for _, btn in _G.pairs(frame.LiveButtons) do
					aObj:skinStdButton{obj=btn}
				end
			end
		end
		if aObj.modBtnBs then
			local method = type == "guild" and "ShowGuild" or "ShowCharacter"
			for _, layout in _G.pairs(frame.Layouts) do
				aObj:SecureHook(layout, method, function(fObj)
					skinBtns(fObj)
				end)
			end
		end
		if type == "guild" then
			return
		end
		aObj:SecureHook(frame, "UpdateForCharacter", function(fObj, _)
			for _, bag in _G.ipairs(fObj.CollapsingBags or fObj.CollapsingBankBags) do
				bag.divider:DisableDrawLayer("BACKGROUND")
			end
			if self.modBtnBs then
				skinBags(fObj)
			end
			for _, btn in _G.ipairs(fObj.liveBagSlots or fObj.liveBankBagSlots) do
				self:addButtonBorder{obj=btn, ibt=true}
				self:clrButtonFromBorder(btn)
				if btn.needPurchase then
					self:clrBBC(btn.sbb, "red")
				end
			end
			for _, btn in _G.ipairs(fObj.cachedBagSlots or fObj.cachedBankBagSlots) do
				self:addButtonBorder{obj=btn, ibt=true}
				self:clrButtonFromBorder(btn)
				if btn.needPurchase then
					self:clrBBC(btn.sbb, "red")
				end
			end
		end)
	end

	self:SecureHookScript(_G.Baganator_BackpackViewFrame, "OnShow", function(this)
		skinFrame(this)
		if this.Tabs then
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
		end
		self:SecureHook(this, "RefreshTabs", function(fObj)
			self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true})
		end)
		if self.modBtns then
			self:skinStdButton{obj=this.GlobalSearchButton}
			skinBags(this)
		end

		self:SecureHookScript(this.CharacterSelect, "OnShow", function(fObj)
			self:skinObject("editbox", {obj=fObj.SearchBox, si=true})
			self:skinObject("scrollbar", {obj=fObj.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, cb=true, x2=1})

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_BankViewFrame, "OnShow", function(this)
		skinFrame(this)
		if self.modBtns then
			self:skinStdButton{obj=this.DepositIntoReagentsBankButton}
			self:skinStdButton{obj=this.BuyReagentBankButton}
			skinBags(this)
		end

		self:Unhook(this, "OnShow")
	end)

    if not _G.Baganator.Constants.IsEra
	and _G.Baganator.Config.Get(_G.Baganator.Config.Options.ENABLE_GUILD_VIEW)
	then
		self:SecureHookScript(_G.Baganator_GuildViewFrame, "OnShow", function(this)
			skinFrame(this, "guild")
			if this.Tabs then
				for _, tab in _G.pairs(this.Tabs) do
					tab:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						 self:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=3, x2=2}
					end
				end
			end

			self:SecureHookScript(this.LogsFrame, "OnShow", function(fObj)
				fObj.TopTileStreaks:SetTexture(nil)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar})
				self:skinObject("frame", {obj=fObj, kfs=true, cb=true})

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.TabTextFrame, "OnShow", function(fObj)
				fObj.TopTileStreaks:SetTexture(nil)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar})
				self:skinObject("frame", {obj=fObj, kfs=true, cb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.SaveButton}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
	end

	_G.Baganator.CallbackRegistry:RegisterCallback("ShowCustomise", function()
		local this = _G.BaganatorCustomiseDialogFrame
		this.Bg:SetTexture(nil)
		this.TopTileStreaks:SetTexture(nil)
		for _, frame in _G.ipairs(this.Views) do
			for _, child in _G.ipairs{frame:GetChildren()} do
				if child.CheckBox
				and self.modChkBtns
				then
					self:skinCheckButton{obj=child.CheckBox}
				elseif child.Slider then
					self:skinObject("slider", {obj=child.Slider})
				elseif child.DropDown
				and child.DropDown.Popout
				then
					self:skinObject("frame", {obj=child.DropDown.Popout.Border, kfs=true, x1=7, y1=0, x2=-12, y2=20, clr="grey"})
				elseif child:IsObjectType("Frame")
				and child:GetNumChildren() == 6  -- Icons, Icon Corners
				then
					for _, kid in _G.ipairs{child:GetChildren()} do
						if kid.Popout then
							self:skinObject("frame", {obj=kid.Popout.Border, kfs=true, x1=7, y1=0, x2=-12, y2=20, clr="grey"})
						elseif kid.ScrollBar then
							self:skinObject("scrollbar", {obj=kid.ScrollBar})
							self:skinObject("frame", {obj=kid, kfs=true, rns=true, fb=true, clr="grey"})
						end
					end
				elseif child:IsObjectType("Button")
				and child.Count
				and self.modBtnBs
				then
					self:addButtonBorder{obj=child, clr="grey"}
				end
			end
			if frame.ResetFramePositions
			and self.modBtns
			then
				self:skinStdButton{obj=frame.ResetFramePositions}
			end
			self:skinObject("frame", {obj=frame, kfs=true, fb=true, ofs=-2, y1=23})
		end
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true, offsets={x1=8, y1=-4, x2=-8, y2=-2}})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true, ofs=0, y1=self.isRtl and -1 or 2})

		_G.Baganator.CallbackRegistry:UnregisterCallback("ShowCustomise", aObj)
	end)

end
