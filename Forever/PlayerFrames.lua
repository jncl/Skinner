local _, aObj = ...

local _G = _G

aObj.SetupForever_PlayerFrames = function()
	local ftype = "p"

	aObj.blizzLoDFrames[ftype].LegacySystem = function(self)
		if not self.prdb.LegacySystem or self.initialized.LegacySystem then return end

		if not _G.LegacySystemFrame then
			_G.RunNextFrame(function()
			    self.blizzLoDFrames[ftype].LegacySystem(self)
			end)
			return
		end

		self.initialized.LegacySystem = true

		self:SecureHookScript(_G.LegacySystemFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("sidetabs", {obj=this, tabs="Tabs", fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

			self:SecureHookScript(this.RewardTrackPage, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				fObj.Icon:SetTexture(nil)
				fObj.ProgressBarBackground:SetTexture(nil)
				fObj.LegacyRewardProgressBar.ProgressBarFrame:SetTexture(nil)
				self:skinObject("statusbar", {obj=fObj.LegacyRewardProgressBar, fType=ftype, fi=0})

				self:SecureHookScript(fObj.LegacyRewardProgressFrame, "OnShow", function(frame)

					for element in frame.elementPool:EnumerateActive() do
						element.RewardCardBG:SetAlpha(0)
						element.IconBorder:SetAlpha(0)
						self:changeTandC(element.LevelSquare, self.lvlBG, true)
						self:skinObject("frame", {obj=element, fType=ftype, fb=true, ofs=-6, clr="sepia"})
						if self.modBtnBs then
							self:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="sepia"}
						end
					end

					-- .ParagonLevelFrame
						-- .Divider
						-- .LabelBackground
						-- .IconBorder
					-- .LeftButton
					-- .JumpLeftButton
					-- .RightButton
					-- .JumpRightButton

					self:Unhook(fObj.LegacyRewardProgressFrame, "OnShow")
				end)
				self:checkShown(fObj.LegacyRewardProgressFrame)

				self:Unhook(this.RewardTrackPage, "OnShow")
			end)
			self:checkShown(this.RewardTrackPage)

			self:SecureHookScript(this.ChallengesPage, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				fObj.VerticalDivider:DisableDrawLayer("BACKGROUND")
				self:SecureHookScript(fObj.CategoryList, "OnShow", function(frame)
					self:skinObject("ddbutton", {obj=frame.FilterDropdown, fType=ftype, filter=true, clr="sepia"})
					self:skinObject("editbox", {obj=frame.SearchBox, fType=ftype, si=true})
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinList(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						else
							_, element, _ = ...
						end
						aObj:keepFontStrings(element)
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinList, aObj, true)

					self:Unhook(fObj.CategoryList, "OnShow")
				end)
				self:checkShown(fObj.CategoryList)

				self:SecureHookScript(fObj.DetailPane, "OnShow", function(frame)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinDetail(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						else
							_, element, _ = ...
						end
						element.Icon.frame:SetTexture(nil)
						element.Shield.Icon:SetTexture(nil)
						element.Shield.CheckBackground:SetTexture(nil)
						aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, fb=true, clr="sepia"})
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Icon, fType=ftype, relTo=element.Icon.texture, clr="sepia"}
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinDetail, aObj, true)

					self:Unhook(fObj.DetailPane, "OnShow")
				end)
				self:checkShown(fObj.DetailPane)

				self:SecureHookScript(fObj.LegacyChallengePointSummary, "OnShow", function(frame)
					frame.ProgressBarBackground:SetTexture(nil)
					frame.PointsBar.ProgressBarFrame:SetTexture(nil)
					self:changeTandC(frame.Shield.Icon, self.lvlBG)
					self:skinObject("statusbar", {obj=frame.PointsBar, fType=ftype, fi=0})

					self:Unhook(fObj.LegacyChallengePointSummary, "OnShow")
				end)
				self:checkShown(fObj.LegacyChallengePointSummary)

				self:Unhook(this.ChallengesPage, "OnShow")
			end)
			self:checkShown(this.ChallengesPage)

			self:SecureHookScript(this.TreePage, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				fObj.VerticalDivider:DisableDrawLayer("BACKGROUND")

				-- on LHS
				for _, btn in _G.pairs(fObj.LegacyTreeSelectionPanel.treeButtons) do
					btn.Background:SetTexture(nil)
					self:skinObject("frame", {obj=btn, fType=ftype, fb=true, ofs=10, x1=-34, x2=32, clr="sepia"})
					btn.Ring:SetTexture(nil)
					btn.CircleMask:SetShown(false)
					self:makeIconSquare(btn, "NormalTexture", "sepia", {btn.New})
				end

				self:SecureHookScript(fObj.LegacyTreePointSummary, "OnShow", function(frame)
					frame.Border:SetTexture(nil)
					self:changeTandC(frame.Shield.Icon, self.lvlBG)

					self:Unhook(fObj.LegacyTreePointSummary, "OnShow")
				end)
				self:checkShown(fObj.LegacyTreePointSummary)

				self:SecureHookScript(fObj.LegacyTreeTraitPanel, "OnShow", function(frame)
					self:skinObject("editbox", {obj=frame.SearchBox, fType =ftype, si=true, y1=-4, y2=4})
					self:skinSearchPreviewContainer(frame.SearchPreviewContainer)
					frame.SelectedTreeIcon.Ring:SetTexture(nil)
					frame.SelectedTreeIcon.CircleMask:SetShown(false)
					self:makeIconSquare(frame.SelectedTreeIcon, "NormalTexture", "sepia", {frame.SelectedTreeIcon.New})
					frame.SpentPointsFrame.Background:SetTexture(nil)

					if self.modBtns then
						self:skinStdButton{obj=frame.ApplyButton, fType=ftype, schk=true, ofs=1, y1=2}
					end

					-- TODO: skin Trait buttons .ButtonsParent children

					self:Unhook(fObj.LegacyTreeTraitPanel, "OnShow")
				end)
				self:checkShown(fObj.LegacyTreeTraitPanel)

				self:Unhook(this.TreePage, "OnShow")
			end)
			self:checkShown(this.TreePage)

			self:SecureHookScript(_G.LegacyChallengeObjectives, "OnShow", function(fObj)
				self:SecureHook(fObj, "Display", function(frame, id, width)
					for criteria in frame.criteriaPool:EnumerateActive() do
						criteria.Background:SetTexture(nil)
						criteria.ProgressBarBackground:SetTexture(nil)
						criteria.ProgressBar.ProgressBarFrame:SetTexture(nil)
						self:skinObject("statusbar", {obj=criteria.ProgressBar, fType=ftype, fi=0})
					end
				end)

				self:Unhook(_G.LegacyChallengeObjectives, "OnShow")
			end)
			self:checkShown(_G.LegacyChallengeObjectives)

			self:Unhook(_G.LegacySystemFrame, "OnShow")
		end)
		self:checkShown(_G.LegacySystemFrame)

	end

end

aObj.SetupForever_PlayerFramesOptions = function(self)

	local optTab = {
		["Legacy System"] = true,
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end

aObj.SetupForever_PlayerFramesDefaults = function(_)

end
