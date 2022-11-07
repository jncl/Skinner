local _, aObj = ...
if not aObj:isAddonEnabled("Inventorian") then return end
local _G = _G

aObj.addonsToSkin.Inventorian = function(self) -- v 10.0.0.0

	local Inventorian = _G.LibStub("AceAddon-3.0"):GetAddon("Inventorian", true)

	local function skinFrame(frame)
		aObj:skinObject("editbox", {obj=frame.SearchBox, si=true})
		-- N.B. item is named incorrectly [$pargenBagToggle]
		local bt = aObj:getChild(frame, 11)
		bt.Border:SetTexture(nil)
		aObj:removeRegions(frame.Money.Border, {1, 2, 3})
		aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, rns=true, cb=true, ofs=2, x2=3})
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.SortButton}
			aObj:SecureHook(frame.SortButton, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(frame.SortButton, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:addButtonBorder{obj=bt, relTo=bt.Icon}
		end
	end

	skinFrame(Inventorian.bag)
	self:skinObject("tabs", {obj=Inventorian.bag, tabs=Inventorian.bag.tabs, lod=self.isTT and true})
	if self.modBtnBs then
		self:SecureHook(Inventorian.bag, "ShowFrame", function(this)
			for _, btn in _G.pairs(this.itemContainer.items) do
				self:addButtonBorder{obj=btn, ibt=true, reParent={_G[btn:GetName() .. "IconQuestTexture"]}, clr="grey"}
			end
		end)
	end

	skinFrame(Inventorian.bank)
	self:skinObject("tabs", {obj=Inventorian.bank, tabs=Inventorian.bank.tabs, lod=self.isTT and true})
	if self.modBtns then
		self:skinStdButton{obj=Inventorian.bank.DepositButton}
		self:SecureHook(Inventorian.bank.DepositButton, "Disable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:SecureHook(Inventorian.bank.DepositButton, "Enable", function(this, _)
			self:clrBtnBdr(this)
		end)
	end
	if self.modBtnBs then
		self:SecureHook(Inventorian.bank, "ShowFrame", function(this)
			for _, btn in _G.pairs(this.itemContainer.items) do
				self:addButtonBorder{obj=btn, ibt=true, reParent={_G[btn:GetName() .. "IconQuestTexture"]}, clr="grey"}
			end
		end)
	end
	if not _G.IsReagentBankUnlocked() then
		_G.ReagentBankFrameUnlockInfo:DisableDrawLayer("BORDER")
		if self.modBtns then
			self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton}
		end
	end

	-- TODO:
		-- skin bag buttons
		-- refresh items button borders after sort

end
