
function Skinner:epgp()

	local epgpUI = EPGP and EPGP:GetModule("ui", true)
	if not epgpUI then return end

	local function skinEPGPUI()
	
		Skinner:keepFontStrings(EPGPFrame)
		EPGPFrame:SetWidth(EPGPFrame:GetWidth() * Skinner.FxMult)
		EPGPFrame:SetHeight(EPGPFrame:GetHeight() * Skinner.FyMult)
		Skinner:moveObject(Skinner:getRegion(EPGPFrame, 6), nil, nil, "+", 10) -- title text
		Skinner:moveObject(Skinner:getChild(EPGPFrame, 1), "+", 33, "+", 9) -- close button
		Skinner:skinSlider(EPGPScrollFrameScrollBar)
		EPGPScrollFrameScrollBarBorder:SetAlpha(0)
		local sf = Skinner:getChild(EPGPFrame, 6) -- standings frame
		Skinner:moveObject(Skinner:getChild(sf, 1), "-", 10, "-", 8) -- mass EP award button
		Skinner:moveObject(Skinner:getChild(sf, 2), "-", 10, "-", 8) -- log button
		local tf = Skinner:getChild(sf, 4) -- table frame
		-- tabs
		for _, v in pairs(tf.headers) do
			Skinner:keepRegions(v, {5, 6}) -- N.B. regions 5 & 6 are highlight/text
			v:SetHeight(v:GetHeight() - 5)
			if i == 1 then Skinner:moveObject(v, nil, nil, "+", 20) end
			Skinner:applySkin(v)
		end
		Skinner:applySkin(EPGPFrame)
		
		-- Side Frame
		Skinner:moveObject(EPGPSideFrame, "+", 32, nil, nil)
		EPGPSideFrame:SetFrameLevel(EPGPSideFrame:GetFrameLevel() + 5)
		Skinner:keepFontStrings(EPGPSideFrame)
		Skinner:keepFontStrings(EPGPSideFrameGPControlDropDown)
		Skinner:skinEditBox(EPGPSideFrameGPControlEditBox, {9})
		Skinner:keepFontStrings(EPGPSideFrameEPControlDropDown)
		Skinner:skinEditBox(EPGPSideFrameEPControlOtherEditBox, {9})
		Skinner:skinEditBox(EPGPSideFrameEPControlEditBox, {9})
		Skinner:applySkin(EPGPSideFrame, true)
		-- Side Frame2
		Skinner:moveObject(EPGPSideFrame2, "+", 32, nil, nil)
		EPGPSideFrame2:SetFrameLevel(EPGPSideFrame2:GetFrameLevel() + 5)
		Skinner:keepFontStrings(EPGPSideFrame2)
		Skinner:keepFontStrings(EPGPSideFrame2EPControlDropDown)
		Skinner:skinEditBox(EPGPSideFrame2EPControlOtherEditBox, {9})
		Skinner:skinEditBox(EPGPSideFrame2EPControlEditBox, {9})
		Skinner:applySkin(EPGPSideFrame2)
		-- Log Frame
		Skinner:moveObject(EPGPLogFrame, "+", 36, nil, nil)
		EPGPLogFrame:SetFrameLevel(EPGPLogFrame:GetFrameLevel() + 5)
		Skinner:keepFontStrings(EPGPLogFrame)
		Skinner:applySkin(EPGPLogRecordScrollFrame:GetParent()) -- log info frame
		Skinner:applySkin(EPGPLogFrame)
		
	end
	
	if not EPGPFrame then
		self:SecureHook(epgpUI, "OnEnable", function()
			self:Debug("EPGP_UI_OnEnable")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	else
		self:SecureHook(EPGPFrame, "Show", function(this)
			self:Debug("EPGPFrame_Show")
			skinEPGPUI()
			self:Unhook(EPGPFrame, "Show")
		end)
	end
		
end
