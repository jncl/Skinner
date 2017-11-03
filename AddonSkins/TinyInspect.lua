local aName, aObj = ...
if not aObj:isAddonEnabled("TinyInspect") then return end
local _G = _G

aObj.addonsToSkin.TinyInspect = function(self) -- v 7.3.1

	-- Inspect Frame & PaperDollFrame
	self:SecureHook("ShowInspectItemListFrame", function(unit, parent, itemLevel)

		-- if no frame or already skinned then do nothing
	    if not parent.inspectFrame
		or parent.inspectFrame.sf
		then
			return
		end

		parent.inspectFrame.portrait.PortraitRing:SetTexture(nil)
		self:addSkinFrame{obj=parent.inspectFrame, ft="a", ofs=2, y2=-5}
		parent.inspectFrame.SetBackdrop = _G.nop

		-- check if both frames have been skinned
		if (_G.InspectFrame and _G.InspectFrame.inspectFrame)
		and _G.PaperDollFrame.inspectFrame
		then
			self:Unhook("ShowInspectItemListFrame")
		end
	end)

	-- TinyInspectRaidFrame
	self:addSkinFrame{obj=_G.TinyInspectRaidFrame, ft="a", kfs=true}
	self:addSkinFrame{obj=_G.TinyInspectRaidFrame.panel, ft="a", kfs=true}

	-- register callback to indicate already skinned
	self.RegisterCallback("TinyInspect", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "TinyInspect" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("TinyInspect", "IOFPanel_Before_Skinning")
	end)

	-- register callback to skin elements
	self.RegisterCallback("TinyInspect", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "TinyInspect" then return end

		local function skinKids(panel)

			for _, child in _G.ipairs{panel:GetChildren()} do
				if child:IsObjectType("CheckButton") then
					aObj:skinCheckButton{obj=child}
					aObj:Debug("CheckButton: [%s, %s]", child, child:GetNumChildren())
					if child:GetNumChildren() > 1 then
						skinKids(child)
					end
					if child.SubtypeFrame then
						aObj:addSkinFrame{obj=child.SubtypeFrame, ft="a"}
						skinKids(child.SubtypeFrame)
					end
				end
			end

		end

		skinKids(panel)

		self.UnregisterCallback("TinyInspect", "IOFPanel_After_Skinning")
	end)

end
