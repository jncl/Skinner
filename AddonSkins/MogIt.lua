local aName, aObj = ...
if not aObj:isAddonEnabled("MogIt") then return end

function aObj:MogIt()

	self:skinDropDown{obj=MogItDropdown}
	self:skinDropDown{obj=MogItSorting}
	self:skinSlider{obj=MogItScroll}
	self:addSkinFrame{obj=MogItFrame, kfs=true, ri=true, y1=2, x2=1}
	-- remove existing models' background
	for _, v in pairs(MogIt.models) do
		v.bg:SetTexture(nil)
	end
	-- hook this to remove models' backgrounds
	self:RawHook(MogIt, "addModel", function(view)
		local btn = self.hooks[MogIt].addModel(view)
		btn.bg:SetTexture(nil)
		return btn
	end, true)

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
	self:skinScrollBar{obj=MogItFiltersScroll}
	MogItFiltersScroll.ScrollBar.top:SetTexture(nil)
	MogItFiltersScroll.ScrollBar.middle:SetTexture(nil)
	MogItFiltersScroll.ScrollBar.bottom:SetTexture(nil)
	self:addSkinFrame{obj=MogItFilters, kfs=true, ri=true, x1=-2, y1=2, x2=1}
	-- hook this to remove filters' background
	self:SecureHook(MogIt, "FilterUpdate", function(this)
		for k,v in ipairs(this.active.filters) do
			this.filters[v].bg:SetTexture(nil)
		end
	end)
	-- Preview
	MogItPreview.model.bg:SetTexture(nil)
	self:addSkinFrame{obj=MogItPreview, kfs=true, ri=true, y1=2, x2=1}
	-- Tooltip
	self:addSkinFrame{obj=MogItTooltip}

end
