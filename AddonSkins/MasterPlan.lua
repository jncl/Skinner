local aName, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

function aObj:MasterPlan() -- LoD

	-- skin tab
	local tab = _G.GarrisonMissionFrameTab3
	self:keepRegions(tab, {7, 8, 9, 10})
	self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=9, y1=2, x2=-9, y2=0}
	self:setInactiveTab(tab.sf)
	_G.PanelTemplates_SetNumTabs(_G.GarrisonMissionFrame, 3)

	-- skin resized Border frame
	local bf = _G.GarrisonMissionFrameMissions.CompleteDialog.BorderFrame
	self:addSkinFrame{obj=bf, ft="u", kfs=true}

	-- skin sort indicator button
	local sib = self:getChild(_G.GarrisonMissionFrameMissions, _G.GarrisonMissionFrameMissions:GetNumChildren())
	self:removeRegions(sib, {1})

end
