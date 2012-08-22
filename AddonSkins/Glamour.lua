local aName, aObj = ...
if not aObj:isAddonEnabled("Glamour") then return end

function aObj:Glamour()

	-- Anchor frame
	GlamourAnchorText1:SetTextColor(self.BTr, self.BTg, self.BTb)
	GlamourAnchorText2:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=GlamourAnchor, kfs=true, y1=6, y2=-6}

	-- hook this to skin Glamour Alert frames
	self:RawHook("GlamourShowAlert", function(...)
		local fName = self.hooks["GlamourShowAlert"](...)
		local obj = _G[fName]
		if obj and not self.skinFrame[obj] then
			_G[fName.."Background"]:SetTexture(nil)
			_G[fName.."Background"].SetTexture = function() end
			_G[fName.."Unlocked"]:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[fName.."IconBling"]:SetTexture(nil)
			_G[fName.."IconTextureBG"]:SetTexture(nil)
			_G[fName.."IconTextureBG"].SetTexture = function() end
			_G[fName.."IconOverlay"]:SetTexture(nil)
			self:addSkinFrame{obj=obj, ft=ftype, anim=true, y1=-12, x2=ceil(obj:GetWidth())==44 and 28 or 0, y2=12}
		end
		return fName
	end, true)

end
