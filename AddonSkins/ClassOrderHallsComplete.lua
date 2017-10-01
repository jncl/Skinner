local aName, aObj = ...
if not aObj:isAddonEnabled("ClassOrderHallsComplete") then return end
local _G = _G

aObj.addonsToSkin.ClassOrderHallsComplete = function(self) -- v1.27

	local mFrame = "ClassOrderHallsCompleteUIMainFrame"

	-- Main frame
	self:addSkinFrame{obj=_G[mFrame], kfs=true, ri=true, ofs=2, x2=1}
	-- Tabs
	self:skinTabs{obj=_G[mFrame .. "SubFrameHeader"], regs={}, up=true, x1=2, y1=-4, x2=-2, y2=-4}

	-- Tab1 SubFrame
	self:removeRegions(_G[mFrame .. "Tab1SubFrameNameColumnHeaderButton"], {1, 2, 3})
	self:addSkinFrame{obj=_G[mFrame .. "Tab1SubFrameNameColumnHeaderButton"], y1=2, y2=-2}
	self:removeRegions(_G[mFrame .. "Tab1SubFrameButtonsColumnHeaderButton"], {1, 2, 3})
	self:addSkinFrame{obj=_G[mFrame .. "Tab1SubFrameButtonsColumnHeaderButton"], y1=2, y2=-2}
	self:skinSlider{obj=_G[mFrame .. "Tab1SubFrameScrollFrame"].ScrollBar, rt="ARTWORK"}
	_G[mFrame .. "Tab1SubFrameFooterBG"]:SetTexture(nil)

	-- Tab2 SubFrame
	self:skinDropDown{obj=_G[mFrame .. "Tab2SubFrameCharacterDropDownMenu"]}
	self:skinSlider{obj=_G[mFrame .. "Tab2SubFrameScrollFrame"].ScrollBar, rt="ARTWORK"}

	-- Tab3 SubFrame
	self:skinDropDown{obj=_G[mFrame .. "Tab3SubFrameMonitorRowsDropDownMenu"]}
	self:skinDropDown{obj=_G[mFrame .. "Tab3SubFrameMonitorColumnsDropDownMenu"]}

	-- Tab4 SubFrame
	self:skinDropDown{obj=_G[mFrame .. "Tab4SubFrameAlertDropDownMenu"]}

	-- Tab5 SubFrame
	self:skinDropDown{obj=_G[mFrame .. "Tab5SubFrameSourceDropDownMenu"]}
	self:skinDropDown{obj=_G[mFrame .. "Tab5SubFrameTextFormatDropDownMenu"]}

	mFrame = nil

	-- minimap button
	self.mmButs["ClassOrderHallsComplete"] = _G.COHCMinimapButton

end
