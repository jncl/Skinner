local aName, aObj = ...
if not aObj:isAddonEnabled("AtlasLoot") then return end

function aObj:AtlasLoot()

-->>-- Default Frame
	local df  = AtlasLoot:GetModule("DefaultFrame")
	self:skinScrollBar{obj=df.Frame.ScrollFrame}
	self:skinDropDown{obj=df.Frame.ModuleSelect}
	self:skinDropDown{obj=df.Frame.InstanceSelect}
	self:addSkinFrame{obj=df.Frame, kfs=true, y1=-10, x2=2}

-->>-- AtlasLootPanel Frame
	self:skinEditBox{obj=AtlasLoot.SearchBox, regs={9}, y=-6}
	self:addSkinFrame{obj=AtlasLoot.AtlasLootPanel, kfs=true, ofs=-2, y2=-6}

-->>-- AtlasLootInfo2 Frame
	AtlasLoot.AtlasInfoFrame.Version:SetWidth(180)
	AtlasLoot.AtlasInfoFrame.Info:SetWidth(180)
	self:skinButton{obj=AtlasLoot.AtlasInfoFrame.Button}

-->>-- AtlasLootItems Frame
	for i = 1, #AtlasLoot.ItemFrame.ItemButtons do
		local btn = AtlasLoot.ItemFrame.ItemButtons[i]
		btn.Frame.MenuIconBorder:SetTexture(nil)
	end

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltipTEMP:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltipTEMP, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
