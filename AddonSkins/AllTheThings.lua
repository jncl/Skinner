local _, aObj = ...
if not aObj:isAddonEnabled("AllTheThings") then
	return
end
local _G = _G

aObj.addonsToSkin.AllTheThings = function(_) -- v 5.2.13

	local function skinFrame(frame)
		aObj:skinObject("slider", {obj=frame.ScrollBar})
		aObj:removeNineSlice(frame)
		aObj:skinObject("frame", {obj=frame, rb=true, cb=true, ofs=0})
		if aObj.modBtns then
			frame.CloseButton:SetSize(24, 24)
		end
	end
	-- hook this to skin new frames
	aObj:RawHook(_G.AllTheThings, "GetWindow", function(this, suffix, passive)
		local frame = aObj.hooks[this].GetWindow(this, suffix, passive)
		_G.RunNextFrame(function()
			if frame
			and not frame.sf then
				skinFrame(frame)
			end
		end)
		return frame
	end, true)
	-- skin existing frames
	for _, frame in _G.pairs(_G.AllTheThings.Windows) do
		skinFrame(frame)
	end

	aObj:skinObject("frame", {obj=_G.ATTGameTooltipModel1:GetParent(), kfs=true, ofs=0})

	-- minimap button
	if _G["AllTheThings-Minimap"] then
		aObj.mmButs["AllTheThings"] = _G["AllTheThings-Minimap"]
		_G["AllTheThings-Minimap"].texture:SetDrawLayer("OVERLAY") -- make logo appear
	end

	local pName
	aObj.RegisterCallback("AllTheThings", "SettingsPanel_DisplayCategory", function(_, panel)
		pName = panel:GetName() or ""
		if not pName:find("AllTheThings")
		or aObj.spSkinnedPanels[panel]
		then
			return
		end
		aObj.spSkinnedPanels[panel] = true

		local x1Ofs, x2Ofs
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
						-- FIXME: this handles Classic ScrollBar having a zero width
						if aObj.isClsc then
							x1Ofs, x2Ofs = 2, 15
						end
						aObj:skinObject("scrollbar", {obj=obj.ScrollContainer.ScrollBar, x1=x1Ofs, x2=x2Ofs})
						aObj:skinObject("frame", {obj=obj.ScrollContainer, kfs=true, fb=true, ofs=0})
						if aObj.modChkBtns then
							local cBox
							aObj:RawHook(obj, "CreateCheckBoxWithCount", function(fObj, ...)
								cBox = aObj.hooks[fObj].CreateCheckBoxWithCount(fObj, ...)
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
		-- handle outliers
		if pName:find("General") then
			aObj:skinObject("ddbutton", {obj=aObj:getChild(panel, 2), noSF=true, bx1=-1, by1=0, bx2=0, by2=0})
		elseif pName:find("Audio") then
			aObj:skinObject("dropdown", {obj=_G.dropdownSoundpack})
		elseif pName:find("Windows")
		or pName:find("Style")
		then
			for _, child in _G.ipairs_reverse{panel:GetChildren()} do
				if child:IsObjectType("Button")
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=child}
				end
			end
		end

	end)

end
