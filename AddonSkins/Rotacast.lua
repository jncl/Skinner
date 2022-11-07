local _, aObj = ...
if not aObj:isAddonEnabled("RotaCast") then return end
local _G = _G

aObj.addonsToSkin.RotaCast = function(self) -- v 12.1

	-- Minimap icon
	if self.prdb.MinimapButtons.skin then
		_G["Rotacast.Frames.Icon"]:DisableDrawLayer("BACKGROUND")
		_G["Rotacast.Frames.Icon"]:DisableDrawLayer("OVERLAY")
		if not self.prdb.MinimapButtons.style then
			self:skinObject("frame", {obj=_G["Rotacast.Frames.Icon"], ofs=0})
		end
	end

	-- Cast(ing) buttons
	self:skinObject("frame", {obj=_G["Rotacast.Frames.Edit.Header"], kfs=true, rns=true})
	if self.modBtnBs then
		self:addButtonBorder{obj=_G["Rotacast.Frames.Edit.SequenceDown"], ofs=0, x2=-1, clr="grey"}
		self:addButtonBorder{obj=_G["Rotacast.Frames.Edit.SequenceUp"], ofs=0, x2=-1, clr="grey"}
	end

	local eBar = _G["Rotacast.Frames.Edit.Bar"]
	self:skinObject("frame", {obj=eBar, kfs=true, rns=true, ofs=0})
	if self.modBtnBs then
		for i = 1, 100 do
			self:addButtonBorder{obj=self:getChild(eBar, i), abt=true, sabt=true, clr="grey"}
		end
		self:addButtonBorder{obj=_G["Rotacast.Frames.CastButton"], abt=true, sabt=true}
	end

	-- Options frame
	local rfo = _G["Rotacast.Frames.Options"]
	self:moveObject{obj=self:getRegion(rfo, 10), y=-6} -- Header
	self:skinObject("frame", {obj=rfo, kfs=true, rns=true, cb=true})
	local binding = self:getChild(rfo, 2)
	local reset = self:getChild(rfo, 3)
	local cbOpts = self:getChild(rfo, 4)
	local cOpts = self:getChild(rfo, 6)
	local gOpts = self:getChild(rfo, 7)
	self:skinObject("frame", {obj=binding, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=reset, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=cbOpts, kfs=true, rns=true, fb=true})
	self:skinObject("slider", {obj=_G["Rotacast.Frames.CastButtonOptions.Sizer"], rpTex="background"})
	self:skinObject("frame", {obj=cOpts, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=gOpts, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=_G["Rotacast.Frames.GuideDisplay"], cb=true, ofs=8})
	self:skinObject("slider", {obj=_G["Rotacast.Frames.GuideDisplay"].ScrollBar, rpTex="background"})
	if self.modBtns then
		self:skinStdButton{obj=binding.ScrollSave}
		self:skinStdButton{obj=binding.Show}
		self:skinStdButton{obj=self:getChild(rfo, 8)} -- Import/Export
		self:skinStdButton{obj=self:getChild(rfo, 9)} -- Restore
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=binding.Options1}
		self:skinCheckButton{obj=reset.Options1}
		self:skinCheckButton{obj=reset.Options2}
		self:skinCheckButton{obj=reset.Options3}
		self:skinCheckButton{obj=reset.Options4}
		self:skinCheckButton{obj=cbOpts.Options1}
		self:skinCheckButton{obj=cbOpts.Options2}
		self:skinCheckButton{obj=cOpts.Options1}
		self:skinCheckButton{obj=cOpts.Options2}
		self:skinCheckButton{obj=cOpts.Options3}
		self:skinCheckButton{obj=gOpts.Options1}
		self:skinCheckButton{obj=gOpts.Options2}
		self:skinCheckButton{obj=gOpts.Options3}
	end

	-- SetBindings display
	local sbDisplay = _G["Rotacast.Frames.SetBindingsDisplay"]
	for _, eBox in pairs(sbDisplay.Edit) do
		self:adjHeight{obj=eBox, adj=10}
		self:skinObject("editbox", {obj=eBox})
	end
	self:skinObject("frame", {obj=sbDisplay, kfs=true, rns=true, cb=true})
	if self.modBtns then
		self:skinStdButton{obj=self:getPenultimateChild(sbDisplay)}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.BindAnyMod}
	end

	-- Import/Export display
	local ieDisplay = _G["Rotacast.Frames.ImportExportDisplay"]
	self:skinObject("frame", {obj=ieDisplay, kfs=true, rns=true, cb=true})
	self:skinObject("frame", {obj=self:getChild(ieDisplay, 3), kfs=true, fb=true})
	if self.modBtns then
		self:getChild(ieDisplay, 2):SetSize(32, 32)
		self:moveObject{obj=self:getChild(ieDisplay, 2), x=-5, y=-32}
	end
	if self.modBtns then
		self:skinStdButton{obj=self:getChild(ieDisplay, 3)} -- Import
		self:skinStdButton{obj=self:getChild(ieDisplay, 4)} -- Export
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=ieDisplay.Options1}
		self:skinCheckButton{obj=ieDisplay.Options2}
		self:skinCheckButton{obj=ieDisplay.Options3}
	end

end
