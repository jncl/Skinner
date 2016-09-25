local aName, aObj = ...
if not aObj:isAddonEnabled("TomTom") then return end
local _G = _G

function aObj:TomTom()

	local function skinTTBlock()

		if _G.TomTomBlock and _G.TomTomBlock:IsShown() then
			_G.TomTomBlock:SetFrameStrata("LOW")
			aObj:applySkin(_G.TomTomBlock)
		end

	end

	self:SecureHook(_G.TomTom, "ShowHideCoordBlock", function() skinTTBlock() end)

	-- skin the Coordinate block
	skinTTBlock()

	if self.db.profile.Tooltips.skin then
		self:SecureHook(_G.TomTomTooltip, "Show", function(this)
			if self.db.profile.Tooltips.style == 3 then _G.TomTomTooltip:SetBackdrop(self.backdrop) end
			self:skinTooltip(_G.TomTomTooltip)
		end)
	end

end
