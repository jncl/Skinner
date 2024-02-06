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

	aObj:skinObject("frame", {obj=_G.ATTGameTooltipModel1:GetParent(), kfs=true, ofs=0})

	-- minimap button
	if _G[appName .. "-Minimap"] then
		aObj.mmButs[appName] = _G[appName .. "-Minimap"]
		_G[appName .. "-Minimap"].texture:SetDrawLayer("OVERLAY") -- make logo appear
	end

	aObj.RegisterCallback("AllTheThings", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= appName then
			return
		end
		aObj.iofSkinnedPanels[panel] = true

		local function skinObjects(frame)
			for _, obj in _G.pairs(frame.Objects) do
				if obj:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=obj})
				elseif obj:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=obj})
				elseif obj:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=obj}
				elseif obj:IsObjectType("Button")
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=obj, schk=true}
				elseif obj:IsObjectType("Frame") then
					if obj.ScrollContainer then
						aObj:skinObject("frame", {obj=obj.ScrollContainer, kfs=true, fb=true, y1=8})
						if aObj.modChkBtns then
							aObj:RawHook(obj, "CreateCheckBoxWithCount", function(this, ...)
								local cBox = aObj.hooks[this].CreateCheckBoxWithCount(this, ...)
								aObj:skinCheckButton{obj=cBox}
								return cBox
							end, true)
						end
					end
					if obj.Objects then
						skinObjects(obj)
					end
				end
			end
		end
		skinObjects(panel)
		aObj:skinObject("dropdown", {obj=_G.dropdownSoundpack})

		aObj.UnregisterCallback("AllTheThings", "IOFPanel_Before_Skinning")
	end)

end

aObj.addonsToSkin.AllTheThings = function(_) -- v DF-3.9.4a

	skinThings(_G.AllTheThings, "AllTheThings")

end

aObj.addonsToSkin["ATT-Classic"] = function(_) -- v 1.5.1

	skinThings(_G.ATTC, "ATT-Classic")

end
