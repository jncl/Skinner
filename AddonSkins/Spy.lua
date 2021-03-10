local _, aObj = ...
if not aObj:isAddonEnabled("Spy") then return end
local _G = _G

aObj.addonsToSkin.Spy = function(self) -- v 1.1.2

	self:SecureHookScript(_G.Spy.MainWindow, "OnShow", function(this)
		self:removeBackdrop(this.TitleBar)
		self:skinObject("frame", {obj=this, kfs=true, cbns=true, y1=-10, y2=1})
		_G.Spy.Colors:UnregisterItem(this.Title)
		_G.Spy.Colors:UnregisterItem(this.Background)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.Spy.MainWindow)

	self:SecureHookScript(_G.Spy.AlertWindow, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.Spy.AlertWindow)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.Spy.MapTooltip)
	end)

	self:SecureHookScript(_G.SpyStatsFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.SpyStatsTabFrameTabContentFrameScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=_G.SpyStatsTabFrameTabContentFrame, kfs=true, fb=true})
		self:skinObject("editbox", {obj=_G.SpyStatsFilterBox, ofs=0})
		self:moveObject{obj=_G.SpyStatsFrame_Title, y=-6}
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinCloseButton{obj=_G.SpyStatsFrameTopCloseButton}
			self:skinStdButton{obj=_G.SpyStatsRefreshButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.SpyStatsKosCheckbox}
			self:skinCheckButton{obj=_G.SpyStatsWinsLosesCheckbox}
			self:skinCheckButton{obj=_G.SpyStatsReasonCheckbox}
		end

		self:Unhook(this, "OnShow")
	end)

end
