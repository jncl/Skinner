local aName, aObj = ...
if not aObj:isAddonEnabled("Glamour") then return end
local _G = _G

function aObj:Glamour()

	-- Anchor frame
	_G.GlamourAnchorText1:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.GlamourAnchorText2:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.GlamourAnchor, kfs=true, y1=6, y2=-6}

	-- hook this to skin Glamour Alert frames
	self:RawHook("GlamourShowAlert", function(...)
		local fName = self.hooks["GlamourShowAlert"](...)
		local obj = _G[fName]
		if obj and not obj.sknd then
			_G[fName.."Background"]:SetTexture(nil)
			_G[fName.."Background"].SetTexture = function() end
			_G[fName.."Unlocked"]:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[fName.."IconBling"]:SetTexture(nil)
			_G[fName.."IconTextureBG"]:SetTexture(nil)
			_G[fName.."IconTextureBG"].SetTexture = function() end
			_G[fName.."IconOverlay"]:SetTexture(nil)
			self:addSkinFrame{obj=obj, anim=true, y1=-12, x2=_G.ceil(obj:GetWidth()) == 44 and 28 or 0, y2=12}
		end
		return fName
	end, true)

end
