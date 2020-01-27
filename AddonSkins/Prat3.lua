local aName, aObj = ...
if not aObj:isAddonEnabled("Prat-3.0") then return end
local _G = _G

aObj.addonsToSkin["Prat-3.0"] = function(self) -- v 3.7.47

	local eb = _G.LibStub("AceAddon-3.0"):GetAddon("Prat"):GetModule("Editbox", true)

	if eb then
		local prof = eb.db.profile

		if self.prdb.ChatEditBox.skin then
			local dflts = self.db.defaults.profile
			if self.prdb.BdDefault then
				prof.background = dflts.BdTexture
				prof.border = dflts.BdBorderTexture
			else
				if self.prdb.BdFile and self.prdb.BdFile ~= "None" then
					prof.background = aName .. " User Backdrop"
				else
					prof.background = self.prdb.BdTexture
				end
				if self.prdb.BdEdgeFile and self.prdb.BdEdgeFile ~= "None" then
					prof.border = aName .. " User Border"
				else
					prof.border = self.prdb.BdBorderTexture
				end
			end
			local bkd = _G.CopyTable(self.Backdrop[1])
			prof.inset = bkd.insets.left
			prof.tileSize = bkd.tileSize
			prof.edgeSize = bkd.edgeSize
			local bc = prof.backgroundColor
			bc.r, bc.g, bc.b, bc.a = self.bClr:GetRGBA()
			local bbc = prof.borderColor
			bbc.r, bbc.g, bbc.b, bbc.a = self.bbClr:GetRGBA()
			prof.colorByChannel = false
			if self.prdb.ChatEditBox.style == 2 then -- Editbox
				prof.border = aName .. " Border"
				prof.inset = 4
				prof.tileSize = 16
				prof.edgeSize = 16
				bc.r, bc.g, bc.b, bc.a = .1, .1, .1, 1
				bbc.r, bbc.g, bbc.b, bbc.a = .2, .2, .2, 1
			elseif self.prdb.ChatEditBox.style == 3 then -- borderless
				bbc.a = 0
			end
			prof.hasBeenSkinned = nil
			-- then apply these changes to the ChatEditBoxes
			eb:SetBackdrop()
			prof, dflts, bkd, bc, bbc = nil, nil, nil, nil, nil
		end

		if not self.prdb.ChatEditBox.style == 2 then
			-- apply the fade/gradient to the ChatEditBoxes
			for _, cfeb in _G.pairs(eb.frames) do
				self:applyGradient(cfeb)
			end
		end
		eb = nil
	end

	self:SecureHookScript(_G.Prat_PopupFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.PratCCFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.PratCCFrameScroll.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}

		self:Unhook(this, "OnShow")
	end)

end
