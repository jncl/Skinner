local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["SecureTabs-2.0"] = function(self) -- v 1
	if self.initialized.SecureTabs then return end
	self.initialized.SecureTabs = true

	local lST = _G.LibStub:GetLibrary("SecureTabs-2.0", true)

	local function skinTab(tab)
		aObj:keepRegions(tab, {7, 8}) -- 7 is text, 8 is highlight
		aObj:addSkinFrame{obj=tab, ft="a", noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=2}
		if aObj.isTT then
			aObj:setInactiveTab(tab.sf)
		end
		-- aObj.tabFrames[tab] = true
	end
	local function skinCover(cover)
		cover:DisableDrawLayer("BACKGROUND")
		cover:SetText(nil)
		cover.SetText = _G.nop
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

	-- hook this to update tabs
	self:SecureHook(lST, "Update", function(this, panel, selection)
		-- aObj:Debug("SecureTabs Update: [%s, %s, %s]", panel, selection, panel.selectedTab)
		if not this.tabs[panel] then return end
		if self.isTT then
			for i, tab in ipairs(this.tabs[panel]) do
				-- print("update - panel", i, tab)
				if tab == selection then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
			if selection then
				-- TODO: not displaying as an inactive tab, text colour & posn are wrong
				self:setInactiveTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab].sf)
			else
				self:setActiveTab(_G[panel:GetName() .. "Tab" .. panel.selectedTab].sf)
			end
		end
	end)

end
