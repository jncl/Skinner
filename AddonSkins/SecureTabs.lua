local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["SecureTabs-2.0"] = function(self) -- v 2
	if self.initialized.SecureTabs then return end
	self.initialized.SecureTabs = true

	local lST = _G.LibStub:GetLibrary("SecureTabs-2.0", true)

	local ht
	local function chgHLTex(tab)
		ht = tab:GetHighlightTexture()
		if ht then
			ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
			ht:ClearAllPoints()
			ht:SetPoint("TOPLEFT", 6, -2)
			ht:SetPoint("BOTTOMRIGHT", -6, 2)
		end
	end
	local function skinTab(tab)
		aObj:keepRegions(tab, {10}) -- 10 is text
		aObj:skinObject("frame", {obj=tab, noBdr=aObj.isTT, x1=0, y1=aObj.isTT and 3 or -2, x2=0, y2=2})
		if aObj.isTT then
			aObj:setInactiveTab(tab.sf)
		end
		chgHLTex(tab)
	end
	local function skinCover(cover)
		cover:DisableDrawLayer("BACKGROUND")
		cover:SetText(nil)
		cover.SetText = _G.nop
		chgHLTex(cover)
	end
	-- skin existing tabs and covers
	for _, tabTable in pairs(lST.tabs) do
		for _, tab in pairs(tabTable) do
			skinTab(tab)
		end
	end
	for _, cover in pairs(lST.covers) do
		skinCover(cover)
	end

	-- hook this to skin new tabs
	self:RawHook(lST, "Add", function(this, panel, frame, label)
		local tab = self.hooks[this].Add(this, panel, frame, label)
		-- aObj:Debug("SecureTabs Add: [%s, %s, %s, %s]", panel, frame, label, tab)
		skinTab(tab)
		skinCover(this.covers[panel])
		return tab
	end, true)

	-- hook this to update textured tabs
	if self.isTT then
		self:SecureHook(lST, "Update", function(this, panel, selection)
			-- aObj:Debug("SecureTabs Update: [%s, %s, %s, %s]", this.tabs[panel], panel, selection, panel.selectedTab)
			if not this.tabs[panel] then return end
			for _, tab in _G.ipairs(this.tabs[panel]) do
				-- print("update - panel", i, tab)
				if tab == selection then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
			-- change textures for other tabs
			if selection then
				self:setInactiveTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab].sf)
				_G.PanelTemplates_DeselectTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab])
			else
				self:setActiveTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab].sf)
				_G.PanelTemplates_SelectTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab])
			end
		end)
	end

end
