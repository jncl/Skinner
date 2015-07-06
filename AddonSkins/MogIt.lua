local aName, aObj = ...
if not aObj:isAddonEnabled("MogIt") then return end
local _G = _G

function aObj:MogIt()

	self:skinSlider{obj=_G.MogIt.scroll, adj=-4}
	self:addSkinFrame{obj=_G.MogIt.frame, kfs=true, ri=true, y1=2, x2=1}
	-- remove existing models' background
	for _, frame in _G.pairs(_G.MogIt.models) do
		frame.bg:SetTexture(nil)
	end

-->>-- Modules
	-- Filters
	self:skinEditBox{obj=_G.MogItFiltersName, regs={9}, mi=true}
	self:skinEditBox{obj=_G.MogItFiltersLevelMin, regs={9}}
	self:skinEditBox{obj=_G.MogItFiltersLevelMax, regs={9}}
	self:skinEditBox{obj=_G.MogItFiltersItemLevelMin, regs={9}}
	self:skinEditBox{obj=_G.MogItFiltersItemLevelMax, regs={9}}
	self:skinDropDown{obj=_G.MogItFiltersClassDropdown, rp=true}
	self:skinDropDown{obj=_G.MogItFiltersSourceDropdown, rp=true}
	self:skinDropDown{obj=_G.MogItFiltersQualityDropdown, rp=true}
	self:skinDropDown{obj=_G.MogItFiltersBindDropdown, rp=true}
	-- hook this to remove filters' background
	self:SecureHook(_G.MogIt, "FilterUpdate", function(this)
		for _, frame in _G.ipairs(this.active.filters) do
			this.filters[frame].bg:SetTexture(nil)
		end
	end)
	-- Filters frame
	self:skinScrollBar{obj=_G.MogIt.filt.scroll}
	_G.MogIt.filt.scroll.ScrollBar.top:SetTexture(nil)
	_G.MogIt.filt.scroll.ScrollBar.middle:SetTexture(nil)
	_G.MogIt.filt.scroll.ScrollBar.bottom:SetTexture(nil)
	self:addSkinFrame{obj=_G.MogIt.filt, kfs=true, ri=true, x1=-2, y1=2, x2=1}
	self:removeMagicBtnTex(_G.MogIt.filt.defaults)

-->>-- Preview frames
	self:SecureHook(_G.MogIt, "CreatePreview", function(this)
		for _, frame in _G.pairs(_G.MogIt.previews) do
			if not frame.sknd then
				frame.model.bg:SetTexture(nil)
				self:removeMagicBtnTex(frame.activate)
				for i = 1, 13 do
					self:addButtonBorder{obj=frame.slots[_G.MogIt:GetSlot(i)], ibt=true}
				end
				self:addSkinFrame{obj=frame, kfs=true, ri=true, y1=2, x2=1}
			end
		end
	end)

-->>-- Tooltip
	self:addSkinFrame{obj=_G.MogItTooltip}

end
