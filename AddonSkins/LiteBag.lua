local _, aObj = ...
if not aObj:isAddonEnabled("LiteBag") then return end
local _G = _G

aObj.addonsToSkin.LiteBag = function(self) -- v 10.0.9

	local function skinFrame(frame)
		_G[frame .. "PanelMoneyFrame"].Border:DisableDrawLayer("BACKGROUND")
		_G[frame].numTabs = 2
		aObj:skinObject("tabs", {obj=_G[frame], prefix=frame, lod=self.isTT and true})
		aObj:skinObject("frame", {obj=_G[frame], kfs=true, ri=true, cb=true})
		if aObj.modBtnBs then
			aObj:SecureHook(_G[frame .. "Panel"], "UpdateItems", function(fObj)
				for _, btn in fObj:EnumerateValidItems() do
					if not btn.sbb then
						aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture, btn.UpgradeIcon, btn.NewItemTexture, btn.BattlepayItemTexture, btn.JunkIcon}, ofs=3, clr="grey"}
					end
					if not btn.hasItem then
						btn.icon:SetAlpha(0)
					end
				end
			end)
		end
	end

	self:skinObject("editbox", {obj=_G.BagItemSearchBox, si=true})
	_G.LiteBagBackpackPanelTokenFrame.Border:DisableDrawLayer("BACKGROUND")
	skinFrame("LiteBagBackpack")
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BagItemAutoSortButton}
	end

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
		-- add button borders to reagent bank items
		self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(fObj)
			for i = 1, fObj.size do
				self:addButtonBorder{obj=fObj["Item" .. i], ibt=true, reParent={fObj["Item" .. i].IconQuestTexture}}
				-- force quality border update
				_G.BankFrameItemButton_Update(fObj["Item" .. i])
			end

			self:Unhook(fObj, "OnShow")
		end)
	end

end
