
function Skinner:EditingUI()

	local kRegions = CopyTable(self.ebRegions)
	table.insert(kRegions, 9)

	local function skinEUIEB(frame)

		Skinner:keepRegions(frame, kRegions)

		local l, r, t, b = frame:GetTextInsets()
		frame:SetTextInsets(l + 5, r + 0, t, b)

		-- move the title to the right
		if Skinner:getRegion(frame, 9) then Skinner:moveObject(Skinner:getRegion(frame, 9), "+", 5, nil, nil) end
		if Skinner:getChild(frame, 1) then Skinner:moveObject(Skinner:getChild(frame, 1), "+", 5, nil, nil) end

		Skinner:skinUsingBD2(frame)

		frame:SetHeight(frame:GetHeight() + 3)

	end

-->>--	Toggle Button
	self:skinButton{obj=EditingFrameToggleButton, mp2=true, plus=true}
	self:moveObject{obj=EditingFrameToggleButton, y=-18}
	self:moveObject{obj=EditingFrame, y=-18, relTo=UIParent}

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
	self:skinButton{obj=EditingFrameReloadUI}
	self:skinButton{obj=EditingFrameCopyXML}
	self:skinButton{obj=EditingFrameCopyLua}

-->>--	Calculations Panel
	self:skinButton{obj=EditingFrameCalculationsBarCloseButton, cb=true}
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
	self:skinButton{obj=EditingFrameCopySetVertex}
	self:skinButton{obj=EditingFrameCopyRGB}
	self:skinButton{obj=EditingFrameCopyTCoordXML}
	self:skinButton{obj=EditingFrameCopySetTexCoord}

-->>--	Debug Panel
	self:skinButton{obj=EditingFrameDebugBarCloseButton, cb=true}
	self:applySkin(EditingFrameDebugBar)
	skinEUIEB(EditingFrameDebugPrint)
	self:skinButton{obj=EditingFrameDebugPrintButton}
	skinEUIEB(EditingFrameRunScript)
	self:skinButton{obj=EditingFrameRunScriptButton}

-->>--	Tab Panel
	self:skinButton{obj=CalculationPlusButton, mp2=true, plus=true}
	self:applySkin(ExpandCalculationButton)
	self:skinButton{obj=DebugPlusButton, mp2=true, plus=true}
	self:applySkin(ExpandDebugButton)

end
