local aName, aObj = ...
if not aObj:isAddonEnabled("DeathNote") then return end
local _G = _G

function aObj:DeathNote()

	self:SecureHook(_G.DeathNote, "Show", function(this)
		self:addSkinFrame{obj=this.filters_frame}
		self:addSkinFrame{obj=this.filters_tab, kfs=true}
		self:addSkinFrame{obj=this.name_list_border}
		self:applySkin{obj=this.logframe.iframe} -- use applySkin otherwise detail is hidden
		self:skinSlider{obj=this.logframe.scrollbar, size=3}
		self:addSkinFrame{obj=_G.DeathNoteFrame}
		-- Tabs
		local tab, tabSF
		for i = 1, this.filters_tab.numTabs do
			tab = _G["DeathNoteFiltersTab" .. i]
			self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=-2}
			tabSF.up = true -- tabs grow upwards
			-- set textures here first time thru
			if i == 1 then
				if self.isTT then self:setActiveTab(tabSF) end
			else
				if self.isTT then self:setInactiveTab(tabSF) end
			end
		end
		self:SecureHook(_G.DeathNote, "SetFiltersTab", function(this, tab)
			local tabSF
			for i = 1, this.filters_tab.numTabs do
				tabSF = _G["DeathNoteFiltersTab" .. i].sf
				if i == tab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
			tabSF = nil
		end)
		self:Unhook(_G.DeathNote, "Show")
	end)

end
