local aName, aObj = ...
if not aObj:isAddonEnabled("Megaphone") then return end

function aObj:Megaphone()

	-- Main frame
	if self.modBtnBs then
		self:addButtonBorder{obj=MegaphoneLogo}
	end
	self:addSkinFrame{obj=MegaphoneContainingFrame, noBdr=true}
	-- Config frame
	self:skinEditBox{obj=MegaphoneButtonConfigFrameEditBox1, regs={9}}
	self:skinEditBox{obj=MegaphoneButtonConfigFrameEditBox2, regs={9}}
	self:skinEditBox{obj=MegaphoneButtonConfigFrameEditBox3, regs={9}}
	self:skinEditBox{obj=MegaphoneButtonConfigFrameEditBox4, regs={9}}
	self:skinEditBox{obj=MegaphoneButtonConfigFrameEditBox5, regs={9}}
	self:addSkinFrame{obj=MegaphoneButtonConfigFrame}
	-- Preferences frame
	self:addSkinFrame{obj=MegaphonePreferencesFrame}
	
end
