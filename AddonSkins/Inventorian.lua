local _, aObj = ...
if not aObj:isAddonEnabled("Inventorian") then return end
local _G = _G

aObj.addonsToSkin.Inventorian = function(self) -- v 10.1.0.0

	local Inventorian = _G.LibStub("AceAddon-3.0"):GetAddon("Inventorian", true)

	local function skinBagBtns(fObj)
		for _, btn in _G.pairs(fObj.bagButtons) do
			aObj:addButtonBorder{obj=btn, clr="grey"}
		end
	end
	local function updBtn(btn)
		if btn.icon:GetTexture() == 4701874 then
			btn:SetItemButtonTexture("")
		end
		aObj:clrButtonFromBorder(btn)
	end
	local function skinBtns(icObj)
		for _, btn in _G.pairs(icObj.items) do
			aObj:addButtonBorder{obj=btn, ibt=true, clr="grey"}
			updBtn(btn)
			aObj:secureHook(btn, "Update", function(bObj) -- N.B. use reusable hook function here
				updBtn(bObj)
			end)
		end
	end
	local function skinFrame(frame)
		aObj:skinObject("editbox", {obj=frame.SearchBox, si=true})
		-- N.B. item is named incorrectly [$pargenBagToggle]
		local bt = aObj:getChild(frame, 11)
		bt.Border:SetTexture(nil)
		aObj:removeRegions(frame.Money.Border, {1, 2, 3})
		aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, rns=true, cb=true, ofs=2, x2=3, y2=-1})
		self:skinObject("tabs", {obj=frame, tabs=frame.tabs, lod=self.isTT and true})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.DepositButton, schk=true}
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.SortButton, schk=true, clr="grey"}
			aObj:addButtonBorder{obj=bt, relTo=bt.Icon, clr="grey"}
			skinBagBtns(frame)
			aObj:SecureHook(frame, "UpdateBags", function(this)
				skinBagBtns(this)
			end)
			aObj:SecureHook(frame.itemContainer, "GenerateItemButtons", function(icObj)
				skinBtns(icObj)
			end)
		end
	end
	for _, type in _G.pairs{"bag", "bank"} do
		skinFrame(Inventorian[type])
	end
	_G.BackpackTokenFrame.Border:DisableDrawLayer("BACKGROUND")

	if not _G.IsReagentBankUnlocked() then
		_G.ReagentBankFrameUnlockInfo:DisableDrawLayer("BORDER")
		if self.modBtns then
			self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton}
		end
	end

end
