local _, aObj = ...
if not aObj:isAddonEnabled("NovaWorldBuffs") then return end
local _G = _G

aObj.addonsToSkin.NovaWorldBuffs = function(self) -- v 1.88

	local function skinBtn(btn, close)
		if close then
			btn:SetSize(26, 26)
			aObj:skinCloseButton{obj=btn}
		else
			btn:SetHeight(20)
			aObj:skinStdButton{obj=btn}
		end
	end
	self:SecureHookScript(_G.NWBbuffListFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NWBbuffListFrameClose, true)
			skinBtn(_G.NWBbuffListFrameConfButton)
			skinBtn(_G.NWBbuffListFrameTimersButton)
			skinBtn(_G.NWBbuffListFrameWipeButton)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.NWBShowStatsButton}
			self:skinCheckButton{obj=_G.NWBShowStatsAllButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.NWBlayerFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NWBlayerFrameClose, true)
			skinBtn(_G.NWBlayerFrameConfButton)
			skinBtn(_G.NWBlayerFrameBuffsButton)
			skinBtn(_G.NWBlayerFrameMapButton)
			skinBtn(_G.NWBlayerFrameCopyButton)
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.NWBCopyFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.NWBCopyDragFrame, kfs=true})
		self:skinObject("frame", {obj=this, kfs=true, ofs=6})
		if self.modBtns then
			skinBtn(_G.NWBCopyFrameClose, true)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.NWBCopyDiscordButton}
		end

		self:Unhook(this, "OnShow")
	end)

	-- NWBLayerMapFrame
	self:skinObject("frame", {obj=_G.MinimapLayerFrame, kfs=true})
	-- NWBVersionFrame

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.NWBbuffListDragFrame.tooltip)
		self:add2Table(self.ttList, _G.NWBbuffListFrameWipeButton.tooltip)
		self:add2Table(self.ttList, _G.NWBlayerDragFrame.tooltip)
		self:add2Table(self.ttList, _G.NWBLayerMapDragFrame.tooltip)
		self:add2Table(self.ttList, _G.MinimapLayerFrame.tooltip)
		self:add2Table(self.ttList, _G.NWBVersionDragFrame.tooltip)
	end)

end
