local aName, aObj = ...
if not aObj:isAddonEnabled("VuhDo") then return end
local _G = _G

function aObj:VuhDo()

	-- the Tooltip is really a frame
	self:addSkinFrame{obj=_G.VuhDoTooltip}

	-- BuffWatch Frame
	self:addSkinFrame{obj=_G.VuhDoBuffWatchMainFrame, kfs=true}
	
	-- change panel options
	for i = 1, 10 do
		-- setup options
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.R = self.bColour[1]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.G = self.bColour[2]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.B = self.bColour[3]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.O = self.bColour[4]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.useOpacity = true
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK.useBackground = true
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.R = self.bbColour[1]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.G = self.bbColour[2]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.B = self.bbColour[3]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.O = self.bbColour[4]
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.edgeSize = self.Backdrop[1].edgeSize
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.insets = self.Backdrop[1].insets.left
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.file = self.Backdrop[1].edgeFile
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.useOpacity = true
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER.useBackground = true
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.barTexture = self.db.profile.StatusBar.texture
		-- redraw panel
		_G.VUHDO_redrawPanel(i)
		-- add Gradient
		self:applyGradient(_G.VUHDO_getOrCreateActionPanel(i))
	end

end

function aObj:VuhDoOptions()

	-- Yes/No Frame
	self:addSkinFrame{obj=_G.VuhDoYesNoFrame, kfs=true}

	-- ReadyCheckFrame
	self:addSkinFrame{obj=_G.VuhDoThreeSelectFrame, kfs=true}

end
