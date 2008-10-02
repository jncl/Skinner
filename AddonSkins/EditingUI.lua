
function Skinner:EditingUI()

	local kRegions = CopyTable(self.ebRegions)
	table.insert(kRegions, 9)

	local function skinEUIEB(frame)

		Skinner:keepRegions(frame, kRegions)

		local l, r, t, b = frame:GetTextInsets()
		frame:SetTextInsets(l + 5, r + 0, t, b)

		-- move the title to the right
		if Skinner:getRegion(frame, 9) then Skinner:moveObject(self:getRegion(frame, 9), "+", 5, nil, nil) end
		if Skinner:getChild(frame, 1) then Skinner:moveObject(self:getChild(frame, 1), "+", 5, nil, nil) end

		Skinner:skinUsingBD2(frame)

	end

-->>--	Toggle Button
	if FuBarFrame1 then
		self:moveObject(EditingFrameToggleButton, nil, nil, "-", 30)
		self:moveObject(EditingFrameTitleBar, nil, nil, "-", 30)
	end

-->>--	Title Panel
	self:applySkin(EditingFrameTitleBar)
	skinEUIEB(EditingEditBox)

-->>--	Navigation Panel
	self:applySkin(EditingBoxNavigationFrame)
	self:keepFontStrings(EditingFrameParentScrollFrame)
	self:skinScrollBar(EditingFrameParentScrollFrame)
	EditFrameParentHighlight:SetAlpha(1)
	self:keepFontStrings(EditingFrameChildScrollFrame)
	self:skinScrollBar(EditingFrameChildScrollFrame)
	EditFrameChildHighlight:SetAlpha(1)

-->>--	Anchor Panel
	self:applySkin(EditingFrameAnchorBar)
	self:moveObject(EditingEditAnchorPoint, "-", 8, nil, nil)
	skinEUIEB(EditingEditAnchorPoint)
	skinEUIEB(EditingEditRelativeTo)
	skinEUIEB(EditingEditRelativePoint)
	self:moveObject(EditingEditX, "-", 5, nil, nil)
	EditingEditX:SetWidth(40)
	skinEUIEB(EditingEditX)
	self:moveObject(EditingEditY, "-", 5, nil, nil)
	EditingEditY:SetWidth(40)
	skinEUIEB(EditingEditY)
	skinEUIEB(EditingEditWidth)
	skinEUIEB(EditingEditHeight)
	skinEUIEB(EditingFrameClipboard)

-->>--	Calculations Panel
	self:applySkin(EditingFrameCalculationsBar)
	skinEUIEB(EditingFrameR)
	skinEUIEB(EditingFrameG)
	skinEUIEB(EditingFrameB)
	skinEUIEB(EditingFrameTCoordWidth)
	skinEUIEB(EditingFrameTCoordHeight)
	skinEUIEB(EditingFrameTCoordLeft)
	skinEUIEB(EditingFrameTCoordRight)
	skinEUIEB(EditingFrameTCoordTop)
	skinEUIEB(EditingFrameTCoordBottom)

-->>--	Debug Panel
	self:applySkin(EditingFrameDebugBar)
	skinEUIEB(EditingFrameDebugPrint)
	skinEUIEB(EditingFrameRunScript)

-->>--	Tab Panel
	self:applySkin(ExpandCalculationButton)
	self:applySkin(ExpandDebugButton)

end
