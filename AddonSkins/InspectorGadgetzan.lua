local aName, aObj = ...
if not aObj:isAddonEnabled("InspectorGadgetzan") then return end
local _G = _G

function aObj:InspectorGadgetzan()

	self:SecureHook(_G.InspectorGadgetzan, "INSPECT_READY", function(this, ...)
		-- skin InspectFrameTab5
		local tab = _G.InspectFrameTab5
		self:rmRegionsTex(tab, {1, 2, 3 ,4 ,5 ,6})
		self:addSkinFrame{obj=tab, noBdr=aObj.isTT, x1=6, y1=0, x2=-5, y2=2}
		if _G.InspectFrame.selectedTab == id then
			self:setActiveTab(tab.sf)
		else
			self:setInactiveTab(tab.sf)
		end
		self.tabFrames[tab] = true
		self:Unhook(_G.InspectorGadgetzan, "INSPECT_READY")
	end)

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.InspectorGadgetzanWardrobeMountMicroButton, ofs=0, y1=-21}
		self:skinButton{obj=_G.InspectorGadgetzanWardrobeItemsFrame.ViewButton}
	end
	-- remove slot/text textures
	local slot, text
	for _, v in pairs{"Head", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "MainHand", "SecondaryHand"} do
		slot = _G["InspectorGadgetzanWardrobe" .. v .. "Slot"]
		slot:DisableDrawLayer("BACKGROUND")
		text = _G["InspectorGadgetzanWardrobe" .. v .. "Text"]
		text:DisableDrawLayer("BACKGROUND")
		text:GetDisabledTexture():SetTexture(nil)
		text:GetNormalTexture():SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=slot, ibt=true}
		end
	end
	slot, text = nil, nil
	_G.UIDropDownMenu_SetButtonWidth(DropDownMenuTryOn, 24)
	self:skinDropDown{obj=_G.DropDownMenuTryOn}

end
