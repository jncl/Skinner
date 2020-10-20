local aName, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

aObj.addonsToSkin["Classic Quest Log"] = function(self) -- v 2.0.2

	self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.log:DisableDrawLayer("BACKGROUND")
		this.log:DisableDrawLayer("BORDER")
		this.log.expandAll:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.log.scrollBar, rt="background"}
		this.detail:DisableDrawLayer("ARTWORK")
		self:skinSlider{obj=_G.ClassicQuestLog.detail.ScrollBar}
		this.detail.DetailBG:SetTexture(nil)
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, y1=2, x2=2}
	    if self.modBtns then
	        local function qlUpd()
	            -- handle in combat
	            if _G.InCombatLockdown() then
	                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
	                return
	            end
	            for i = 1, #_G.ClassicQuestLog.log.buttons do
	                aObj:checkTex(_G.ClassicQuestLog.log.buttons[i])
	            end
	        end
	        -- hook to manage changes to button textures
	        self:SecureHook(this.log, "UpdateLog", function()
	            qlUpd()
	        end)
			self:skinExpandButton{obj=this.log.expandAll, onSB=true}
	        -- skin minus/plus buttons
	        for i = 1, #this.log.buttons do
	            self:skinExpandButton{obj=this.log.buttons[i], onSB=true--[[, noHook=true]]}
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
				if this.mapButton.sbb then
					self:clrBtnBdr(this.mapButton)
				end
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.chrome.mapButton, ofs=-2, y1=0, y2=0}
		end
		-- options
		this.options:DisableDrawLayer("BACKGROUND")
		this.options:DisableDrawLayer("BORDER")
		this.options.content.headerBack:SetTexture(nil)
		if self.modBtns then
			self:skinCloseButton{obj=this.options.content.close, clr="gold"}
		end
		if self.modChkBtns then
			for _, bName in pairs{"LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground", "ShowFromObjectiveTracker"} do
				self:skinCheckButton{obj=this.options.content[bName].check}
			end
		end

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, this.campaignTooltip)
		end)

		self:Unhook(this, "OnShow")
		if self.modBtns then
			-- Hide then show to update quest buttons
			self:checkShown(this)
		end
	end)

end
