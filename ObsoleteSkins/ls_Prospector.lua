local aName, aObj = ...
if not aObj:isAddonEnabled("ls_Prospector") then return end
local _G = _G

function aObj:ls_Prospector()

	local frame = _G.LSProspectorFrame
	self:addSkinFrame{obj=frame, kfs=true, ofs=2, x2=1}

	self:addButtonBorder{obj=frame.MacroButton}
	self:removeRegions(frame.MacroButton, {2})

	self:skinButton{obj=frame.SwapButton}
	self:skinButton{obj=frame.ProspectButton}

	local inset = self:getChild(frame, 2)
	self:removeInset(inset)

	self:addButtonBorder{obj=inset, relTo=frame.OreIcon}
	-- hack to allow two button borders on the inset frame
	inset.sbb2 = inset.sbb
	inset.sbb = nil
	self:addButtonBorder{obj=inset, relTo=frame.ChipIcon}
	self:removeRegions(inset, {11, 13}) -- butoon borders

	frame, inset = nil, nil

end
