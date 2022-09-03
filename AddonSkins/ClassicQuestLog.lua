local _, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

if aObj.isRtl then return end

aObj.addonsToSkin["Classic Quest Log"] = function(self)

	if aObj.isClscERA then -- v 1.4.6.-Classic
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
				self:SecureHook(this, "UpdateLog", function(this)
		            for _, btn in _G.pairs(this.scrollFrame.buttons) do
		                aObj:checkTex(btn)
		            end
				end)
				self:skinStdButton{obj=this.close}
				self:skinStdButton{obj=this.abandon}
				self:skinStdButton{obj=this.push}
				self:skinStdButton{obj=this.track}
				self:skinStdButton{obj=this.options}
				self:SecureHook(this, "UpdateControlButtons", function(this)
					self:clrBtnBdr(this.abandon)
					self:clrBtnBdr(this.push)
					self:clrBtnBdr(this.track)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.mapButton, ofs=-2, y1=0, y2=0, clr="gold"}
			end
			self:SecureHookScript(this.optionsFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})
				if self.modChkBtns then
					self:skinCheckButton{obj=this.UndockWindow}
					self:skinCheckButton{obj=this.LockWindow}
					self:skinCheckButton{obj=this.ShowResizeGrip}
					self:skinCheckButton{obj=this.ShowLevels}
					self:skinCheckButton{obj=this.ShowTooltips}
					self:skinCheckButton{obj=this.SolidBackground}
					self:skinCheckButton{obj=this.UseClassicSkin}
				end

				self:Unhook(this.optionsFrame, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
	else -- v 2.0.4
		self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.log:DisableDrawLayer("BACKGROUND")
			this.log:DisableDrawLayer("BORDER")
			this.log.expandAll:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=this.log.scrollBar, rpTex="background"})
			this.detail:DisableDrawLayer("ARTWORK")
			self:skinObject("slider", {obj=this.detail.ScrollBar})
			this.detail.DetailBG:SetTexture(nil)
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, y1=2, x2=3})
		    if self.modBtns then
		        local function qlUpd()
		            if _G.InCombatLockdown() then
		                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
		                return
		            end
		            for _, btn in _G.pairs(_G.ClassicQuestLog.log.buttons) do
		                aObj:checkTex(btn)
		            end
		        end
		        self:SecureHook(this.log, "UpdateLog", function()
		            qlUpd()
		        end)
				self:skinExpandButton{obj=this.log.expandAll, onSB=true}
		        for _, btn in _G.pairs(this.log.buttons) do
		            self:skinExpandButton{obj=btn, onSB=true}
		        end
			end
			self:removeInset(this.chrome.countFrame)
			if self.modBtns then
				self:skinStdButton{obj=this.chrome.abandonButton}
				self:skinStdButton{obj=this.chrome.pushButton}
				self:skinStdButton{obj=this.chrome.trackButton}
				self:skinStdButton{obj=this.chrome.closeButton}
				self:skinStdButton{obj=this.chrome.optionsButton}
				self:skinStdButton{obj=this.chrome.syncButton}
				self:SecureHook(this.chrome, "Update", function(this)
					self:clrBtnBdr(this.abandonButton)
					self:clrBtnBdr(this.pushButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.chrome.mapButton, ofs=-2, y1=0, y2=0, clr="gold"}
			end
			this.options:DisableDrawLayer("BACKGROUND")
			this.options:DisableDrawLayer("BORDER")
			this.options.content.headerBack:SetTexture(nil)
			if self.modBtns then
				self:skinCloseButton{obj=this.options.content.close}
			end
			if self.modChkBtns then
				for _, bName in _G.pairs{"LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground", "ShowFromObjectiveTracker"} do
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
