local aName, aObj = ...
if not aObj:isAddonEnabled("Omen") then return end
local _G = _G

function aObj:Omen()

	local function skinOmen()

		_G.OmenTitle:SetHeight(20)
		aObj:applySkin(_G.OmenTitle)
		aObj:applySkin(_G.OmenBarList)

	end

	skinOmen()
	self:SecureHook(_G.Omen, "UpdateBackdrop", function() skinOmen() end)

end
