local _, aObj = ...
if not aObj:isAddonEnabled("RotaCast") then return end
local _G = _G

aObj.addonsToSkin.RotaCast = function(self) -- v 11.0

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
	self:skinObject("frame", {obj=self:getChild(eBar, 1), kfs=true, rns=true, ofs=0})
	if self.modBtnBs then
		for i = 2, 101 do
			self:addButtonBorder{obj=self:getChild(eBar, i), abt=true, sabt=true, clr="grey"}
		end
		self:addButtonBorder{obj=_G["Rotacast.Frames.CastButton"], abt=true, sabt=true}
	end

	-- Options frame
	self:removeRegions(_G["Rotacast.Frames.Options"], {1}) -- header texture
	self:skinObject("frame", {obj=self:getChild(_G["Rotacast.Frames.Options"], 1), rns=true, y1=6})
	local closeBtn = self:getChild(_G["Rotacast.Frames.Options"], 2)
	local binding = self:getChild(_G["Rotacast.Frames.Options"], 3)
	local reset = self:getChild(_G["Rotacast.Frames.Options"], 4)
	local cbOpts = self:getChild(_G["Rotacast.Frames.Options"], 5)
	local sizer = self:getChild(_G["Rotacast.Frames.Options"], 6)
	local cOpts = self:getChild(_G["Rotacast.Frames.Options"], 7)
	local gOpts = self:getChild(_G["Rotacast.Frames.Options"], 8)
	self:skinObject("frame", {obj=binding, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=reset, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=cbOpts, kfs=true, rns=true, fb=true})
	self:skinObject("slider", {obj=sizer, rpTex="background"})
	self:skinObject("frame", {obj=cOpts, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=gOpts, kfs=true, rns=true, fb=true})
	self:skinObject("frame", {obj=_G["Rotacast.Frames.GuideDisplay"], ofs=8})
	self:skinObject("slider", {obj=self:getChild(_G["Rotacast.Frames.GuideDisplay"], 1), rpTex="background"})
	if self.modBtns then
		closeBtn:SetSize(32, 32)
		self:skinCloseButton{obj=closeBtn, noSkin=true}
		self:skinStdButton{obj=self:getChild(binding, 3)}
		self:skinStdButton{obj=self:getChild(binding, 4)}
		self:skinStdButton{obj=self:getChild(_G["Rotacast.Frames.Options"], 9)} -- Import/Export
		self:skinStdButton{obj=self:getChild(_G["Rotacast.Frames.Options"], 10)} -- Restore
		self:getChild(_G["Rotacast.Frames.GuideDisplay"], 3):SetSize(32, 32)
		self:skinCloseButton{obj=self:getChild(_G["Rotacast.Frames.GuideDisplay"], 3)}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=self:getChild(binding, 2)}
		self:skinCheckButton{obj=_G.ResetOptions1}
		self:skinCheckButton{obj=_G.ResetOptions2}
		self:skinCheckButton{obj=_G.ResetOptions3}
		self:skinCheckButton{obj=_G.ResetOptions4}
		self:skinCheckButton{obj=_G.CastButtonOptions1}
		self:skinCheckButton{obj=_G.CastButtonOptions2}
		self:skinCheckButton{obj=_G.CastingOptions1}
		self:skinCheckButton{obj=_G.CastingOptions2}
		self:skinCheckButton{obj=_G.CastingOptions3}
		self:skinCheckButton{obj=_G.GeneralOptions1}
		self:skinCheckButton{obj=_G.GeneralOptions2}
		self:skinCheckButton{obj=_G.GeneralOptions3}
	end

	-- SetBindings display
	local sbDisplay = _G["Rotacast.Frames.SetBindingsDisplay"]
	for _, eBox in pairs(sbDisplay.Edit) do
		self:adjHeight{obj=eBox, adj=10}
		self:skinObject("editbox", {obj=eBox})
	end
	self:skinObject("frame", {obj=sbDisplay, kfs=true, rns=true})
	if self.modBtns then
		self:getChild(sbDisplay, 2):SetSize(32, 32)
		self:moveObject{obj=self:getChild(sbDisplay, 2), x=-5, y=-32}
		self:skinCloseButton{obj=self:getChild(sbDisplay, 2)}
		self:skinStdButton{obj=self:getChild(sbDisplay, 19)}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.BindAnyMod}
	end

	-- Import/Export display
	local ieDisplay = _G["Rotacast.Frames.ImportExportDisplay"]
	self:skinObject("frame", {obj=ieDisplay, kfs=true, rns=true})
	self:skinObject("frame", {obj=self:getChild(ieDisplay, 3), kfs=true, fb=true})
	if self.modBtns then
		self:getChild(ieDisplay, 2):SetSize(32, 32)
		self:moveObject{obj=self:getChild(ieDisplay, 2), x=-5, y=-32}
		self:skinCloseButton{obj=self:getChild(ieDisplay, 2)}
	end
	if self.modBtns then
		self:skinStdButton{obj=self:getChild(ieDisplay, 4)}
		self:skinStdButton{obj=self:getChild(ieDisplay, 5)}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.ImportExportOptions1}
		self:skinCheckButton{obj=_G.ImportExportOptions2}
		self:skinCheckButton{obj=_G.ImportExportOptions3}
	end

end
