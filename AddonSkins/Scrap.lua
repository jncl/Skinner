local aName, aObj = ...
if not aObj:isAddonEnabled("Scrap") then return end

function aObj:Scrap_Merchant() -- LoD

	-- replace border if required
	if self.modBtnBs then
		self:getRegion(Scrap, 3):SetTexture(nil)
		self:addButtonBorder{obj=Scrap}--, x1=-1, y1=1, x2=1, y2=-1}
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
