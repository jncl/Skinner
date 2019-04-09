local aName, aObj = ...
if not aObj:isAddonEnabled("AdiBags") then return end
local _G = _G

aObj.addonsToSkin.AdiBags = function(self) -- v 1.9.15

	local aBag = _G.LibStub("AceAddon-3.0"):GetAddon("AdiBags", true)

	-- hook this for bag creation
	aBag:RegisterMessage("AdiBags_BagFrameCreated", function(msg, bag)
		local frame = bag:GetFrame()
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
		if aObj.modBtns then
			aObj:skinCloseButton{obj=frame.CloseButton}
			for _, object in _G.pairs(frame.HeaderRightRegion.widgets) do
				if object.widget:IsObjectType("Button") then
					aObj:skinStdButton{obj=object.widget}
				end
			end
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.HeaderLeftRegion.widgets[1].widget, ofs=3} -- bag icon
		end
		aObj:skinEditBox{obj=_G[frame:GetName().."SearchBox"], regs={6}, mi=true}
		frame = nil
	end)

	-- hook this for equipped bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:addSkinFrame{obj=bPanel, ft="a", kfs=true, nb=true}
		if self.modBtnBs then
			for _, btn in _G.pairs(bPanel.buttons) do
				self:addButtonBorder{obj=btn}
			end
		end
		return bPanel
	end, true)

	if self.modBtnBs then
		-- colour the button border
		aBag:RegisterMessage("AdiBags_UpdateButton", function(evt, btn)
			if not btn.sbb then
				aObj:addButtonBorder{obj=btn}
			end
			if btn.IconQuestTexture:GetBlendMode() == "ADD" then
				btn.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				btn.sbb:SetBackdropBorderColor(btn.IconQuestTexture:GetVertexColor())
				btn.IconQuestTexture:Hide()
			else
				btn.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
				btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				btn.IconQuestTexture:Show()
			end
		end)
	end

end
