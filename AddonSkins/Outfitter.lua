-- luacheck: ignore 631 (line is too long)
local _, aObj = ...
if not aObj:isAddonEnabled("Outfitter") then return end
local _G = _G

aObj.addonsToSkin.Outfitter = function(self) -- v 10.2.7.0

	self:SecureHook(_G.Outfitter, "PlayerEnteringWorld", function(this)
		local function skinOutfitBars(fObj)
			if not fObj.Bars then return end
			for _, bar in _G.pairs(fObj.Bars) do
				bar:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=bar, kfs=true, ofs=-1, y1=2})
				bar.sf:SetShown(not _G.Outfitter.Settings.OutfitBar.HideBackground)
				for _, btn in _G.pairs(bar.Buttons) do
					btn:GetNormalTexture():SetTexture(nil)
					-- N.B. NOT adding button borders to the outfit buttons
				end
			end
			-- N.B. NOT skinning the drag bars
		end
		_G.C_Timer.After(0.1, function()
			skinOutfitBars(_G.Outfitter.OutfitBar)
		end)
		self:SecureHook(_G.Outfitter.OutfitBar, "ShowBackground", function(fObj, showBG)
			for _, bar in _G.pairs(fObj.Bars) do
				bar.sf:SetShown(showBG)
			end
		end)
		self:SecureHook(_G.Outfitter.OutfitBar, "UpdateBar", function(fObj, _)
			skinOutfitBars(fObj)
		end)
		self:SecureHook(_G.Outfitter.OutfitBar, "DragBar_OnClick", function(_)
			local obsd = _G.OutfitBarSettingsDialog
			if obsd then
				self:skinObject("slider", {obj=obsd.SizeSlider})
				self:skinObject("slider", {obj=obsd.AlphaSlider})
				self:skinObject("slider", {obj=obsd.CombatAlphaSlider})
				self:skinObject("frame", {obj=obsd})
				if self.modChkBtns then
					self:skinCheckButton{obj=obsd.VerticalCheckbutton}
					self:skinCheckButton{obj=obsd.LockPositionCheckbutton}
					self:skinCheckButton{obj=obsd.HideBackgroundCheckbutton}
				end

				self:Unhook(_G.Outfitter.OutfitBar, "DragBar_OnClick")
			end
		end)

		-- hook this to skin additional Shopping tooltips
		if self.db.profile.Tooltips.skin then
			self:SecureHook(_G.Outfitter._ExtendedCompareTooltip, "AddShoppingLink", function(fObj, _)
				for _, tTip in _G.pairs(fObj.Tooltips) do
					if not _G.rawget(self.ttList, tTip) then
						self:add2Table(self.ttList, tTip)
					end
				end
			end)
		end

		self:SecureHookScript(_G.OutfitterFrame, "OnShow", function(fObj)
			_G.OutfitterMainFrame:DisableDrawLayer("BACKGROUND")
			_G.OutfitterMainFrameScrollbarTrench:DisableDrawLayer("OVERLAY")
			self:skinObject("slider", {obj=_G.OutfitterMainFrameScrollFrame.ScrollBar})
			self:skinObject("tabs", {obj=fObj, prefix=fObj:GetName(), numTabs=3, lod=true, offsets={x1=8, y1=0, x2=-8, y2=2}})
			self:skinObject("frame", {obj=fObj, kfs=true, x1=-1, y2=-6})
			if self.modBtns then
				self:skinCloseButton{obj=_G.OutfitterCloseButton}
				self:skinStdButton{obj=_G.OutfitterNewButton}
				local btn
				for i = 0, _G.Outfitter.cMaxDisplayedItems - 1 do
					btn = _G["OutfitterItem" .. i .. "CategoryExpand"]
					self:skinExpandButton{obj=btn, onSB=true}
				end
			end
			if self.modChkBtns then
				for i = 0, _G.Outfitter.cMaxDisplayedItems - 1 do
					self:skinCheckButton{obj=_G["OutfitterItem" .. i .. "OutfitSelected"]}
				end
				self:skinCheckButton{obj=_G.OutfitterAutoSwitch}
				self:skinCheckButton{obj=_G.OutfitterShowOutfitBar}
				self:skinCheckButton{obj=_G.OutfitterShowMinimapButton}
				self:skinCheckButton{obj=_G.OutfitterShowHotkeyMessages}
				self:skinCheckButton{obj=_G.OutfitterTooltipInfo}
				self:skinCheckButton{obj=_G.OutfitterItemComparisons}
			end

			self:Unhook(fObj, "OnShow")
		end)
		-- hook this to ignore original function's frame level change
		self:RawHook(_G.Outfitter, "OnShow", function(fObj)
			fObj:ShowPanel(1)
		end, true)

		-- skin objects added to the PaperDollFrame
		if self.modBtns then
			self:adjHeight{obj=_G.OutfitterEnableAll, adj=2}
			self:skinStdButton{obj=_G.OutfitterEnableAll}
			self:adjHeight{obj=_G.OutfitterEnableNone, adj=2}
			self:skinStdButton{obj=_G.OutfitterEnableNone}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.OutfitterButton, x1=9, y1=-2, x2=-10, y2=2}
		end
		if self.modChkBtns then
			for _, slotName in _G.pairs(_G.Outfitter.cSlotNames) do
				self:skinCheckButton{obj=_G["OutfitterEnable" .. slotName]}
			end
		end

		local function skinMultiStats(obj)
			for _, cLine in _G.pairs(obj.ConfigLines) do
				if not cLine.StatMenu.sf then
					aObj:skinObject("dropdown", {obj=cLine.StatMenu, regions={2, 3, 4}, x1=-7, y1=0, x2=1, y2=0})
					aObj:skinObject("dropdown", {obj=cLine.OpMenu, regions={2, 3, 4}, x1=-7, y1=0, x2=1, y2=0})
					if cLine.DeleteButton
					and aObj.modBtns
					then
						aObj:skinStdButton{obj=cLine.DeleteButton}
					end
				end
			end
		end
		local function skinMultiStatsFrame(frame)
			skinMultiStats(frame)
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.AddStatButton}
			end
			aObj:SecureHook(frame, "SetNumConfigLines", function(fObj, _)
				skinMultiStats(fObj)
			end)
		end

		self:SecureHook(_G.Outfitter, "CreateNewOutfit", function(fObj)
			local frame = fObj.NameOutfitDialog
			self:skinObject("editbox", {obj=frame.Name})
			self:skinObject("dropdown", {obj=frame.ScriptMenu, regions={2, 3, 4}, x1=-7, y1=0, x2=1, y2=0})
			self:skinObject("frame", {obj=frame.InfoSection, fb=true})
			-- Build
			self:skinObject("frame", {obj=frame.BuildSection, fb=true})
			if self.modChkBtns then
				self:skinCheckButton{obj=frame.EmptyOutfitCheckButton, ofs=-1, yOfs=1}
				self:skinCheckButton{obj=frame.ExistingOutfitCheckButton, ofs=-1, yOfs=1}
				self:skinCheckButton{obj=frame.GenerateOutfitCheckButton, ofs=-1, yOfs=1}
			end
			self:skinObject("frame", {obj=frame.StatsSection, fb=true})
			skinMultiStatsFrame(frame.MultiStatConfig)
			self:moveObject{obj=frame.Title, y=-6}
			frame.TitleBackground:SetTexture(nil)
			self:skinObject("frame", {obj=frame, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=frame.CancelButton}
				self:skinStdButton{obj=frame.DoneButton}
				self:SecureHook(frame, "Update", function(fObj2, _)
					self:clrBtnBdr(fObj2.DoneButton)
				end)
			end

			self:Unhook(fObj, "CreateNewOutfit")
		end)

		self:SecureHook(_G.Outfitter, "OpenRebuildOutfitDialog", function(fObj, _)
			local frame = fObj.RebuildOutfitDialog
			self:skinObject("frame", {obj=frame.StatsSection, fb=true})
			skinMultiStatsFrame(frame.MultiStatConfig)

			self:moveObject{obj=frame.Title, y=-6}
			frame.TitleBackground:SetTexture(nil)
			self:skinObject("frame", {obj=frame, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=frame.CancelButton}
				self:skinStdButton{obj=frame.DoneButton}
				self:SecureHook(frame, "Update", function(fObj2, _)
					self:clrBtnBdr(fObj2.DoneButton)
				end)
			end

			self:Unhook(fObj, "OpenRebuildOutfitDialog")
		end)

		self:SecureHookScript(_G.OutfitterEditScriptDialog, "OnShow", function(fObj)
			self:skinObject("dropdown", {obj=_G.OutfitterEditScriptDialogPresetScript, regions={2, 3, 4}, x1=-7, y1=0, x2=1, y2=0})
			self:skinObject("slider", {obj=_G.OutfitterEditScriptDialogSourceScript.ScrollBar})
			self:skinObject("frame", {obj=_G.OutfitterEditScriptDialogSourceScript, kfs=true, fb=true, ofs=4})
			self:skinObject("tabs", {obj=fObj, prefix=this:GetName(), numTabs=2, lod=true})
			self:skinObject("frame", {obj=fObj, kfs=true, y2=-5})
			if self.modBtns then
				self:skinCloseButton{obj=fObj.CloseButton, x1=-2, y1=2, x2=2, y2=-2}
				self:skinStdButton{obj=_G.OutfitterEditScriptDialogCancelButton}
				self:skinStdButton{obj=_G.OutfitterEditScriptDialogDoneButton}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHook(_G.OutfitterEditScriptDialog, "ConstructSettingsFields", function(fObj, _)
			for type, elem in _G.pairs(fObj.FrameCache) do
				for _, obj in _G.pairs(elem) do
					if type == "ScrollableEditBox" then
						self:skinObject("frame", {obj=obj, kfs=true, fb=true, ofs=4})
						self:skinObject("slider", {obj=obj.ScrollBar})
					elseif type == "EditBox" then
						self:skinObject("editbox", {obj=obj, regions={3, 4, 5, 6, 7, 8, 9, 10, 11}})
					elseif type == "ZoneListEditBox" then
						self:skinObject("frame", {obj=obj, kfs=true, fb=true, ofs=4})
						self:skinObject("slider", {obj=obj.ScrollBar})
						if self.modBtns then
							self:skinStdButton{obj=_G[obj:GetName() .. "ZoneButton"]}
						end
					elseif type == "Checkbox"
					and self.modChkBtns
					then
						self:skinCheckButton{obj=obj}
					end
				end
			end
		end)

		self:SecureHook(_G.Outfitter, "BeginCombiProgress", function(fObj, _)
			local cpd = fObj.CombiProgressDialog
			self:skinStatusBar{obj=cpd.ProgressBar, fi=0}
			self:skinObject("frame", {obj=cpd.ContentFrame})
			if self.modBtns then
				self:skinStdButton{obj=cpd.CancelButton}
			end

			self:Unhook(fObj, "BeginCombiProgress")
		end)

		self:SecureHookScript(_G.OutfitterChooseIconDialog, "OnShow", function(fObj)
			self:skinObject("dropdown", {obj=_G.OutfitterChooseIconDialogIconSetMenu, regions={3, 4, 5}, x1=-7, y1=0, x2=1, y2=0})
			self:skinObject("editbox", {obj=_G.OutfitterChooseIconDialogFilterEditBox, regions={4, 5, 6}})
			self:skinObject("slider", {obj=_G.OutfitterChooseIconDialogScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=fObj, ofs=-10})
			if self.modBtns then
				self:skinStdButton{obj=_G.OutfitterChooseIconDialogCancelButton}
				self:skinStdButton{obj=_G.OutfitterChooseIconDialogOKButton}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "PlayerEnteringWorld")
	end)

end
