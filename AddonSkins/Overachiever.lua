local _, aObj = ...
if not aObj:isAddonEnabled("Overachiever") then return end
local _G = _G

aObj.addonsToSkin.Overachiever = function(self) -- v 1.2.3/1.2.6 Wrath
	if not self.db.profile.AchievementUI then return end

	--- Options
	local function skinKids(panel)
		if panel.TjOpt_tab.scrolling then
			aObj:skinObject("slider", {obj=panel.TjOpt_scrollchild:GetParent().ScrollBar})
		end
		for i = 1, #panel.TjOpt_tab.items do
			local itm = _G[panel.TjOpt_tab.items[i].name]
			if itm then
				if itm.TjDDM then
					aObj:skinObject("dropdown", {obj=itm, x2=26, adjBtnX=true})
				elseif itm:IsObjectType("CheckButton") then
					aObj:skinCheckButton{obj=itm}
				end
			end
		end
	end
	local pCnt = 0
	self.RegisterMessage("Overachiever", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name == "Overachiever"
		or panel.parent == "Overachiever"
		and not self.iofSkinnedPanels[panel]
		then
			skinKids(panel)
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end
		if pCnt == 2 then
			self.UnregisterMessage("Overachiever", "IOFPanel_Before_Skinning")
		end
	end)

end

aObj.lodAddons.Overachiever_Tabs = function(self) -- v 1.2.3/1.2.6 Wrath
	if not self.db.profile.AchievementUI then return end

	-- ensure extra tabs are full width
	self:checkShown(_G.AchievementFrame)

	-- this function copied from AchievementsFrame skin in PlayerFrames
	local function cleanButtons(frame)
		for _, btn in _G.pairs(frame.buttons) do
			if btn.NineSlice then
				aObj:removeNineSlice(btn.NineSlice)
			end
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			btn:DisableDrawLayer("ARTWORK")
			if btn.hiddenDescription then
				btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB())
			end
			aObj:nilTexture(btn.icon.frame, true)
			aObj:secureHook(btn, "Desaturate", function(bObj)
				if bObj.sbb then
					bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
				end
			end)
			aObj:secureHook(btn, "Saturate", function(bObj)
				if bObj.sbb then
					bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
				end
				if bObj.description then
					bObj.description:SetTextColor(aObj.BT:GetRGB())
				end
			end)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.icon, relTo=btn.texture, x1=3, y1=0, x2=-3, y2=6}
				aObj:addButtonBorder{obj=btn, ofs=0}
			end
			if aObj.modChkBtns
			and btn.tracked
			then
				aObj:skinCheckButton{obj=btn.tracked}
			end
		end
	end

	if _G.Overachiever_SearchFrame then
		self:SecureHookScript(_G.Overachiever_SearchFrame, "OnShow", function(this)
			self:keepFontStrings(self:getChild(this, 1)) -- borderframe
			self:skinObject("dropdown", {obj=_G.Overachiever_SearchFrameSortDrop, x2=26, adjBtnX=true})
			self:skinObject("editbox", {obj=_G.Overachiever_SearchFrameNameEdit, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.Overachiever_SearchFrameDescEdit, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.Overachiever_SearchFrameCriteriaEdit, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.Overachiever_SearchFrameRewardEdit, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.Overachiever_SearchFrameAnyEdit, y1=4, y2=-4})
			self:skinObject("dropdown", {obj=_G.Overachiever_SearchFrameTypeDrop, x2=26, adjBtnX=true})
			self:skinObject("slider", {obj=this.scrollbar})
			self:skinObject("frame", {obj=this, kfs=true, y1=0})
			if self.modBtns then
				self:skinStdButton{obj=self:getPenultimateChild(this.panel)}
				self:skinStdButton{obj=self:getLastChild(this.panel)}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.Overachiever_SearchFrameFullListCheckbox}
			end
			cleanButtons(this.scrollFrame)

			self:Unhook(this, "OnShow")
		end)
	end

	if _G.Overachiever_SuggestionsFrame then
		self:SecureHookScript(_G.Overachiever_SuggestionsFrame, "OnShow", function(this)
			self:keepFontStrings(self:getChild(_G.Overachiever_SuggestionsFrame, 1)) -- borderframe
			self:skinObject("dropdown", {obj=_G.Overachiever_SuggestionsFrameSortDrop, x2=26, adjBtnX=true})
			self:skinObject("editbox", {obj=_G.Overachiever_SuggestionsFrameZoneOverrideEdit, y1=4, y2=-4})
			self:skinObject("dropdown", {obj=_G.Overachiever_SuggestionsFrameSubzoneDrop, x2=26, adjBtnX=true})
			self:skinObject("dropdown", {obj=_G.Overachiever_SuggestionsFrameDiffDrop, x2=26, adjBtnX=true})
			self:skinObject("dropdown", {obj=_G.Overachiever_SuggestionsFrameRaidSizeDrop, x2=26, adjBtnX=true})
			self:skinObject("slider", {obj=_G.Overachiever_SuggestionsFrame.scrollbar})
			self:skinObject("frame", {obj=_G.Overachiever_SuggestionsFrame, kfs=true, y1=0})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(_G.Overachiever_SuggestionsFrame.panel, 2)}
				self:skinStdButton{obj=self:getLastChild(_G.Overachiever_SuggestionsFrame.panel)}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.Overachiever_SuggestionsFrameShowHiddenCheckbox}
			end
			cleanButtons(_G.Overachiever_SuggestionsFrame.scrollFrame)

			self:Unhook(this, "OnShow")
		end)
	end

	if _G.Overachiever_WatchFrame then
		self:SecureHookScript(_G.Overachiever_WatchFrame, "OnShow", function(this)
			self:keepFontStrings(self:getChild(_G.Overachiever_WatchFrame, 1)) -- borderframe
			self:skinObject("dropdown", {obj=_G.Overachiever_WatchFrameSortDrop, x2=26, adjBtnX=true})
			self:skinObject("dropdown", {obj=_G.Overachiever_WatchFrameListDrop, x2=26, adjBtnX=true})
			self:skinObject("dropdown", {obj=_G.Overachiever_WatchFrameDefListDrop, x2=26, adjBtnX=true})
			self:skinObject("dropdown", {obj=_G.Overachiever_WatchFrameDestinationListDrop, x2=26, adjBtnX=true})
			self:skinObject("slider", {obj=_G.Overachiever_WatchFrame.scrollbar})
			self:skinObject("frame", {obj=_G.Overachiever_WatchFrame, kfs=true, y1=0})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(_G.Overachiever_WatchFrame.panel, 3)}
				self:skinStdButton{obj=self:getChild(_G.Overachiever_WatchFrame.panel, 4)}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.Overachiever_WatchFrameCopyDestCheckbox}
			end
			cleanButtons(_G.Overachiever_WatchFrame.scrollFrame)

			self:Unhook(this, "OnShow")
		end)
	end

end
