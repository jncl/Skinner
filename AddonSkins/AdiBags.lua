local _, aObj = ...
if not aObj:isAddonEnabled("AdiBags") then return end
local _G = _G

aObj.addonsToSkin.AdiBags = function(self) -- v1.10.15/v1.9.26-bcc/v1.9.20-classic

	local aBag = _G.LibStub("AceAddon-3.0"):GetAddon("AdiBags", true)

	-- hook this for bag creation
	aBag:RegisterMessage("AdiBags_BagFrameCreated", function(_, bag)
		aObj:skinObject("editbox", {obj=_G[bag.frame:GetName() .. "SearchBox"], si=true})
		aObj:skinObject("frame", {obj=bag.frame, kfs=true})
		if aObj.modBtns then
			aObj:skinStdButton{obj=bag.frame.CloseButton}
			-- delay to allow all buttons to be created
			_G.C_Timer.After(0.1, function()
				for _, object in _G.pairs(bag.frame.HeaderRightRegion.widgets) do
					if object.widget:IsObjectType("Button") then
						aObj:skinStdButton{obj=object.widget}
					end
				end
			end)
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=bag.frame.HeaderLeftRegion.widgets[1].widget, ofs=3} -- bag icon
		end
	end)

	-- hook this for equipped bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:skinObject("frame", {obj=bPanel, kfs=true})
		if self.modBtnBs then
			for _, btn in _G.pairs(bPanel.buttons) do
				self:addButtonBorder{obj=btn, ibt=true}
			end
			-- TODO: colour bank bags red when not purchased
		end
		return bPanel
	end, true)

	if self.modBtnBs then
		-- enable qualityHighlight
		aBag.db.profile.qualityHighlight = true
		-- colour the button border
		local function clrBB(btn)
			-- handle in combat
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {clrBB, {btn}})
			    return
			end
			if not btn.sbb then
				aObj:addButtonBorder{obj=btn, ibt=true}
			end
			btn.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
			aObj:clrBtnBdr(btn.sbb, "grey")
			if btn.IconQuestTexture:IsVisible()
			and btn.IconQuestTexture:GetBlendMode() == "ADD"
			then
				btn.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				btn.sbb:SetBackdropBorderColor(btn.IconQuestTexture:GetVertexColor())
			end
			btn.IconQuestTexture:SetTexture(nil)
		end
		aBag:RegisterMessage("AdiBags_UpdateButton", function(_, btn)
			clrBB(btn)
		end)
		aBag:RegisterMessage("AdiBags_UpdateBorder", function(_, btn)
			clrBB(btn)
		end)
	end

end
