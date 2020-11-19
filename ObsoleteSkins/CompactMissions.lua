local aName, aObj = ...
if not aObj:isAddonEnabled("CompactMissions") then return end
local _G = _G

function aObj:CompactMissions() -- WIP

	local cma = _G.LibStub("AceAddon-3.0"):GetAddon("CompactMissionsAddon", true)
	if not cma then return end

	local ui = cma.frame
	self:applySkin{obj=ui.frame, kfs=true}
	self:skinButton{obj=self:getChild(ui.frame, 1), y1=1}
	self:applySkin{obj=self:getChild(ui.frame, 2)} -- status frame
	ui.titletext:SetPoint("TOP", ui.frame, "TOP", 0, -6)
	-- skin frame children
	for i = 1, #ui.children do
		if ui.children[i].content then -- InlineGroup
			self:applySkin{obj=ui.children[i].content:GetParent(), kfs=true}
		end
	end
	self:keepRegions(ui.followerscroll.scrollbar, {1})
	self:skinUsingBD{obj=ui.followerscroll.scrollbar}
	self:keepRegions(ui.missionscroll.scrollbar, {1})
	self:skinUsingBD{obj=ui.missionscroll.scrollbar}

end
