local _, aObj = ...
if not aObj:isAddonEnabled("Baganator") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Baganator = function(self) -- v 0.42

	local skinBtns
	if self.modBtnBs then
		function skinBtns(frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ItemLevel, btn.BindingText, btn.UpgradeArrow}}
				aObj:clrButtonFromBorder(btn)
			end
		end
	end

	self:SecureHookScript(_G.Baganator_MainViewFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		this:DisableDrawLayer("OVERLAY")
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		if this.Tabs then
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
		end
		self:SecureHook(this, "RefreshTabs", function(fObj)
			self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true})
		end)
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=this.CustomiseButton}
			self:moveObject{obj=this.CustomiseButton, y=-1}
			self:skinStdButton{obj=this.SortButton}
			self:skinStdButton{obj=this.ToggleBankButton, ofs=-1}
			self:skinStdButton{obj=this.ToggleReagentsButton}
			self:skinStdButton{obj=this.ToggleReagentsBankButton}
			self:skinStdButton{obj=this.ToggleAllCharacters, ofs=-1}
		end

		self:SecureHookScript(this.CharacterSelect, "OnShow", function(fObj)
			fObj.Bg:DisableDrawLayer("BACKGROUND")
			if not self.isRtl then
				fObj.TitleContainer.TitleBg:SetTexture(nil)
			end
			self:skinObject("editbox", {obj=fObj.SearchBox, si=true})
			self:skinObject("scrollbar", {obj=fObj.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true, cb=true})

			self:Unhook(fObj, "OnShow")
		end)

		if self.modBtnBs then
			self:SecureHook(this.BagLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBagLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.BankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.BagCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBagCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.BankCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBankCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_BankOnlyViewFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		this:DisableDrawLayer("OVERLAY")
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=this.CustomiseButton}
			self:moveObject{obj=this.CustomiseButton, y=-1}
			self:skinStdButton{obj=this.SortButton}
			self:skinStdButton{obj=this.ToggleReagentsBankButton}
			self:skinStdButton{obj=this.DepositIntoReagentsBankButton}
		end

		if self.modBtnBs then
			self:SecureHook(this.BankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

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
