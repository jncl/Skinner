local aName, aObj = ...
if not aObj:isAddonEnabled("RicoMiniMap") then return end

function aObj:RicoMiniMap()

	local function skinSquare()

		MinimapBorder:Hide()

		if not aObj.sBtn[Minimap] then
			aObj.minimapskin = aObj:addSkinButton(Minimap, Minimap)
			if not aObj.db.profile.Minimap.gloss then LowerFrameLevel(aObj.minimapskin) end
		else
			aObj.sBtn[Minimap]:Show()
		end

	end

	self:SecureHook(RicoMiniMap, "UpdateShape", function()
		if RicoMiniMap.db.profile.Shape == 2 then skinSquare()
		elseif self.sBtn[Minimap] then
			self.sBtn[Minimap]:Hide()
		end
	end)

	if RicoMiniMap.db.profile.Shape == 2 then skinSquare() end

	-- Coordinates Frame
	RicoMinimap_CoordinatesFrame.SetBackdropColor = function() end
	RicoMinimap_CoordinatesFrame.SetBackdropBorderColor = function() end
	self:addSkinFrame{obj=RicoMinimap_CoordinatesFrame}

	-- Buttons
	if self.modBtns then
		for _, v in pairs{"Minimap", "Quest", "Ticket", "Vehicle", "Durability"} do
			local obj = _G["rmm"..v.."Mover"]
			obj:DisableDrawLayer("BORDER")
			self:addSkinFrame{obj=obj}
		end
	end

end


