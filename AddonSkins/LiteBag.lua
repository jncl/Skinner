-- luacheck: ignore 631 (line is too long)
local _, aObj = ...
if not aObj:isAddonEnabled("LiteBag") then return end
local _G = _G

aObj.addonsToSkin.LiteBag = function(self) -- v 11.0.0-7

	local function skinFrame(frame)
		for _, btn in _G.pairs(_G[frame].panels[1].bagButtons) do
			aObj:keepFontStrings(btn)
			btn.icon:SetAlpha(1)
		end
		_G[frame .. "PanelMoneyFrame"].Border:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("tabs", {obj=_G[frame], tabs=_G[frame].Tabs, lod=self.isTT and true})
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
		skinFrame("LiteBagBank")
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
					aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.UpgradeIcon, btn.flash, btn.NewItemTexture, btn.BattlepayItemTexture, btn.BagIndicator, btn.JunkIcon, btn.LiteBagBindsOnText}, ofs=3}
					btn.ExtendedSlot:SetTexture(nil)
				end
				local info = _G.C_Container.GetContainerItemInfo(btn:GetParent():GetID(), btn:GetID()) -- bag, slot
				local quality = info and info.quality
				aObj:setBtnClr(btn, quality)
			end)
		end
	end

end
