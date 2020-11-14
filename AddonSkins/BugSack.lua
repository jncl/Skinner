local _, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end
local _G = _G

aObj.addonsToSkin.BugSack = function(self) -- v 9.0.0

	-- close with Esc
	self:add2Table(_G.UISpecialFrames, "BugSackFrame")

	self:SecureHook(_G.BugSack, "OpenSack", function(this)
		self:skinObject("slider", {obj=_G.BugSackScroll.ScrollBar})
		self:moveObject{obj=self:getRegion(_G.BugSackFrame, 11), x=0, y=-8} -- countLabel
		self:skinObject("frame", {obj=_G.BugSackFrame, kfs=true, ofs=-2, x2=-1})
		_G.RaiseFrameLevelByTwo(_G.BugSackFrame)
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.BugSackFrame, 1)}
			for _, btn in _G.pairs{_G.BugSackPrevButton, _G.BugSackSendButton, _G.BugSackNextButton} do
				self:skinStdButton{obj=btn}
				self:SecureHook(btn, "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(btn, "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
		end

		-- tabs
		this.Tabs = {_G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast}
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, regions={7, 8}, lod=true, ignoreHLTex=true, func=aObj.isTT and function(tab) aObj:SecureHookScript(tab, "OnClick", function(this) for _, tab in _G.pairs(_G.BugSack.Tabs) do if tab == this then aObj:setActiveTab(tab. sf) else aObj:setInactiveTab(tab.sf) end end end) end})

		self:Unhook(this, "OpenSack")
	end)

	-- Config
	self.iofDD["BugSackFontSize"] = 109
	self.iofDD["BugSackSoundDropdown"] = 109

end
