local _, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

aObj.addonsToSkin["Classic Quest Log"] = function(self)

	local v1, _, _ = _G.GetAddOnMetadata("Classic Quest Log","Version"):match("^(%d+)%.(%d+)%.(%d+)")
	v1 = _G.tonumber(v1)

	if v1 == 2 then -- v 2.3.12
		self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.log:DisableDrawLayer("BACKGROUND")
			this.log:DisableDrawLayer("BORDER")
			this.log.expandAll:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=this.log.scrollBar, rpTex="background"})
			this.detail:DisableDrawLayer("ARTWORK")
			self:skinObject("scrollbar", {obj=this.detail.ScrollBar})
			this.detail.DetailBG:SetTexture(nil)
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, y1=2, x2=3})
		    if self.modBtns then
				self:skinExpandButton{obj=this.log.expandAll, onSB=true}
				-- TODO: skin expand texture
		        -- for _, btn in _G.pairs(this.log.buttons) do
		        --     self:skinExpandButton{obj=btn, onSB=true}
		        -- end
		        -- local function qlUpd(fObj)
		        --     if _G.InCombatLockdown() then
		        --         aObj:add2Table(aObj.oocTab, {qlUpd, {fObj}})
		        --         return
		        --     end
		        --     for _, btn in _G.pairs(fObj.buttons) do
		        --         aObj:checkTex(btn.expand)
		        --     end
		        -- end
		        -- self:SecureHook(this.log, "UpdateLog", function(fObj)
		        --     qlUpd(fObj)
		        -- end)
			end
			self:removeInset(this.chrome.countFrame)
			if self.modBtns then
				self:skinStdButton{obj=this.chrome.abandonButton}
				self:skinStdButton{obj=this.chrome.pushButton}
				self:skinStdButton{obj=this.chrome.trackButton}
				self:skinStdButton{obj=this.chrome.closeButton}
				self:skinStdButton{obj=this.chrome.optionsButton}
				self:skinStdButton{obj=this.chrome.syncButton}
				self:SecureHook(this.chrome, "Update", function(fObj)
					self:clrBtnBdr(fObj.abandonButton)
					self:clrBtnBdr(fObj.pushButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.chrome.mapButton, ofs=-2, y1=0, y2=0, clr="gold"}
			end
			this.options:DisableDrawLayer("BACKGROUND")
			this.options:DisableDrawLayer("BORDER")
			this.options.content.headerBack:SetTexture(nil)
			self:skinObject("slider", {obj=this.options.content.UseCustomScale.ScaleSlider})
			if self.modBtns then
				self:skinCloseButton{obj=this.options.content.close}
			end
			if self.modChkBtns then
				for _, bName in _G.pairs{"LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "ShowFromObjectiveTracker", "DontOverrideBind", "ShowMinimapButton", "UseCustomScale"} do -- luacheck: ignore 631 (line is too long)
					self:skinCheckButton{obj=this.options.content[bName].check}
				end
			end
			self:add2Table(self.ttList, this.campaignTooltip)

			self:Unhook(this, "OnShow")
			if self.modBtns then
				-- Hide then show to update quest buttons textures
				self:checkShown(this)
			end
		end)
	elseif v1 == 3 then -- v 3.0.0-beta-04
		self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
			self:removeInset(this.Chrome.CountFrame)
			if self.modBtns then
				for _, btn in _G.pairs(this.Chrome.PanelButtons) do
					self:skinStdButton{obj=btn, sechk=true}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Chrome.MapButton, ofs=-2, y1=0, y2=0, clr="grey", schk=true}
				self:addButtonBorder{obj=this.Chrome.OptionsButton, ofs=0, x1=1, x2=2, clr="grey"}
			end
			self:removeInset(this.Log)
			self:skinObject("scrollbar", {obj=this.Log.ScrollFrame.ScrollBar})
			this.Log.ScrollFrame.AllButton:DisableDrawLayer("BACKGROUND")
		    if self.modBtns then
				self:skinExpandButton{obj=this.Log.ScrollFrame.AllButton, onSB=true}
				-- TODO: skin expand texture
			end
			self:add2Table(self.ttList, this.Log.CampaignTooltip)
			self:removeInset(this.Detail)
			self:skinObject("scrollbar", {obj=this.Detail.ScrollFrame.ScrollBar})
			this.Detail.ScrollFrame.Content.TitleHeader:SetTextColor(self.HT:GetRGB())
			this.Detail.ScrollFrame.Content.ObjectivesText:SetTextColor(self.BT:GetRGB())
			this.Detail.ScrollFrame.Content.GroupSize:SetTextColor(self.BT:GetRGB())
			this.Detail.ScrollFrame.Content.DescriptionHeader:SetTextColor(self.HT:GetRGB())
			this.Detail.ScrollFrame.Content.DescriptionText:SetTextColor(self.BT:GetRGB())
			this.Detail.ScrollFrame.Content.StatusTitle:SetTextColor(self.BT:GetRGB())
			this.Detail.ScrollFrame.Content.StatusText:SetTextColor(self.BT:GetRGB())
			--TODO: this.Detail.ScrollFrame.Content.SealFrame
			this.Detail.ScrollFrame.Content.RewardsFrame.Header:SetTextColor(self.HT:GetRGB())
			self:SecureHook(this.Detail, "ShowObjectives", function(fObj, _)
				for _, objective in _G.pairs(fObj.ScrollFrame.Content.ObjectivesFrame.Objectives) do
					objective:SetTextColor(self.BT:GetRGB())
				end
			end)
			self:SecureHook(this.Detail, "ShowSpecialObjectives", function(fObj)
				fObj.ScrollFrame.Content.SpecialObjectivesFrame.SpellObjectiveLearnLabel:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(this.Detail, "ShowRequiredMoney", function(fObj)
				fObj.ScrollFrame.Content.RequiredMoneyFrame.RequiredMoneyText:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(this.Detail, "ShowRewards", function(fObj)
				for _, child in _G.ipairs_reverse{fObj.ScrollFrame.Content.RewardsFrame:GetRegions()} do
					if child.isUsed then
						child:SetTextColor(self.BT:GetRGB())
					end
				end
				for _, child in _G.ipairs_reverse{fObj.ScrollFrame.Content:GetChildren()} do
					if child.isUsed then
						if child.Back then
							child.Back:SetTexture(nil)
						end
						if child.Cosmetic then
							child.Cosmetic:SetTexture(nil)
						end
						if child.NameFrame then
							child.NameFrame:SetTexture(nil)
						end
						if child.SpellBorder then
							child.SpellBorder:SetTexture(nil)
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=child, relTo=child.Icon, reParent={child.Amount}, ofs=4}
							if child.Rarity then
								child.sbb:SetBackdropBorderColor(child.Rarity:GetVertexColor())
								child.Rarity:SetAlpha(0)
							end
						end
					end
				end
			end)
			self:removeInset(this.Options)
			self:skinObject("scrollbar", {obj=this.Options.ScrollFrame.ScrollBar})
			if self.modChkBtns then
				for _, cBtn in _G.pairs(this.Options.ScrollFrame.Content.CheckButtons) do
					-- TODO: skin pseudo check buttons
				end
			end
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, y1=2, x2=3})

			self:Unhook(this, "OnShow")
			if self.modBtns then
				-- Hide then show to update quest buttons textures
				self:checkShown(this)
			end
		end)
	end

end
