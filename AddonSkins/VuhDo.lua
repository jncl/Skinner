local aName, aObj = ...
if not aObj:isAddonEnabled("VuhDo") then return end

function aObj:VuhDo()

	-- the Tooltip is really a frame
	self:addSkinFrame{obj=VuhDoTooltip}

	-- BuffWatch Frame
	self:addSkinFrame{obj=VuhDoBuffWatchMainFrame, kfs=true}
	
	-- change panel options
	for i = 1, 10 do
		-- setup options
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.R = self.bColour[1]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.G = self.bColour[2]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.B = self.bColour[3]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.O = self.bColour[4]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.useOpacity = true
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.useBackground = true
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.R = self.bbColour[1]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.G = self.bbColour[2]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.B = self.bbColour[3]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.O = self.bbColour[4]
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.edgeSize = self.Backdrop[1].edgeSize
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.insets = self.Backdrop[1].insets.left
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.file = self.Backdrop[1].edgeFile
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.useOpacity = true
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.useBackground = true
		VUHDO_PANEL_SETUP[i].PANEL_COLOR.barTexture = self.db.profile.StatusBar.texture
		-- redraw panel
		VUHDO_redrawPanel(i)
		-- add Gradient
		self:applyGradient(VUHDO_getActionPanel(i))
	end

end

function aObj:VuhDoOptions()

	-- Yes/No Frame
	self:addSkinFrame{obj=VuhDoYesNoFrame, kfs=true}

	-- ReadyCheckFrame
	self:addSkinFrame{obj=VuhDoThreeSelectFrame, kfs=true}

end
