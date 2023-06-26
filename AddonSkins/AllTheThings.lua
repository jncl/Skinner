local _, aObj = ...
if not aObj:isAddonEnabled("AllTheThings")
and not aObj:isAddonEnabled("ATT-Classic")
then
	return
end
local _G = _G

local function skinThings(app, appName)

	local function skinFrame(frame)
		if appName == "ATT-Classic" then
			aObj:skinObject("scrollbar", {obj=frame.ScrollBar, x1=2, x2=4})
		else
			aObj:skinObject("slider", {obj=frame.ScrollBar})
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, cbns=true, ofs=0, x2=1, y2=-2})
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
	for _, frame in _G.pairs(app.Windows) do
		skinFrame(frame)
	end

	-- N.B. GameTooltipIcon object is not available ?, therefore cannot be skinned
	-- Tooltip Model frame
	aObj:skinObject("frame", {obj=_G.ATTGameTooltipModel, kfs=true})
	-- hook to align to GameTooltip
	aObj:RawHook(_G.ATTGameTooltipModel, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
		aObj.hooks[this].SetPoint(this, point, relTo, relPoint, xOfs, -2)
	end, true)

	-- minimap button
	if _G[appName .. "-Minimap"] then
		aObj.mmButs[appName] = _G[appName .. "-Minimap"]
		_G[appName .. "-Minimap"].texture:SetDrawLayer("OVERLAY") -- make logo appear
	end

	aObj.RegisterCallback("", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= appName then return end
		aObj.iofSkinnedPanels[panel] = true

		aObj:removeBackdrop(panel)
		aObj:skinObject("tabs", {obj=panel, tabs=panel.Tabs, ignoreSize=true, lod=true, offsets={x1=6, y1=0, x2=-6, y2=-4}})

		if appName ~= "ATT-Classic" then
			aObj:skinObject("slider", {obj=panel.ContainsSlider})
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=panel.SkipAutoRefreshCheckbox}
			end
		end
		aObj:skinObject("slider", {obj=panel.LocationsSlider})
		aObj:skinObject("slider", {obj=panel.MainListScaleSlider})
		aObj:skinObject("slider", {obj=panel.MiniListScaleSlider})
		aObj:skinObject("slider", {obj=panel.PrecisionSlider})
		aObj:skinObject("slider", {obj=panel.MinimapButtonSizeSlider})

		if aObj.modBtns then
			if appName == "ATT-Classic" then
				aObj:skinStdButton{obj=panel.curse}
				aObj:skinStdButton{obj=panel.discord}
			else
				aObj:skinStdButton{obj=panel.community}
				aObj:skinStdButton{obj=panel.patreon}
				aObj:skinStdButton{obj=panel.merch}
			end
			aObj:skinStdButton{obj=panel.twitch}
		end

		for i, tabPanel in _G.pairs(panel.Tabs) do
			for _, obj in _G.ipairs(tabPanel.objects) do
				if obj:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=obj, hf=true}
				elseif obj:IsObjectType("Button")
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=obj}
				end
			end
		end

		aObj.UnregisterCallback("", "IOFPanel_Before_Skinning")
	end)

end

aObj.addonsToSkin.AllTheThings = function(_) -- v DF-3.4.10

	skinThings(_G.AllTheThings, "AllTheThings")

end

aObj.addonsToSkin["ATT-Classic"] = function(_) -- v 1.5.1

	skinThings(_G.ATTC, "ATT-Classic")

end
