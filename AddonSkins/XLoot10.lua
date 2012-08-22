local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot1.0") then return end

function aObj:XLoot10()

	-- determine current XLoot profile
	local pKey = ('%s - %s'):format(UnitName('player'), GetRealmName())
	local cKey = XLoot_Options.characters[pKey] or "default"
	local qcl = XLoot_Options.profiles[cKey].quality_color_loot
	local lc = XLoot_Options.profiles[cKey].loot_color_border

	local lootCnt, btn, item
	local function skinLootRow()

		-- skin first time thru
		if not aObj.skinFrame[XLootFrame] then
			aObj:addSkinFrame{obj=XLootFrame, kfs=true}
		end

		lootCnt = GetNumLootItems()

		if lootCnt > 0 then
			for i = 1, lootCnt do
				btn = _G["XLootButton"..i]
				if btn then -- handle missing button
					item = btn.frame_item
					if not btn.sf then
						btn.sf = aObj:addSkinFrame{obj=btn, kfs=true}
						item.sf = aObj:addSkinFrame{obj=item, kfs=true, ofs=1}
						LowerFrameLevel(item.sf) -- allow icon Texture to be displayed
						-- set default colour if required
						if qcl then
							btn.sf:SetBackdropBorderColor(lc[1], lc[2], lc[3], 1)
							item.sf:SetBackdropBorderColor(lc[1], lc[2], lc[3], 1)
							-- hook this to change border colours
							aObj:RawHook(btn, "SetBorderColor", function(this, r, g, b, a)
								if not r then r, g, b = unpack(lc) end
								this.sf:SetBackdropBorderColor(r, g, b, 1)
								this.frame_item.sf:SetBackdropBorderColor(r, g, b, 1)
							end, true)
						end
					end
				end
			end
		end

	end
	-- monitor Loot open event to skin the loot rows
	self:RegisterEvent("LOOT_OPENED", skinLootRow)

end
