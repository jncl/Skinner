local _, aObj = ...
if not aObj:isAddonEnabled("MoveAnything") then return end
local _G = _G

aObj.addonsToSkin.MoveAnything = function(self) -- v 18.0.3

	local function skinPortDialog()
		if not _G.MAPortDialog.sf then
			aObj:skinDropDown{obj=_G.MAPortDialogProfile}
			aObj:skinEditBox{obj=_G.MAPortDialogTextEdit, regs={6}} -- 6 is text
			aObj:addSkinFrame{obj=_G.MAPortDialog, ft="a", kfs=true, nb=true, y1=2, x2=1}
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.MAPortDialogClose}
				aObj:skinStdButton{obj=_G.MAPortDialogExportButton}
				aObj:SecureHook(_G.MAPortDialogExportButton, "Disable", function(this, _)
					aObj:clrBtnBdr(this)
				end)
				aObj:SecureHook(_G.MAPortDialogExportButton, "Enable", function(this, _)
					aObj:clrBtnBdr(this)
				end)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=_G.MAPortDialogEnabled}
				aObj:skinCheckButton{obj=aObj:getChild(_G.MAPortDialog, 4)} -- Text String check button, has same name as enabled cb
			end
			skinPortDialog = _G.nop
		end
	end
	local function skinMoveFrames()
		local i, frameBD = 1
		while true do
			if not _G["MAMover" .. i] then break end
			aObj:removeBackdrop(_G["MAMover" .. i].background)
			frameBD = _G["MAMover" .. i .. "Backdrop"].background
			frameBD:SetBackdrop(aObj.Backdrop[1])
			frameBD:SetBackdropColor(aObj.bClr:GetRGBA())
			frameBD:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
			i =  i + 1
		end
		i, frameBD = nil, nil
	end
	local function skinFrameEditors()
		local i = 1
		while true do
			if not _G["MA_FE" .. i] then break end
			if not _G["MA_FE" .. i].sf then
				aObj:skinDropDown{obj=_G["MA_FE" .. i .. "Point"]}
				aObj:skinDropDown{obj=_G["MA_FE" .. i .. "RelPoint"]}
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "RelToEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "XEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "YEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "WidthEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "HeightEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "ScaleEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinEditBox{obj=_G["MA_FE" .. i .. "AlphaEdit"], regs={6}, noHeight=true} -- 6 is text
				aObj:skinDropDown{obj=_G["MA_FE" .. i .. "Strata"]}
				-- TODO: skin Sliders
				aObj:addSkinFrame{obj=_G["MA_FE" .. i], ft="a", kfs=true, nb=true, y1=2, x2=1}
				if aObj.modBtns then
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "Close"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "PositionResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "PointResetButton"]} -- pointResetButton
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "RelPointResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "RelToResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "XMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "XPlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "XResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "XZeroButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "YMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "YPlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "YResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "YZeroButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "WidthMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "WidthPlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "WidthResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "HeightMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "HeightPlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "HeightResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ScaleMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ScalePlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ScaleResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ScaleOneButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "AlphaMinusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "AlphaPlusButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "AlphaResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "AlphaFullButton"]}
					 aObj:skinStdButton{obj=aObj:getChild(_G["MA_FE" .. i], 64)} -- layersResetButton, has same name as pointResetButton
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "StrataResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "RevertButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ResetButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ExportButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "SyncButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "MoverButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ShowButton"]}
					 aObj:skinStdButton{obj=_G["MA_FE" .. i .. "ImportButton"]}
					 aObj:SecureHook(_G["MA_FE" .. i], "UpdateButtons", function(this)
						 local fe = this:GetName()
						 aObj:clrBtnBdr(_G[fe .. "ResetButton"])
						 aObj:clrBtnBdr(_G[fe .. "SyncButton"])
						 aObj:clrBtnBdr(_G[fe .. "MoverButton"])
						 aObj:clrBtnBdr(_G[fe .. "ShowButton"])
						 fe = nil
					 end)
				end
				if aObj.modChkBtns then
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "Enabled"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "Hide"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "ClampToScreenButton"]}
					 for j = 1, 13 do
						 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "Group" .. j]}
					 end
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "HideLayerArtwork"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "HideLayerBackground"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "HideLayerBorder"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "HideLayerHighlight"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "HideLayerOverlay"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "UnregAllEventsCheckButton"]}
					 aObj:skinCheckButton{obj=_G["MA_FE" .. i .. "ForcedLockCheckButton"]}
				end
				aObj:SecureHookScript(_G["MA_FE" .. i .. "MoverButton"], "OnClick", function(this)
					skinMoveFrames()
					aObj:Unhook(this, "OnClick")
				end)
				-- hook these to skin PortDialog
				aObj:SecureHookScript(_G["MA_FE" .. i .. "ExportButton"], "OnClick", function(this)
					skinPortDialog()
					aObj:Unhook(this, "OnClick")
				end)
				aObj:SecureHookScript(_G["MA_FE" .. i .. "ImportButton"], "OnClick", function(this)
					skinPortDialog()
					aObj:Unhook(this, "OnClick")
				end)
			end
			i =  i + 1
		end
		i = nil
	end

	if self.modBtns then
		self:skinStdButton{obj=_G.GameMenuButtonMoveAnything}
	end

	-- IOF panel
	self:skinDropDown{obj=_G.MAOptProfileFrame_DropDown, x2=34, y2=-9}
	if self.modBtns then
		self:SecureHook("MovAny_OptionsOnShow", function()
			if _G.MAOptProfileRename.sb then
				self:clrBtnBdr(_G.MAOptProfileRename)
				self:clrBtnBdr(_G.MAOptProfileDelete)
			end
		end)
	end

	-- Options frame
	self:skinSlider{obj=_G.MAScrollFrame.ScrollBar}
	self:removeBackdrop(_G.MAScrollBorder.background)
	self:skinEditBox{obj=_G.MA_Search, regs={6}, noHeight=true} -- 6 is text
	self:removeBackdrop(_G.MAOptions.background)
	self:addSkinFrame{obj=_G.MAOptions, ft="a", kfs=true, nb=true, hdr=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.MAOptionsSync}
		self:skinStdButton{obj=_G.MAOptionsOpenBlizzardOptions}
		self:skinStdButton{obj=_G.MAOptionsClose}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.MAOptionsToggleModifiedFramesOnly}
		self:skinCheckButton{obj=_G.MAOptionsToggleCategories}
		self:skinCheckButton{obj=_G.MAOptionsToggleFrameStack}
		self:skinCheckButton{obj=_G.MAOptionsToggleMovers}
		self:skinCheckButton{obj=_G.MAOptionsToggleFrameEditors}
	end
	-- category buttons
	local i = 1
	while true do
		if not _G["MAMove" .. i] then break end
		self:removeBackdrop(_G["MAMove" .. i .. "Backdrop"].background)
		if self.modBtns then
			self:skinStdButton{obj=_G["MAMove" .. i .. "Reset"]}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G["MAMove" .. i .. "Move"]}
			self:skinCheckButton{obj=_G["MAMove" .. i .. "Hide"]}
		end
		-- hook this to skin FrameEditor frames
		self:SecureHookScript(_G["MAMove" .. i .. "FrameName"], "OnMouseUp", function(this)
			skinFrameEditors()
		end)
		-- hook this to skin Move frames
		self:SecureHookScript(_G["MAMove" .. i .. "Move"], "OnClick", function(this)
			skinMoveFrames()
		end)
		i = i + 1
	end
	i = nil
	-- hook these to skin PortDialog
	self:SecureHookScript(_G.MAOptExportProfile, "OnClick", function(this)
		skinPortDialog()
		self:Unhook(_G.MAOptExportProfile, "OnClick")
	end)
	self:SecureHookScript(_G.MAOptImportProfile, "OnClick", function(this)
		skinPortDialog()
		self:Unhook(_G.MAOptImportProfile, "OnClick")
	end)

	-- Nudger frame
	self:removeBackdrop(_G.MANudger.background)
	self:addSkinFrame{obj=_G.MANudger, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.MANudger_NudgeUp}
		self:skinStdButton{obj=_G.MANudger_CenterMe}
		self:skinStdButton{obj=_G.MANudger_NudgeDown}
		self:skinStdButton{obj=_G.MANudger_NudgeLeft}
		self:skinStdButton{obj=_G.MANudger_NudgeRight}
		self:skinStdButton{obj=_G.MANudger_CenterH}
		self:skinStdButton{obj=_G.MANudger_CenterV}
		self:skinStdButton{obj=_G.MANudger_Detach}
		self:skinStdButton{obj=_G.MANudger_Hide}
		self:skinStdButton{obj=_G.MANudger_MoverPlus}
		self:skinStdButton{obj=_G.MANudger_MoverMinus}
	end

end
