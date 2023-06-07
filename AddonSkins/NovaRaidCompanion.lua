local _, aObj = ...
if not aObj:isAddonEnabled("NovaRaidCompanion") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.NovaRaidCompanion = function(self) -- v 1.31

	self:SecureHookScript(_G.NRCTalentFrame, "OnShow", function(this)
		if this.borderFrame then
			self:removeBackdrop(this.borderFrame)
		end
		self:removeBackdrop(self:getChild(this, 4)) -- N.B. Extra version of tree1
		for _, frame in _G.pairs(this.trees) do
			-- N.B. keep background texture
			self:skinObject("frame", {obj=frame, rb=true, fb=true, ofs=0})
		end
		-- .talentFrames {array of arrays}
		self:skinObject("frame", {obj=this.glyphs, rns=true})
		self:skinObject("frame", {obj=this, kfs=true, rb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.button}
			self:skinCloseButton{obj=this.closeButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.NRCTalentFrame)
	self:SecureHookScript(_G.NRCStaticPopupFrame, "OnShow", function(this) -- StaticPopupAttachment
		self:skinObject("frame", {obj=this, rb=true})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.NRCStaticPopupFrame)

	local function skinFilterBtn(btn)
		btn:DisableDrawLayer("BACKGROUND")
		btn:GetNormalTexture():SetTexture(nil)
		btn:GetPushedTexture():SetTexture(nil)
		aObj:skinStdButton{obj=btn, x1=-11, y1=0, x2=11, y2=0, clr="gold"}
	end
	self:SecureHook(_G.NRC, "loadRaidStatusFrames", function(this) -- GridFrame
		local frame = _G.NRCRaidStatusFrame
		self:skinObject("frame", {obj=frame.descFrame, rb=true})
		local function skinGridBtns(fObj)
			for _, sFrame in _G.pairs(fObj.subFrames) do
				aObj:skinObject("frame", {obj=sFrame.tooltip, rns=true})
			end
		end
		self:SecureHook(frame, "updateGridData", function(_)
			skinGridBtns(_G.NRCRaidStatusFrame)
		end)
		self:removeBackdrop(frame.borderFrame)
		-- .groupFrames {array}
			-- .bg
		self:removeBackdrop(frame.topRight.borderFrame)
		self:skinObject("frame", {obj=frame.topRight, rb=true, y1=4})
		self:skinObject("frame", {obj=frame.button.tooltip, rb=true})
		self:skinObject("frame", {obj=frame, ofs=4})
		if self.modBtns then
			skinFilterBtn(frame.button)
			skinFilterBtn(frame.button2)
			self:skinCloseButton{obj=frame.closeButton, noSkin=true}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=frame.checkbox}
		end

		self:Unhook(this, "loadRaidStatusFrames")
	end) -- GridFrame
	self:SecureHook(_G.NRC, "openLockoutsFrame", function(this)
		local frame = _G.NRCLockoutsFrame
		if frame.borderFrame then
			self:removeBackdrop(frame.borderFrame)
		end
		skinFilterBtn(frame.button)
		self:skinObject("frame", {obj=frame, rb=true})
		if self.modBtns then
			self:skinCloseButton{obj=frame.closeButton}
		end

		self:Unhook(this, "openLockoutsFrame")
	end) -- SimpleTextFrame
	self:SecureHook(_G.NRC, "loadRaidLogFrames", function(this) -- MainFrame
		local frame = _G.NRCRaidLogFrame
		self:skinObject("slider", {obj=frame.scrollFrame.ScrollBar, rpTex="background"})
		self:skinObject("frame", {obj=frame.scrollChild.checkbox.tooltip2, rns=true})
		self:skinObject("frame", {obj=frame.scrollChild.checkbox2.tooltip2, rns=true})
		self:skinObject("frame", {obj=frame.scrollChild.checkbox3.tooltip2, rns=true})
		self:skinObject("frame", {obj=frame.scrollChild.checkbox4.tooltip2, rns=true})
		self:skinObject("frame", {obj=frame.scrollChild.checkbox5.tooltip2, rns=true})
		self:skinObject("dropdown", {obj=frame.scrollChild.dropdownMenu})
		self:skinObject("frame", {obj=frame.scrollChild.dropdownMenu.tooltip, rns=true})
		self:skinObject("dropdown", {obj=frame.scrollChild.dropdownMenu2})
		self:skinObject("frame", {obj=frame.scrollChild.dropdownMenu2.tooltip, rns=true})
		self:skinObject("dropdown", {obj=frame.scrollChild.dropdownMenu3})
		self:skinObject("frame", {obj=frame.scrollChild.dropdownMenu3.tooltip, rns=true})
		self:skinObject("frame", {obj=frame.dragFrame.tooltip, rns=true})
		local function skinLineFrames()
			for _, lFrame in _G.pairs(_G.NRCRaidLogFrame.lineFrames) do
				self:skinObject("frame", {obj=lFrame.tooltip, rns=true})
				self:skinObject("frame", {obj=lFrame.removeButton.tooltip, rns=true})
			end
		end
		self:SecureHook(frame, "createLineFrame", function(_)
			skinLineFrames()
		end)
		local function skinSimpleLineFrames()
			for _, slFrame in _G.pairs(_G.NRCRaidLogFrame.simpleLineFrames) do
				self:removeBackdrop(slFrame.borderFrame)
				self:skinObject("frame", {obj=slFrame.tooltip, rns=true})
			end
		end
		self:SecureHook(frame, "createSimpleLineFrame", function(_)
			skinSimpleLineFrames()
		end)
		local function skinExtraBtns()
			for _, btn in _G.pairs(_G.NRCRaidLogFrame.extraButtons) do
				skinFilterBtn(btn)
			end
		end
		self:SecureHook(frame, "createExtraButton", function(_)
			skinExtraBtns()
		end)
		self:skinObject("tabs", {obj=frame.scrollFrame, tabs=frame.scrollFrame.Tabs, ignoreSize=true, ignoreHLTex=true, lod=self.isTT and true, upwards=true, offsets={x1=0, y1=-4, x2=0, y2=-4}})
		self:skinObject("frame", {obj=frame, kfs=true, ri=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=frame.backButton, schk=true}
			self:skinStdButton{obj=frame.scrollChild.normalButton}
			self:skinStdButton{obj=frame.scrollChild.exportButton}
			skinFilterBtn(frame.button1)
			skinFilterBtn(frame.button2)
			skinFilterBtn(frame.button3)
			skinFilterBtn(frame.button4)
			skinFilterBtn(frame.button5)
			skinFilterBtn(frame.button6)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=frame.scrollChild.checkbox}
			self:skinCheckButton{obj=frame.scrollChild.checkbox2}
			self:skinCheckButton{obj=frame.scrollChild.checkbox3}
			self:skinCheckButton{obj=frame.scrollChild.checkbox4}
			self:skinCheckButton{obj=frame.scrollChild.checkbox5}
		end

		self:Unhook(this, "loadRaidLogFrames")
	end)
	self:SecureHook(_G.NRC, "loadRenameLogFrame", function(this, _) -- TextInputFrame
		local frame = _G.NRCRaidLogRenameFrame
		-- .closeButton
		-- .setButton
		-- .resetButton
		-- .input
		self:skinObject("frame", {obj=frame})

		self:Unhook(this, "loadRenameLogFrame")
	end)
	self:SecureHook(_G.NRC, "startMiddleIcon", function(this, _) -- IconFrame
		local frame = _G.NRCMiddleIconFrame

		self:skinObject("frame", {obj=frame, rb=true})

		self:Unhook(this, "startMiddleIcon")
	end)
	self:SecureHook(_G.NRC, "loadLootExportFrame", function(this, _) -- ExportFrame
		local frame = _G.NRCExportFrame
		-- .topFrame
		-- .topFrame.button
		-- .close
		self:skinObject("frame", {obj=frame, rb=true})

		self:Unhook(this, "loadLootExportFrame")
	end)
	self:SecureHook(_G.NRC, "loadTradesExportFrame", function(this, _) -- TradeExportFrame
		local frame = _G.NRCTradeExportFrame
		for i = 1, 2 do
			local ddm = frame["dropdownMenu" .. i]
			self:skinObject("dropdown", {obj=ddm})
			self:skinObject("frame", {obj=ddm.tooltip, rns=true})
			self:skinObject("slider", {obj=frame["slider" .. i]})
		end
		self:skinObject("frame", {obj=frame.topFrame, rb=true, ofs=0})
		frame:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=frame, ofs=6})
		_G.RaiseFrameLevel(frame)
		if self.modBtns then
			frame.close:SetSize(24, 24)
			self:skinCloseButton{obj=frame.close}
			self:skinStdButton{obj=frame.topFrame.button}
		end
		if self.modChkBtns then
			for i = 1, 6 do
				self:skinCheckButton{obj=frame["checkbox" .. i]}
			end
		end

		self:Unhook(this, "loadTradesExportFrame")
	end)

	local function skinDTt(frame)
		aObj:skinObject("frame", {obj=frame.displayTab.top, rb="nop"})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.displayTab.top.button, y1=3, y2=-3}
		end
	end
	local function skinListFrame(frame)
		self:skinObject("frame", {obj=frame.tooltip, rns=true})
		for _, lFrame in _G.pairs(frame.lineFrames) do
			self:removeBackdrop(lFrame.borderFrame)
			self:skinObject("frame", {obj=lFrame.tooltip, rns=true})
		end
		skinDTt(frame)
	end
	self:RawHook(_G.NRC, "createListFrame", function(this, ...) -- RaidCooldowns
		local frame = self.hooks[this].createListFrame(this, ...)
		skinListFrame(frame)
		return frame
	end, true)
	self:RawHook(_G.NRC, "createSimpleScrollFrame", function(this, ...)
		local frame = self.hooks[this].createSimpleScrollFrame(this, ...)
		-- .scrollFrame
		-- .close

		self:skinObject("frame", {obj=frame, rb=true})

		return frame
	end, true)
	self:RawHook(_G.NRC, "createModelFrame", function(this, ...)
		local frame = self.hooks[this].createModelFrame(this, ...)

		return frame
	end, true)
	self:RawHook(_G.NRC, "createTalentFrame", function(this, ...)
		local frame = self.hooks[this].createTalentFrame(this, ...)
		-- .button
		-- .closeButton
		-- .trees {array}
		-- .glyphs

		self:skinObject("frame", {obj=frame, rb=true})

		return frame
	end, true)
	self:RawHook(_G.NRC, "createTextInputFrameLoot", function(this, ...)
		local frame = self.hooks[this].createTextInputFrameLoot(this, ...)
		skinFilterBtn(frame.setButton)
		skinFilterBtn(frame.resetButton)
		self:skinObject("frame", {obj=frame, rb=true})
		if self.modBtns then
			self:skinCloseButton{obj=frame.closeButton}
		end

		return frame
	end, true)
	self:RawHook(_G.NRC, "createTextInputOnly", function(this, ...)
		local frame = self.hooks[this].createTextInputOnly(this, ...)
		self:skinObject("editbox", {obj=frame, y1=-24, y2=24})
		self:skinObject("frame", {obj=frame.tooltip, rns=true})
		skinFilterBtn(frame.resetButton)

		self:skinObject("frame", {obj=frame, rb=true})

		return frame
	end, true)

	-- skin existing frames
	for name, frame in _G.pairs(_G.NRC.framePool) do
		if name == "NRCRaidManaFrame" then -- RaidDataFrame
			self:skinObject("frame", {obj=frame.tooltip, rns=true})
			skinDTt(frame)
		elseif name == "NRCRaidCooldowns1" then -- ListFrame
			skinListFrame(frame)
		elseif name == "NRCTargetSpawnTime" then -- TextDisplayFrame
			self:skinObject("frame", {obj=frame.tooltip, rns=true})
		elseif name == "NRCScrollingRaidEvents" then -- AutoScrollingFrame
			skinDTt(frame)
		end
	end

end
