local _, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

aObj.addonsToSkin["Classic Quest Log"] = function(self)

	if self.isClscERA then -- v 1.4.6.-Classic
		self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
			self:removeMagicBtnTex(this.close)
			self:removeMagicBtnTex(this.abandon)
			self:removeMagicBtnTex(this.push)
			self:removeMagicBtnTex(this.track)
			self:removeMagicBtnTex(this.options)
			this.emptyLog:DisableDrawLayer("BACKGROUND")
			self:removeInset(this.count)
			this.scrollFrame.expandAll:DisableDrawLayer("BACKGROUND")
			this.scrollFrame.BG:SetAlpha(0)
			self:skinObject("slider", {obj=this.scrollFrame.scrollBar, rpTex="background"})
			this.detail.DetailBG:SetAlpha(0)
			self:skinObject("slider", {obj=this.detail.ScrollBar, rpTex="artwork"})
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})
			if self.modBtns then
				self:skinExpandButton{obj=this.scrollFrame.expandAll, onSB=true}
		        -- skin minus/plus buttons
		        for i = 1, #this.scrollFrame.buttons do
		            self:skinExpandButton{obj=this.scrollFrame.buttons[i], onSB=true}
		        end
				self:SecureHook(this, "UpdateLog", function(fObj)
		            for _, btn in _G.pairs(fObj.scrollFrame.buttons) do
		                aObj:checkTex(btn)
		            end
				end)
				self:skinStdButton{obj=this.close}
				self:skinStdButton{obj=this.abandon}
				self:skinStdButton{obj=this.push}
				self:skinStdButton{obj=this.track}
				self:skinStdButton{obj=this.options}
				self:SecureHook(this, "UpdateControlButtons", function(fObj)
					self:clrBtnBdr(fObj.abandon)
					self:clrBtnBdr(fObj.push)
					self:clrBtnBdr(fObj.track)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.mapButton, ofs=-2, y1=0, y2=0, clr="gold"}
			end
			self:SecureHookScript(this.optionsFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, kfs=true, cb=true, x2=1})
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.UndockWindow}
					self:skinCheckButton{obj=fObj.LockWindow}
					self:skinCheckButton{obj=fObj.ShowResizeGrip}
					self:skinCheckButton{obj=fObj.ShowLevels}
					self:skinCheckButton{obj=fObj.ShowTooltips}
					self:skinCheckButton{obj=fObj.SolidBackground}
					self:skinCheckButton{obj=fObj.UseClassicSkin}
				end

				self:Unhook(this.optionsFrame, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
	else -- v 2.3.4
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
				for _, bName in _G.pairs{"LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "ShowFromObjectiveTracker", "DontOverrideBind", "ShowMinimapButton", "UseCustomScale"} do
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
	end

end
