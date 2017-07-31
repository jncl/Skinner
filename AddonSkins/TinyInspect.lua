local aName, aObj = ...
if not aObj:isAddonEnabled("TinyInspect") then return end
local _G = _G

function aObj:TinyInspect()

	-- Inspect Frame & PaperDollFrame
	self:SecureHook("ShowInspectItemListFrame", function(unit, parent, itemLevel)
	    local frame = parent.inspectFrame

		-- if no frame or already skinned then do nothing
	    if not frame
		or frame.sf
		then
			return
		end

		frame.portrait.PortraitRing:SetTexture(nil)
		self:addSkinFrame{obj=frame, ofs=2, y2=-5}
		frame.SetBackdrop = _G.nop
		frame = nil

		-- check if both frames have been skinned
		if (InspectFrame and InspectFrame.inspectFrame)
		and PaperDollFrame.inspectFrame
		then
			self:Unhook("ShowInspectItemListFrame")
		end
	end)

	-- TinyInspectRaidFrame
	self:addSkinFrame{obj=_G.TinyInspectRaidFrame, kfs=true}
	self:addSkinFrame{obj=_G.TinyInspectRaidFrame.panel, kfs=true}

end
