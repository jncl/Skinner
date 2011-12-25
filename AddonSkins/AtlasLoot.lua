local aName, aObj = ...
if not aObj:isAddonEnabled("AtlasLoot") then return end

function aObj:AtlasLoot()

-->>-- Default Frame
	local df  = AtlasLoot:GetModule("DefaultFrame")
	df.Frame.VersionNumber:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=df.Frame.ScrollFrame}
	self:skinDropDown{obj=df.Frame.ModuleSelect}
	self:skinDropDown{obj=df.Frame.InstanceSelect}
	self:addSkinFrame{obj=df.Frame, kfs=true, y1=-10, x2=2}

-->>-- AtlasLootPanel Frame
	self:skinEditBox{obj=AtlasLoot.SearchBox, regs={9}, y=-6}
	self:addSkinFrame{obj=AtlasLoot.AtlasLootPanel, kfs=true, ofs=-6, y2=-6}

-->>-- AtlasLootInfo2 Frame
	AtlasLoot.AtlasInfoFrame.Version:SetWidth(180)
	AtlasLoot.AtlasInfoFrame.Info:SetWidth(180)
	self:skinButton{obj=AtlasLoot.AtlasInfoFrame.Button}

-->>-- AtlasLootItems Frame
	for i = 1, #AtlasLoot.ItemFrame.ItemButtons do
		AtlasLoot.ItemFrame.ItemButtons[i].Frame.MenuIconBorder:SetTexture(nil)
	end
	-- AtlasLoot.ItemFrame.BackGround:SetTexture(nil) -- removing this makes it difficult to see the loot

-->-- AtlasLootCompare Frame
	local function skinCompareFrame(obj)

		local frame = obj.CompareFrame
		self:skinScrollBar{obj=frame.ScrollFrameMainFilter}
		-- filters
		for i = 1, 15 do
			self:keepRegions(frame.MainFilterButtons[i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
			self:addSkinFrame{obj=frame.MainFilterButtons[i], ft=ftype, nb=true}
			frame.MainFilterButtons[i]:GetNormalTexture().SetAlpha = function() end -- stop textures from being shown
		end
		-- Sort buttons
		for i = 1, #frame.SortButtons do
			self:keepRegions(frame.SortButtons[i], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
			self:addSkinFrame{obj=frame.SortButtons[i], ft=ftype, nb=true}
		end
		-- hook this to skin extra sort buttons
		self:SecureHook(AtlasLoot, "CompareFrame_SetStatsSortList", function(this, sortList)
			for k,v in ipairs(sortList) do
				if not self.skinFrame[this.CompareFrame.SortButtons[k+2]] then
					self:keepRegions(this.CompareFrame.SortButtons[k+2], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
					self:addSkinFrame{obj=this.CompareFrame.SortButtons[k+2], ft=ftype, nb=true}
				end
			end
			self:Unhook(AtlasLoot, "CompareFrame_SetStatsSortList")
		end)
		self:skinEditBox{obj=frame.SearchFrame.SearchBox, regs={9}}
		self:skinDropDown{obj=frame.StatsListSelect}
		self:skinScrollBar{obj=frame.ScrollFrameItemFrame}
		-- item buttons
		for i = 1, #frame.ItemButtons do
			frame.ItemButtons[i].Frame.MenuIconBorder:SetTexture(nil)
			self:removeRegions(frame.ItemButtons[i].Frame, {6, 7, 8})
		end
		
		-- remove frame textures
		for _, v in pairs(frame.Layers) do
			v:SetTexture(nil)
		end
		self:addSkinFrame{obj=frame, x1=6, y1=-8, y2=6}

	end
	if not AtlasLoot.CompareFrame then
		self:SecureHook(AtlasLoot, "CompareFrame_Create", function(this)
			skinCompareFrame(this)
			self:Unhook(AtlasLoot, "CompareFrame_Create")
			end)
	else
		skinCompareFrame(AtlasLoot)
	end

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasLootTooltipTEMP:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AtlasLootTooltipTEMP, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
