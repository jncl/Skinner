local _, aObj = ...
if not aObj:isAddonEnabled("LiteBag") then return end
local _G = _G

aObj.addonsToSkin.LiteBag = function(self) -- v 10.1.0-3

	local function skinFrame(frame)
		for _, btn in _G.pairs(_G[frame].panels[1].bagButtons) do
			aObj:keepFontStrings(btn)
			btn.icon:SetAlpha(1)
		end
		_G[frame .. "PanelMoneyFrame"].Border:DisableDrawLayer("BACKGROUND")
		_G[frame].numTabs = 2
		aObj:skinObject("tabs", {obj=_G[frame], prefix=frame, lod=self.isTT and true})
		aObj:skinObject("frame", {obj=_G[frame], kfs=true, ri=true, cb=true})
	end

	self:SecureHookScript(_G.LiteBagBackpack, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.BagItemSearchBox, si=true})
		_G.LiteBagBackpackPanelTokenFrame.Border:DisableDrawLayer("BACKGROUND")
		skinFrame("LiteBagBackpack")
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.BagItemAutoSortButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.LiteBagBank, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.BankItemSearchBox, si=true})
		_G.ReagentBankFrame:DisableDrawLayer("ARTWORK") -- bank slots texture
		_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND") -- bank slots shadow texture
		_G.ReagentBankFrame:DisableDrawLayer("BORDER") -- shadow textures
		_G.ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
		_G.RaiseFrameLevelByTwo(_G.ReagentBankFrame.UnlockInfo) -- hide the slot button textures
		skinFrame("LiteBagBank")
		if self.modBtns then
			self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton}
			self:skinStdButton{obj=_G.ReagentBankFrame.DespositButton, schk=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.BankItemAutoSortButton}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.modBtnBs then
		if _G.LiteBag_RegisterHook then
		    _G.LiteBag_RegisterHook('LiteBagItemButton_Update', function (btn)
				local bIT = btn.icon:GetTexture()
				if bIT == 136509 -- ui-backpack-emptyslot
				or bIT == 4701874 -- bagitemslot2x
				then
					btn.icon:SetTexture(nil)
				end
				if not btn.sbb then
					local bName = btn:GetName()
					aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture, btn.UpgradeIcon, btn.flash, btn.NewItemTexture, btn.BattlepayItemTexture, btn.BagIndicator, btn.JunkIcon, _G[bName .. "LiteBagEQTexture1"], _G[bName .. "LiteBagEQTexture2"], _G[bName .. "LiteBagEQTexture3"], _G[bName .. "LiteBagEQTexture4"], btn.LiteBagBindsOnText}, ofs=3}
					btn.ExtendedSlot:SetTexture(nil)
				end
				local info = _G.C_Container.GetContainerItemInfo(btn:GetParent():GetID(), btn:GetID()) -- bag, slot
				local quality = info and info.quality
				aObj:setBtnClr(btn, quality)
			end)
		end
		self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(fObj)
			local btn
			for i = 1, fObj.size do
				btn = fObj["Item" .. i]
				self:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture}}
				-- force quality border update
				_G.BankFrameItemButton_Update(btn)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:SecureHook("BankFrameItemButton_Update", function(btn)
			if btn.sbb -- ReagentBank buttons may not be skinned yet
			and not btn.hasItem then
				self:clrBtnBdr(btn, "grey")
			end
		end)
	end

end
