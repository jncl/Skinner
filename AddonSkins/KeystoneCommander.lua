local aName, aObj = ...
if not aObj:isAddonEnabled("KeystoneCommander") then return end
local _G = _G

function aObj:KeystoneCommander()

	self:addButtonBorder{obj=_G.KC_Button, ofs=0, y2=2}

	self:addButtonBorder{obj=_G.KC_RefreshButton, ofs=-1}
	self:addButtonBorder{obj=_G.KC_AP_Button,ofs=-1}
	self:addSkinFrame{obj=_G.KC_Frame}
	self:addSkinFrame{obj=_G.KC_BG, kfs=true, ofs=2, x1=-4, x2=1, y2=-5}

	-- N.B. The following code is to handle the fact that the original function recreates the frame objects each time it is run

	-- values from here: http://wow.gamepedia.com/Artifact_Knowledge (Ranks)
	local AKPercentage = {
		-- [0] = .0, [1] = .25, [2] = .5, [3] = .9 -- (what I think they should be)
		[0] = 1, [1] = 1, [2] = 1.5, [3] = 1.9, [4] = 1.4, [5] = 2, [6] = 2.75, [7] = 3.75, [8] = 5, [9] = 6.5, [10] = 8.5,
		[11] = 11, [12] = 14, [13] = 17.75, [14] = 22.5, [15] = 28.5, [16] = 36, [17] = 45.5, [18] = 57, [19] = 72, [20] = 90, [21] = 113, [22] = 142, [23] = 178, [24] = 223, [25] = 250, [26] = 1001, [27] = 1301, [28] = 1701, [29] = 2201, [30] = 2901, [31] = 3801, [32] = 4901, [33] = 6401, [34] = 8301, [35] = 10801,[36] = 14001, [37] = 18201, [38] = 23701, [39] = 30801, [40] = 40001, [41] = 52001, [42] = 67601, [43] = 87901, [44] = 114301, [45] = 148601, [46] = 193201, [47] = 251201, [48] = 326601, [49] = 424601, [50] = 552001
	}
	local baseDungeonAp = {
		["lesser"] = { low = 175, middle = 290, high = 325, cap = 465},
		["regular"] = { low = 300, middle = 475, high = 540, cap = 775},
		["greater"] = { low = 375, middle = 600, high = 675, cap = 1000},
	}
	local AKPer
	self:RawHook("KC_Info_OnShow", function()

		if not _G.KC_AP_Frame then
			self.hooks["KC_Info_OnShow"]()
			_G.LC_Lesser_Cat.Background:SetTexture(nil)
			_G.LC_Regular_Cat.Background:SetTexture(nil)
			_G.LC_Greater_Cat.Background:SetTexture(nil)
			_G.LC_Gear_Cat.Background:SetTexture(nil)
			self:addSkinFrame{obj=_G.KC_AP_Frame, kfs=true, ofs=2, x1=-4}
		else
			-- just refresh values
			if not _G.KC_AP_Frame:IsVisible() then
				AKPer = _G.select(2, _G.GetCurrencyInfo(1171))
				_G.LC_Lesser_1.Label:SetText("2-3: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.lesser.low * AKPercentage[AKPer] ))
				_G.LC_Lesser_1.Label2:SetText("4-6: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.lesser.middle * AKPercentage[AKPer] ))
				_G.LC_Lesser_2.Label:SetText("7-9: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.lesser.high * AKPercentage[AKPer] ))
				_G.LC_Lesser_2.Label2:SetText("10+: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.lesser.cap * AKPercentage[AKPer] ))
				_G.LC_Regular_1.Label:SetText("2-3: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.regular.low * AKPercentage[AKPer] ))
				_G.LC_Regular_1.Label2:SetText("4-6: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.regular.middle * AKPercentage[AKPer] ))
				_G.LC_Regular_2.Label:SetText("7-9: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.regular.high * AKPercentage[AKPer] ))
				_G.LC_Regular_2.Label2:SetText("10+: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.regular.cap * AKPercentage[AKPer] ))
				_G.LC_Greater_1.Label:SetText("2-3: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.greater.low * AKPercentage[AKPer] ))
				_G.LC_Greater_1.Label2:SetText("4-6: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.greater.middle * AKPercentage[AKPer] ))
				_G.LC_Greater_2.Label:SetText("7-9: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.greater.high * AKPercentage[AKPer] ))
				_G.LC_Greater_2.Label2:SetText("10+: " .. "|cFFFFFFFF" .. comma_value(baseDungeonAp.greater.cap * AKPercentage[AKPer] ))
			end
		end

	end, true)

end
