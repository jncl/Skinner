if not Skinner:isAddonEnabled("Prat-3.0") then return end

function Skinner:Prat30() -- concatenation of Prat-3.0

	local eb = LibStub("AceAddon-3.0"):GetAddon("Prat"):GetModule("Editbox", true)

	-- check to see if these values have already been set
	-- if not then set them, otherwise don't
	-- this allows them to be changed and those changes to not be overwritten
	if not eb.db.profile.hasBeenSkinned then 
		-- N.B. similar code to Chatter skin
		-- set the Prat EditBox values to match the Skinner ones
		eb.db.profile.background = "Blizzard ChatFrame Background"
		eb.db.profile.border = self.db.profile.ChatEditBox.style == 1 and "Blizzard Tooltip" or "Skinner EditBox/ScrollBar Border"
		local c = eb.db.profile.backgroundColor
		c.r, c.g, c.b, c.a = unpack(self.bColour)
		local c = eb.db.profile.borderColor
		c.r, c.g, c.b, c.a = unpack(self.bbColour)
		eb.db.profile.inset = 4
		eb.db.profile.tileSize = 16
		eb.db.profile.edgeSize = 16
		eb.db.profile.hasBeenSkinned = true
		-- then apply these changes to the ChatEditBoxes
		eb:SetBackdrop()
	end

	-- apply the fade/gradient to the ChatEditBoxes
	for _, cfeb in pairs(eb.frames) do
		self:applyGradient(cfeb)
	end

	if PratCCFrame then
		self:skinScrollBar{obj=PratCCFrameScroll}
		self:skinButton{obj=PratCCFrameButton}
		self:addSkinFrame{obj=PratCCFrame}
	end
	
end
