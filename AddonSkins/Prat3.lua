local aName, aObj = ...
if not aObj:isAddonEnabled("Prat-3.0") then return end
local _G = _G

function aObj:Prat30()

	local eb = _G.LibStub("AceAddon-3.0"):GetAddon("Prat"):GetModule("Editbox", true)
	
	if eb then
		local prof = eb.db.profile

		local prdb = self.db.profile
		if prdb.ChatEditBox.skin then
			local dflts = self.db.defaults.profile
			if prdb.BdDefault then
				prof.background = dflts.BdTexture
				prof.border = dflts.BdBorderTexture
			else
				if prdb.BdFile and prdb.BdFile ~= "None" then
					prof.background = aName .. " User Backdrop"
				else
					prof.background = prdb.BdTexture
				end
				if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
					prof.border = aName .. " User Border"
				else
					prof.border = prdb.BdBorderTexture
				end
			end
			local bkd = _G.CopyTable(self.Backdrop[1])
			prof.inset = bkd.insets.left
			prof.tileSize = bkd.tileSize
			prof.edgeSize = bkd.edgeSize
			local bc = prof.backgroundColor
			bc.r, bc.g, bc.b, bc.a = _G.unpack(self.bColour)
			local bbc = prof.borderColor
			bbc.r, bbc.g, bbc.b, bbc.a = _G.unpack(self.bbColour)
			prof.colorByChannel = false
			if prdb.ChatEditBox.style == 2 then -- Editbox
				prof.border = aName .. " Border"
				prof.inset = 4
				prof.tileSize = 16
				prof.edgeSize = 16
				bc.r, bc.g, bc.b, bc.a = .1, .1, .1, 1
				bbc.r, bbc.g, bbc.b, bbc.a = .2, .2, .2, 1
			elseif prdb.ChatEditBox.style == 3 then -- borderless
				bbc.a = 0
			end
			prof.hasBeenSkinned = nil
			-- then apply these changes to the ChatEditBoxes
			eb:SetBackdrop()
		end

		if not prdb.ChatEditBox.style == 2 then
			-- apply the fade/gradient to the ChatEditBoxes
			for _, cfeb in _G.pairs(eb.frames) do
				self:applyGradient(cfeb)
			end
		end
	end

	if _G.PratCCFrame then
		self:skinScrollBar{obj=_G.PratCCFrameScroll}
		self:addSkinFrame{obj=_G.PratCCFrame}
	end

end
