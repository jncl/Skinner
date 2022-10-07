local _, aObj = ...
if not aObj:isAddonEnabled("AllTheThings")
and not aObj:isAddonEnabled("ATT-Classic")
then
	return
end
local _G = _G

local function skinThings(app, oName)
	local function skinFrame(frame)
		aObj:skinObject("slider", {obj=frame.ScrollBar, x1=0, x2=-1})
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0, x2=1, y2=-2})
	end
	-- hook this to skin new frames
	aObj:RawHook(app, "GetWindow", function(this, suffix, ...)
		local frame = aObj.hooks[this].GetWindow(this, suffix, ...)
		if not frame.sf then
			skinFrame(frame)
		end
		return frame
	end, true)
	-- skin existing frames
	aObj.RegisterCallback(oName, "UIParent_GetChildren", function(_, child)
		if child.Suffix
		and child.Toggle
		and child.Update
		and child.SetVisible
		then
			skinFrame(child)
		end
	end)
	aObj:scanUIParentsChildren()
	-- N.B. GameTooltipIcon object is not available ?, therefore cannot be skinned
	-- Tooltip Model frame
	aObj:skinObject("frame", {obj=_G.ATTGameTooltipModel, kfs=true})
	-- hook to align to GameTooltip
	aObj:RawHook(_G.ATTGameTooltipModel, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
		aObj.hooks[this].SetPoint(this, point, relTo, relPoint, xOfs, -2)
	end, true)
	-- minimap button
	if _G[oName .. "-Minimap"] then
		aObj.mmButs[oName] = _G[oName .. "-Minimap"]
		aObj:getRegion(_G[oName .. "-Minimap"], 2):SetDrawLayer("OVERLAY") -- make logo appear
	end
	-- Settings Panels
	aObj.RegisterCallback(oName, "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= oName then return end

		for _, btn in _G.pairs(panel.Tabs) do
			aObj.iofBtn[btn] = true
		end

		aObj.UnregisterCallback(oName, "IOFPanel_Before_Skinning")
	end)
	aObj.RegisterCallback(oName, "IOFPanel_After_Skinning", function(_, panel)
		if panel.name ~= oName then return end

		aObj:removeBackdrop(panel)
		aObj:getRegion(panel, 4):SetTexture(nil) -- Separator line

		aObj:skinObject("tabs", {obj=panel, tabs=panel.Tabs, ignoreSize=true, lod=true, offsets={x1=6, y1=0, x2=-6, y2=-4}})

		for i, tabPanel in _G.pairs(panel.Tabs) do
			if i == 3 then -- Unobtainables Tab
				for _, obj in _G.ipairs(tabPanel.objects) do
					if obj:IsObjectType("Frame")
					and obj:GetWidth() == 600
					and _G.Round(obj:GetHeight()) == 2500
					then -- child frame
						for _, child in _G.ipairs{obj:GetChildren()} do
							if child:GetObjectType() == "Frame" then
								aObj:skinObject("frame", {obj=child, kfs=true, fb=true})
							end
						end
					elseif obj:IsObjectType("CheckButton")
					and aObj.modChkBtns
					then
						aObj:skinCheckButton{obj=obj, hf=true}
					end
				end
			end
		end

		aObj.UnregisterCallback(oName, "IOFPanel_After_Skinning")
	end)
end

aObj.addonsToSkin.AllTheThings = function(_) -- v 2.1.2

	skinThings(_G.AllTheThings, "AllTheThings")

end

aObj.addonsToSkin["ATT-Classic"] = function(_) -- v 0.7.5

	skinThings(_G.ATTC, "ATT-Classic")

end
