local _, aObj = ...
if not aObj:isAddonEnabled("ItemRack") then return end
local _G = _G

aObj.addonsToSkin.ItemRack = function(self) -- v 3.69

	if self.modBtnBs then
		self:SecureHook(_G.ItemRack, "BuildMenu", function(_, _, _)
			for key, _ in _G.ipairs(_G.ItemRack.Menu) do
				self:addButtonBorder{obj=_G["ItemRackMenu" .. key], abt=true, clr="grey"}
			end
		end)
	end

end

aObj.lodAddons.ItemRackOptions = function(self)

	self:SecureHookScript(_G.ItemRackOptFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix="ItemRackOpt", numTabs=4, ignoreSize=true, lod=self.isTT and true, regions={3}, offsets={x1=0, y1=0, x2=0, y2=0}, track=false})
		if self.isTT then
			self:SecureHook(_G.ItemRackOpt, "TabOnClick", function(tObj, _)
				for i = 1, 4 do
					self:setInactiveTab(_G["ItemRackOptTab" .. i].sf)
				end
				self:setActiveTab(tObj.sf)
			end)
		end
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ItemRackOptClose}
			for i = 0, 19 do
				self:addButtonBorder{obj=_G["ItemRackOptInv" .. i], abt=true, clr="grey"}
			end
			self:addButtonBorder{obj=_G.ItemRackOptToggleInvAll, clr="grey"}
		end

		-- Options frame
		self:SecureHookScript(_G.ItemRackOptSubFrame1, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptButtonSpacingSlider})
			self:skinObject("slider", {obj=_G.ItemRackOptAlphaSlider})
			self:skinObject("slider", {obj=_G.ItemRackOptMainScaleSlider})
			self:skinObject("slider", {obj=_G.ItemRackOptMenuScaleSlider})
			self:skinObject("editbox", {obj=_G.ItemRackOptButtonSpacing})
			self:skinObject("editbox", {obj=_G.ItemRackOptAlpha})
			self:skinObject("editbox", {obj=_G.ItemRackOptMainScale})
			self:skinObject("editbox", {obj=_G.ItemRackOptMenuScale})
			self:skinObject("slider", {obj=_G.ItemRackOptSetMenuWrapValueSlider})
			self:skinObject("editbox", {obj=_G.ItemRackOptSetMenuWrapValue})
			self:skinObject("slider", {obj=_G.ItemRackOptListScrollFrame.ScrollBar, rpTex="background"})
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptKeyBindings}
				self:skinStdButton{obj=_G.ItemRackOptResetBar}
				self:skinStdButton{obj=_G.ItemRackOptResetEvents}
				self:skinStdButton{obj=_G.ItemRackOptResetEverything}
			end
			if self.modChkBtns then
				for i = 1, 11 do
					self:skinCheckButton{obj=_G["ItemRackOptList" .. i .. "CheckButton"]}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ItemRackOptSubFrame1)

		-- Sets frame
		self:SecureHookScript(_G.ItemRackOptSubFrame2, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:removeRegions(fObj, {3, 4, 5})
			self:skinObject("editbox", {obj=_G.ItemRackOptSetsName})
			_G.ItemRackOptSetsIconFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptSetsIconScrollFrame.ScrollBar})
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptSetsSaveButton}
				self:skinStdButton{obj=_G.ItemRackOptSetsBindButton}
				self:skinStdButton{obj=_G.ItemRackOptSetsDeleteButton}
				self:SecureHook(_G.ItemRackOpt, "ValidateSetButtons", function()
					self:clrBtnBdr(_G.ItemRackOptSetsSaveButton)
					self:clrBtnBdr(_G.ItemRackOptSetsBindButton)
					self:clrBtnBdr(_G.ItemRackOptSetsDeleteButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ItemRackOptSetsDropDownButton, clr="grey"}
				for i = 1, 25 do
					self:addButtonBorder{obj=_G["ItemRackOptSetsIcon" .. i], clr="grey"}
				end
				self:addButtonBorder{obj=_G.ItemRackOptSetsCurrentSet, abt=true, ofs=2, clr="grey"}
			end
			if self.modChkBtns then
				_G.ItemRackOptShowHelm:SetSize(20, 20)
				_G.ItemRackOptShowCloak:SetSize(20, 20)
				self:moveObject{obj=_G.ItemRackOptShowHelm, x=-6}
				self:skinCheckButton{obj=_G.ItemRackOptShowHelm}
				self:skinCheckButton{obj=_G.ItemRackOptShowCloak}
				self:skinCheckButton{obj=_G.ItemRackOptSetsHideCheckButton}
			end

			self:Unhook(fObj, "OnShow")
		end)

		-- Events frame
		self:SecureHookScript(_G.ItemRackOptSubFrame3, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			_G.ItemRackOptEventListFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptEventListScrollFrame.ScrollBar, rpTex="background"})
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptEventEdit}
				self:skinStdButton{obj=_G.ItemRackOptEventDelete}
				self:skinStdButton{obj=_G.ItemRackOptEventNew}
				self:SecureHook(_G.ItemRackOpt, "ValidateEventListButtons", function()
					self:clrBtnBdr(_G.ItemRackOptEventEdit)
					self:clrBtnBdr(_G.ItemRackOptEventDelete)
				end)
			end
			if self.modChkBtns then
				for i = 1, 9 do
					self:skinCheckButton{obj=_G["ItemRackOptEventList" .. i .. "Enabled"]}
				end

			end

			self:Unhook(fObj, "OnShow")
		end)

		-- Queues frame
		self:SecureHookScript(_G.ItemRackOptSubFrame4, "OnShow", function(fObj)
			self:getRegion(fObj, 2):SetDrawLayer("artwork")
			fObj:DisableDrawLayer("BACKGROUND")

			self:Unhook(fObj, "OnShow")
		end)

		-- Pick sets frame
		self:SecureHookScript(_G.ItemRackOptSubFrame5, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:getChild(this, 1):DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptSetListScrollFrame.ScrollBar})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ItemRackOptSetListClose, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ItemRackOptBindFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptBindCancel}
				self:skinStdButton{obj=_G.ItemRackOptBindUnbind}
			end

			self:Unhook(fObj, "OnShow")
		end)

		-- Config Slot Key Bindings frame
		self:SecureHookScript(_G.ItemRackOptSubFrame6, "OnShow", function(fObj)
			self:getRegion(fObj, 2):SetDrawLayer("artwork")
			fObj:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptSlotBindCancel}
			end

			self:Unhook(fObj, "OnShow")
		end)

		-- Queue Slot options frame
		self:SecureHookScript(_G.ItemRackOptSubFrame7, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:getChild(fObj, 2):DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptSortListScrollFrame.ScrollBar})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ItemRackOptSortListClose, clr="grey"}
				self:addButtonBorder{obj=_G.ItemRackOptSortMoveTop, clr="grey"}
				self:addButtonBorder{obj=_G.ItemRackOptSortMoveUp, clr="grey"}
				self:addButtonBorder{obj=_G.ItemRackOptSortMoveDown, clr="grey"}
				self:addButtonBorder{obj=_G.ItemRackOptSortMoveBottom, clr="grey"}
				self:addButtonBorder{obj=_G.ItemRackOptSortMoveDelete, clr="grey"}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ItemRackOptQueueEnable}
			end

			self:SecureHookScript(_G.ItemRackOptItemStatsFrame, "OnShow", function(fObj2)
				self:skinObject("editbox", {obj=_G.ItemRackOptItemStatsDelay, inset=2, y1=-1, x2=4 ,y2=1})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.ItemRackOptItemStatsPriority}
					self:skinCheckButton{obj=_G.ItemRackOptItemStatsKeepEquipped}
				end

				self:Unhook(fObj2, "OnShow")
			end)

			self:Unhook(fObj, "OnShow")
		end)
		-- hook this to hide ItemRackOptToggleInvAll button
		self:SecureHook(_G.ItemRackOpt, "SetupQueue", function(_)
			_G.ItemRackOptToggleInvAll:Hide()

		end)

		-- New Event setup frame
		self:SecureHookScript(_G.ItemRackOptSubFrame8, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=_G.ItemRackOptEventEditNameEdit})
			_G.ItemRackOptEventEditTypeDrop:DisableDrawLayer("BACKGROUND")
			_G.ItemRackOptEventEditPickTypeFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=_G.ItemRackOptEventEditBuffName})
			self:skinObject("editbox", {obj=_G.ItemRackOptEventEditStanceName})
			self:skinObject("slider", {obj=_G.ItemRackOptEventEditZoneEditScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=_G.ItemRackOptEventEditZoneEditScrollFrame, fb=true, ofs=6, x2=26, clr="grey"})
			_G.ItemRackOptEventEditZoneEditBackdrop:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=_G.ItemRackOptEventEditScriptTrigger})
			_G.ItemRackOptEventEditScriptEditBackdrop:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ItemRackOptEventEditScriptEditScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=_G.ItemRackOptEventEditScriptEditScrollFrame, fb=true, ofs=6, x2=26, clr="grey"})
			if self.modBtns then
				self:skinStdButton{obj=_G.ItemRackOptEventEditSave}
				self:skinStdButton{obj=_G.ItemRackOptEventEditCancel}
				self:skinStdButton{obj=_G.ItemRackOptEventEditExpand}
				self:SecureHook(_G.ItemRackOptEventEditSave, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(_G.ItemRackOptEventEditSave, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(_G.ItemRackOptEventEditCancel, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(_G.ItemRackOptEventEditCancel, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ItemRackOptEventEditTypeDropButton, clr="grey"}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ItemRackOptEventEditBuffAnyMount}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditBuffNotInPVP}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditBuffNotInPVE}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditBuffUnequip}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditStanceNotInPVP}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditStanceUnequip}
				self:skinCheckButton{obj=_G.ItemRackOptEventEditZoneUnequip}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ItemRackFloatingEditor, "OnShow", function(this)
		self:removeBackdrop(_G.ItemRackFloatingEditorEditFrame)
		self:skinObject("slider", {obj=_G.ItemRackFloatingEditorScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=this})
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemRackFloatingEditorSave}
			self:skinStdButton{obj=_G.ItemRackFloatingEditorTest}
			self:skinStdButton{obj=_G.ItemRackFloatingEditorUndo}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ItemRackFloatingEditorClose, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

end
