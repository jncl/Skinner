local aName, aObj = ...
if not aObj:isAddonEnabled("AdiBags") then return end
local _G = _G

aObj.addonsToSkin.AdiBags = function(self) -- v1.9.17/v1.9.17-classic

	local aBag = _G.LibStub("AceAddon-3.0"):GetAddon("AdiBags", true)

	local function skinBag(bag)
		local frame = bag:GetFrame()
		aObj:skinEditBox{obj=_G[frame:GetName() .. "SearchBox"], regs={6}, mi=true}
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
		if aObj.modBtns then
			aObj:skinCloseButton{obj=frame.CloseButton}
			-- delay to allow all buttons to be created
			_G.C_Timer.After(0.1, function()
				for _, object in _G.pairs(frame.HeaderRightRegion.widgets) do
					if object.widget:IsObjectType("Button") then
						aObj:skinStdButton{obj=object.widget}
					end
				end
				frame = nil
			end)
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.HeaderLeftRegion.widgets[1].widget, ofs=3} -- bag icon
		end

	end
	-- hook this for bag creation
	aBag:RegisterMessage("AdiBags_BagFrameCreated", function(msg, bag)
		-- print("AdiBags_BagFrameCreated", bag)
		skinBag(bag)
	end)

	-- hook this for equipped bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:addSkinFrame{obj=bPanel, ft="a", kfs=true, nb=true}
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
		aBag:RegisterMessage("AdiBags_UpdateButton", function(evt, btn)
			if not btn.sbb then
				aObj:addButtonBorder{obj=btn, ibt=true}
			end
			if btn.IconQuestTexture:GetBlendMode() == "ADD" then
				btn.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				btn.IconQuestTexture:Hide()
			else
				btn.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
				btn.IconQuestTexture:Show()
			end
			btn.sbb:SetBackdropBorderColor(btn.IconQuestTexture:GetVertexColor())
		end)
	end

end
