local _, aObj = ...
if not aObj:isAddonEnabled("NovaInstanceTracker") then return end
local _G = _G

aObj.addonsToSkin.NovaInstanceTracker = function(self) -- v 1.13

	local NIT = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("NovaInstanceTracker", true)

	local function skinBtn(btn, close)
		if close then
			btn:SetSize(26, 26)
			aObj:skinCloseButton{obj=btn}
		else
			btn:SetHeight(20)
			aObj:skinStdButton{obj=btn}
		end
	end
	self:SecureHookScript(_G.NITInstanceFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.NITInstanceFrameSelectAltMenu, x2=109})
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NITInstanceFrameClose, true)
			skinBtn(_G.NITInstanceFrameConfButton)
			skinBtn(_G.NITInstanceFrameTradesButton)
			self:skinStdButton{obj=_G.NITInstanceFrameRestedButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.NITInstanceFrameShowsAltsButton}
		end
		self:add2Table(self.ttList, _G.NITInstanceFrameSelectAltMenuTooltip)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHook(NIT, "createInstanceLineFrame", function(this, type, data,count)
		self:add2Table(self.ttList, _G[type .. "NITInstanceLineTooltip"])
		self:add2Table(self.ttList, _G[type .. "NITInstanceLineTooltipRB"])
	end)
	self:SecureHookScript(_G.NITInstanceFrameDC, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NITInstanceDCFrameClose, true)
			self:skinStdButton{obj=_G.NITInstanceFrameDCDelete}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.NITTradeLogFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NITTradeLogFrameClose, true)
			skinBtn(_G.NITTradeLogFrameResetButton)
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.NITAltsFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NITAltsFrameClose, true)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.NITAltsFrameCheckbox}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHook(NIT, "createAltsLineFrame", function(this, type, data,count)
		self:add2Table(self.ttList, _G[type .. "NITAltsLineTooltip"])
		self:add2Table(self.ttList, _G[type .. "NITAltsLineTooltipRB"])
	end)
	self:SecureHookScript(_G.NITCharsFrameDC, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NITCharsDCFrameClose, true)
			self:moveObject{obj=_G.NITCharsDCFrameClose, x=-3, y=-3}
			self:skinStdButton{obj=_G.NITCharsFrameDCDelete}
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.NITInstanceDragTooltip)
		self:add2Table(self.ttList, _G.NITTradeLogDragTooltip)
		self:add2Table(self.ttList, _G.NITAltsDragTooltip)
	end)

end
