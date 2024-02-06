local _, aObj = ...
if not aObj:isAddonEnabled("Baganator") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Baganator = function(self) -- v 0.143

	local skinBtns = _G.nop
	if self.modBtnBs then
		function skinBtns(frame)
			aObj:Debug("skinBtns: [%s, %s]", frame)
			for _, btn in _G.ipairs(frame.buttons) do
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ItemLevel, btn.BindingText, btn.UpgradeArrow}}
				aObj:clrButtonFromBorder(btn)
			end
		end
	end

	local function skinFrame(frame)
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		if not aObj.isRtl then
			frame.TitleText:SetDrawLayer("BACKGROUND")
		end
		aObj:skinObject("editbox", {obj=frame.SearchBox, si=true})
		aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true, x2=1})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.CustomiseButton}
			aObj:moveObject{obj=frame.CustomiseButton, y=-1}
			aObj:skinStdButton{obj=frame.SortButton}
			aObj:skinStdButton{obj=frame.TransferButton}
			aObj:skinStdButton{obj=frame.ToggleBagSlotsButton, ofs=0}
			if frame.ToggleReagentsBankButton then
				aObj:skinStdButton{obj=frame.ToggleReagentsBankButton}
			end
		end
	end

	self:SecureHookScript(_G.Baganator_MainViewFrame, "OnShow", function(this)
		skinFrame(this)
		if this.Tabs then
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
		end
		self:SecureHook(this, "RefreshTabs", function(fObj)
			self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true})
		end)
		if self.modBtns then
			self:skinStdButton{obj=this.ToggleBankButton, ofs=0}
			self:skinStdButton{obj=this.ToggleAllCharacters, ofs=0}
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
			self:SecureHook(this.BagCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.BankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.BankCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBankLive, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
			self:SecureHook(this.ReagentBankCached, "ShowCharacter", function(fObj, _)
				skinBtns(fObj)
			end)
		end
		-- hook this to skin ReagentBag & ReagentBankBag
		self:SecureHook(_G.Baganator_MainViewFrame, "UpdateForCharacter", function(fObj, _)

			if fObj.CollapsingBags
			and fObj.CollapsingBags[1]
			and fObj.CollapsingBags[1].key == "reagentBag"
			then
				skinBtns(fObj.CollapsingBags[1].live)
				skinBtns(fObj.CollapsingBags[1].cached)
				if self.modBtns then
					self:skinStdButton{obj=fObj.CollapsingBags[1].button, ofs=0}
				end
			end

			if fObj.CollapsingBankBags
			and fObj.CollapsingBankBags[1]
			and fObj.CollapsingBankBags[1].key == "reagentBag"
			then
				skinBtns(fObj.CollapsingBankBags[1].live)
				skinBtns(fObj.CollapsingBankBags[1].cached)
				if self.modBtns then
					self:skinStdButton{obj=fObj.CollapsingBankBags[1].button, ofs=0}
				end
			end

		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.Baganator_BankOnlyViewFrame, "OnShow", function(this)
		skinFrame(this)
		if self.modBtns then
			self:skinStdButton{obj=this.DepositIntoReagentsBankButton}
			self:skinStdButton{obj=this.BuyReagentBankButton}
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
