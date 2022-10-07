local aName, aObj = ...
if not aObj:isAddonEnabled("NPCScan") then return end
local _G = _G

aObj.addonsToSkin.NPCScan = function(self) -- v 9.0.1.3

	local function skinTargetButton(event, ...)
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
			and not child.sf
			then
				aObj:nilTexture(child.Background, true)
				if child.Background2 then
					aObj:nilTexture(child.Background2, true)
					aObj:nilTexture(child.Background3, true)
				end
				local xOfs, yOfs
				if _G.Round(child:GetHeight()) == 119 then -- Elite/RareElite
					xOfs = 38
					yOfs = 18
				elseif _G.Round(child:GetHeight()) == 96 then -- Rare
					xOfs = 8
					yOfs = 10
				else -- Normal
					xOfs = 10
					yOfs = 9
				end
				aObj:skinObject("frame", {obj=child, kfs=true, sec=true, x1=xOfs, y1=-yOfs, x2=-9, y2=yOfs})
				if aObj.modBtns then
					aObj:skinCloseButton{obj=child.DismissButton, font=aObj.fontSBX, noSkin=true}
				end
				xOfs, yOfs = nil, nil
			end
		end)
		aObj:scanUIParentsChildren()
	end

		-- skin the anchor frame
	local function skinAnchor(cbName, addonName)
		if addonName == "NPCScan" then
			aObj.RegisterCallback("NPCScan_Options", "UIParent_GetChildren", function(this, child)
				if child:GetName() == nil
				and _G.Round(child:GetWidth()) == 302
				and _G.Round(child:GetHeight()) == 61 -- N.B. NOT 119 as defined in code
				then
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=0})
					if aObj.modBtns then
						aObj:skinCloseButton{obj=aObj:getChild(child, 1), font=aObj.fontSBX, noSkin=true}
					end
					aObj.UnregisterCallback("NPCScan_Options", "UIParent_GetChildren")
				end
			end)
			aObj:scanUIParentsChildren()
		end
	end

	-- Register to know when Show/Hide Anchor button pressed
	self.ACR.RegisterCallback(aName, "ConfigTableChange", skinAnchor)

end
