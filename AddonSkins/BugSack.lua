local aName, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v r300-release

	-- close with Esc
	self:add2Table(_G.UISpecialFrames, "BugSackFrame")

	self:SecureHook(_G.BugSack, "OpenSack", function(this)
		self:skinSlider{obj=_G.BugSackScroll.ScrollBar, size=3}
		self:skinStdButton{obj=_G.BugSackPrevButton}
		self:skinStdButton{obj=_G.BugSackSendButton}
		self:skinStdButton{obj=_G.BugSackNextButton}
		self:skinCloseButton{obj=self:getChild(_G.BugSackFrame, 1)}
		self:addSkinFrame{obj=_G.BugSackFrame, ft="a", kfs=true, nb=true, y1=-2, x2=-1, y2=2}
		_G.RaiseFrameLevelByTwo(_G.BugSackFrame)
		self:moveObject{obj=self:getRegion(_G.BugSackFrame, 11), x=0, y=-8} -- countLabel

		-- tabs
		for _, tabObj in _G.pairs{_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast} do
			self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=tabObj, ft="a", nb=true, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
			if self.isTT then
				if tabObj == _G.BugSackTabAll then
					self:setActiveTab(tabObj.sf)
				else
					self:setInactiveTab(tabObj.sf)
				end
				-- hook this to change the texture for the Active and Inactive tabs
				self:SecureHookScript(tabObj, "OnClick", function(this)
					for _, tabObj in _G.pairs{_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast} do
						if tabObj == this then
							self:setActiveTab(tabObj.sf)
						else
							self:setInactiveTab(tabObj.sf)
						end
					end
				end)
			end
		end

		self:Unhook(_G.BugSack, "OpenSack")
	end)

	-- Config
	self.iofDD["BugSackFontSize"] = 109
	self.iofDD["BugSackSoundDropdown"] = 109

end
