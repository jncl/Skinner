local aName, aObj = ...
if not aObj:isAddonEnabled("NPCScan") then return end
local _G = _G

aObj.addonsToSkin.NPCScan = function(self) -- v 7.3.5.3

	local function skinTargetButton(event, ...)
		-- aObj:Debug("skinTargetButton fired: [%s, %s]", event, ...)

		-- handle inCombat
		if _G.InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinTargetButton, {"OoC"}})
			return
		end

		-- if called after combat wait for queued Target button to be created
		if event == "OoC" then
			_G.C_Timer.After(0.1, function() skinTargetButton() end)
		end

		aObj.RegisterCallback("NPCScan", "UIParent_GetChildren", function(this, child)
			if child.DismissButton
			and child.killedTextureFrame
			then
				-- aObj:Debug("Target Button found: [%s, %s, %s]", child, child:GetWidth(), child:GetHeight())
				child:SetSize(276, 96)
				if not child.sf then
					child.Background:SetTexture(nil)
					child.Background.SetTexture = _G.nop
					if child.Background2 then
						child.Background2:SetTexture(nil)
						child.Background2.SetTexture = _G.nop
						child.Background3:SetTexture(nil)
						child.Background3.SetTexture = _G.nop
					end
				end
				child.DismissButton:GetNormalTexture():SetTexture(nil)
				child.DismissButton:GetPushedTexture():SetTexture(nil)
				aObj:skinCloseButton{obj=child.DismissButton, font=aObj.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
				aObj:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, sec=true, ofs=-8}
			end
		end)
		aObj:scanUIParentsChildren()

	end

	-- Register to know when Targeting buttons are used
	self:RegisterMessage("NPCScan_DetectedNPC", skinTargetButton)
	self:RegisterMessage("NPCScan_TargetButtonRequestDeactivate", skinTargetButton)

		-- skin the anchor frame
	local function skinAnchor(cbName, addonName)
		if addonName == "NPCScan" then
			aObj.RegisterCallback("NPCScan_Options", "UIParent_GetChildren", function(this, child)
				if child:GetName() == nil
				and _G.Round(child:GetWidth()) == 302
				and _G.Round(child:GetHeight()) == 61 -- N.B. NOT 119 as defined in code
				then
					aObj:skinCloseButton{obj=aObj:getChild(child, 1), font=aObj.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
					aObj:addSkinFrame{obj=child, ft="a", kfs=true, nb=true}
					aObj.UnregisterCallback("NPCScan_Options", "UIParent_GetChildren")
				end
			end)
			aObj:scanUIParentsChildren()
		end
	end

	-- Register to know when Show/Hide Anchor button pressed
	self.ACR.RegisterCallback(self, "ConfigTableChange", skinAnchor)

end
