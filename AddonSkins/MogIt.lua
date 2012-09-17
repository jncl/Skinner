local aName, aObj = ...
if not aObj:isAddonEnabled("MogIt") then return end

function aObj:MogIt()

	self:skinSlider{obj=MogIt.scroll, adj=-4}
	self:addSkinFrame{obj=MogIt.frame, kfs=true, ri=true, y1=2, x2=1}
	-- remove existing models' background
	for _, frame in pairs(MogIt.models) do
		frame.bg:SetTexture(nil)
	end

-->>-- Modules
	-- Filters
	self:skinEditBox{obj=MogItFiltersName, regs={9}, mi=true}
	self:skinEditBox{obj=MogItFiltersLevelMin, regs={9}}
	self:skinEditBox{obj=MogItFiltersLevelMax, regs={9}}
	self:skinEditBox{obj=MogItFiltersItemLevelMin, regs={9}}
	self:skinEditBox{obj=MogItFiltersItemLevelMax, regs={9}}
	self:skinDropDown{obj=MogItFiltersClassDropdown, rp=true}
	self:skinDropDown{obj=MogItFiltersSourceDropdown, rp=true}
	self:skinDropDown{obj=MogItFiltersQualityDropdown, rp=true}
	self:skinDropDown{obj=MogItFiltersBindDropdown, rp=true}
	-- hook this to remove filters' background
	self:SecureHook(MogIt, "FilterUpdate", function(this)
		for _, frame in ipairs(this.active.filters) do
			this.filters[frame].bg:SetTexture(nil)
		end
	end)
	-- Filters frame
	self:skinScrollBar{obj=MogIt.filt.scroll}
	MogIt.filt.scroll.ScrollBar.top:SetTexture(nil)
	MogIt.filt.scroll.ScrollBar.middle:SetTexture(nil)
	MogIt.filt.scroll.ScrollBar.bottom:SetTexture(nil)
	self:addSkinFrame{obj=MogIt.filt, kfs=true, ri=true, x1=-2, y1=2, x2=1}
	self:removeMagicBtnTex(MogIt.filt.defaults)

-->>-- Preview frames
	self:SecureHook(MogIt, "CreatePreview", function(this)
		for _, frame in pairs(MogIt.previews) do
			if not self.skinFrame[frame] then
				frame.model.bg:SetTexture(nil)
				self:removeMagicBtnTex(frame.activate)
				for i = 1, 13 do
					self:addButtonBorder{obj=frame.slots[MogIt:GetSlot(i)], ibt=true}
				end
				self:addSkinFrame{obj=frame, kfs=true, ri=true, y1=2, x2=1}
			end
		end
	end)

-->>-- Tooltip
	self:addSkinFrame{obj=MogItTooltip}

end
