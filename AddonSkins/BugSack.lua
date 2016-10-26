local aName, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

function aObj:BugSack()

	-- close with Esc
	self:add2Table(_G.UISpecialFrames, "BugSackFrame")

	self:SecureHook(_G.BugSack, "OpenSack", function(this)
		self:skinSlider{obj=_G.BugSackScroll.ScrollBar, size=3}
		self:addSkinFrame{obj=_G.BugSackFrame, kfs=true, y1=-2, x2=-1, y2=2}
		-- tabs
		local tabs = {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast}
		for _, tabObj in _G.pairs(tabs) do
			self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
			if self.isTT then
				if tabObj == _G.BugSackTabAll then self:setActiveTab(tabObj.sf)
				else self:setInactiveTab(tabObj.sf) end
				-- hook this to change the texture for the Active and Inactive tabs
				self:SecureHookScript(tabObj, "OnClick", function(this)
					for _, tabObj in _G.pairs(tabs) do
						if tabObj == this then self:setActiveTab(tabObj.sf)
						else self:setInactiveTab(tabObj.sf) end
					end
				end)
			end
		end
		self:Unhook(_G.BugSack, "OpenSack")
	end)

end
