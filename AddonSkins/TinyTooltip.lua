local aName, aObj = ...
if not aObj:isAddonEnabled("TinyTooltip") then return end
local _G = _G


function aObj:TinyTooltip()

	-- don't colour the tooltip border as this addon does
	aObj.ttBorder = false

	for k, ttip in pairs(TinyTooltip.tooltips) do
		-- skin the tooltip.style frame
		self:add2Table(self.ttList, ttip.style)
		-- stop tooltip flashing
		ttip.style.SetBackdropColor = _G.nop
		-- skin the close button, if required (DIY frame)
		if ttip.close then
			self:skinButton{obj=ttip.close, cb=true}
		end
		-- clear other subframe backdrops
		ttip.style.inside:SetBackdrop(nil)
		ttip.style.inside.SetBackdrop = _G.nop
		ttip.style.outside:SetBackdrop(nil)
		ttip.style.outside.SetBackdrop = _G.nop
		-- clear other textures
		ttip.style.mask:SetTexture(nil)
	end

end
