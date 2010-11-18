if not Skinner:isAddonEnabled("AtlasLoot") then return end

function Skinner:AtlasLoot()

-->>-- Default Frame
	local df  = LibStub("AceAddon-3.0"):GetAddon("AtlasLoot"):GetModule("DefaultFrame")
	self:skinScrollBar{obj=df.Frame.ScrollFrame}
	self:skinDropDown{obj=df.Frame.ModuleSelect}
	self:skinDropDown{obj=df.Frame.InstanceSelect}
	self:addSkinFrame{obj=df.Frame, kfs=true, y1=-10, x2=2}

-->>-- AtlasLootPanel Frame
	self:skinEditBox{obj=AtlasLootSearch_Box, regs={9}, y=-6}
	self:addSkinFrame{obj=AtlasLootPanel, kfs=true, ofs=-2, y2=-6}

-->>-- AtlasLootInfo2 Frame
	self:skinButton{obj=AtlasLoot_AtlasInfoFrame_ToggleALButton}

-->>-- AtlasLootItems Frame
	for i = 1, #AtlasLoot.ItemFrame.ItemButtons do
		local btn = AtlasLoot.ItemFrame.ItemButtons[i]
		btn.Frame.MenuIconBorder:SetTexture(nil)
	end

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltip, "OnShow", function(this)
			self:skinTooltip(AtlasLootTooltip)
		end)
	end

end
