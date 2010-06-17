if not Skinner:isAddonEnabled("GnomeWorks") then return end

function Skinner:GnomeWorks()

	local gw = GnomeWorks
	
	-- hook this to skin ScrollBars
	self:RawHook(gw, "CreateScrollingTable", function(this, ...)
		local frame = self.hooks[this].CreateScrollingTable(this, ...)
		self:skinScrollBar{obj=frame}
		local scrollBar = _G[frame:GetName().."ScrollBar"]
		self:getRegion(self:getChild(scrollBar, 3), 1):SetTexture(nil) -- remove scroll bar trough
		return frame
	end, true)
	
	-- hook this to skin frames
	self:SecureHook(gw, "OnTradeSkillShow", function(this)
		-- GnomeWorks.MainWindow
		local mw = gw.MainWindow
		self:keepFontStrings(mw.title)
		self:addSkinFrame{obj=mw, kfs=true, y1=3, x2=3}
		self:glazeStatusBar(gw.levelStatusBar, 0, nil)
		self:skinEditBox{obj=gw.searchBoxFrame}
--		local df = gw.detailFrame
--		local rf = gw.reagentFrame
--		local sf = gw.skillFrame
--		local cf = gw.ControlFrame
		-- GnomeWorks.QueueWindow
		self:addSkinFrame{obj=gw.QueueWindow, kfs=true, y1=3, x2=3, y2=3}
		self:Unhook(gw, "OnTradeSkillShow")
	end)

end
