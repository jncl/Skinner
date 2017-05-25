local aName, aObj = ...
if not aObj:isAddonEnabled("ClassOrderHallsComplete") then return end
local _G = _G

-- minimap button
aObj.mmButs["ClassOrderHallsComplete"] = _G.COHCMinimapButton

function aObj:ClassOrderHallsComplete()

	-- resize minimap button if required
	if _G.CLASSORDERHALLSCOMPLETE_SAVEDVARIABLESPERCHARACTER.largeMinimapButton then
		_G.COHCMinimapButton:SetSize(44, 44)
	end
	-- hook this to manage size changes
	self:RawHook(_G.COHCMinimapButton, "SetSize", function(this, w, h)
		aObj:Debug("COHCMinimapButton SetSize: [%s, %s, %s]", this, w, h)
		if w == 54 then w, h = 44, 44 end
		self.hooks[this].SetSize(this, w, h)
	end, true)

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
	self:skinDropDown{obj=_G[mFrame .. "Tab3SubFrameAlertDropDownMenu"]}

	mFrame = nil

end
