local aName, aObj = ...
if not aObj:isAddonEnabled("Scrap") then return end
local tab, tabSF

function aObj:Scrap_Merchant() -- LoD

	-- replace border if required
	if self.modBtnBs then
		self:getRegion(Scrap, 3):SetTexture(nil)
		self:addButtonBorder{obj=Scrap, ofs=0}
	end

	-- check to see if Visualizer addon is loaded
	-- if so then skin the additional tab
	if select(5, GetAddOnInfo("Scrap_Visualizer")) then
		tab = _G["MerchantFrameTab"..MerchantFrame.numTabs]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if self.isTT then self:setInactiveTab(tabSF) end
	end

end

function aObj:Scrap_Options() -- LoD

	local lib = LibStub("CustomTutorials-2.0", true)
	if not lib then return end

	-- skin existing frames
	for k, frame in pairs(lib.frames) do
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		frame.TitleText:SetDrawLayer("ARTWORK") -- move title text draw layer so it is shown
		frame.shine:SetBackdrop(nil)
		self:removeRegions(frame, {20})
		-- turn off the animation
		frame.flash:Stop()
		self:addSkinFrame{obj=frame, ri=true, ofs=2, x2=1}
	end

end

function aObj:Scrap_Visualizer() -- LoD

	self:skinSlider{obj=ScrapVisualizerScrollBar, size=3}
	self:addSkinFrame{obj=ScrapVisualizer, kfs=true, ri=true, noBdr=true}
	self:removeMagicBtnTex(ScrapVisualizer.button)

	-- Tabs
	for i = 1, ScrapVisualizer.numTabs do
		tab = _G["ScrapVisualizerTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:moveObject{obj=_G["ScrapVisualizerTab"..i.."HighlightTexture"], x=-2, y=4}
		tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, y1=-3, y2=-3}
		tabSF.ignore = true -- ignore size changes
		tabSF.up = true -- tabs grow upwards
		-- set textures here first time thru as it's LoD
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[ScrapVisualizer] = true

end
