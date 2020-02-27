local aName, aObj = ...
if not aObj:isAddonEnabled("Classic Quest Log") then return end
local _G = _G

aObj.addonsToSkin["Classic Quest Log"] = function(self) -- v

	if not self.isClsc then
	    if self.modBtns then
	        local function qlUpd()

	            -- handle in combat
	            if _G.InCombatLockdown() then
	                aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
	                return
	            end

	            for i = 1, #_G.ClassicQuestLog.scrollFrame.buttons do
	                aObj:checkTex(_G.ClassicQuestLog.scrollFrame.buttons[i])
	            end

	        end
	        -- hook to manage changes to button textures
	        self:SecureHook(_G.ClassicQuestLog, "UpdateLogList", function()
	            qlUpd()
	        end)
	        -- skin minus/plus buttons
	        for i = 1, #_G.ClassicQuestLog.scrollFrame.buttons do
	            self:skinButton{obj=_G.ClassicQuestLog.scrollFrame.buttons[i], mp=true}
	        end
		end
		self:skinScrollBar{obj=_G.ClassicQuestLog.scrollFrame, size=2}
		self:skinScrollBar{obj=_G.ClassicQuestLog.detail}
		self:addSkinFrame{obj=_G.ClassicQuestLog, kfs=true, ri=true, y1=2, x2=2}
	else -- v 1.4.5-Classic
		self:SecureHookScript(_G.ClassicQuestLog, "OnShow", function(this)
			self:skinExpandButton{obj=this.scrollFrame.expandAll, onSB=true}
			this.scrollFrame:DisableDrawLayer("BACKGROUND")
			this.scrollFrame:DisableDrawLayer("BORDER")
			self:skinSlider{obj=this.scrollFrame.scrollBar, wdth=-4}
			this.detail:DisableDrawLayer("BACKGROUND")
			self:skinSlider{obj=this.detail.ScrollBar, rt="artwork"}
			self:removeMagicBtnTex(this.close)
			self:removeMagicBtnTex(this.abandon)
			self:removeMagicBtnTex(this.push)
			self:removeMagicBtnTex(this.track)
			self:removeMagicBtnTex(this.options)
			self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, x2=1}
			if self.modBtns then
		        -- hook to manage changes to button textures
		        self:SecureHook(this, "UpdateLog", function(this)
					for i = 1, #this.scrollFrame.buttons do
						self:checkTex(this.scrollFrame.buttons[i])
					end
		        end)
		        -- skin minus/plus buttons
		        for i = 1, #this.scrollFrame.buttons do
		            self:skinExpandButton{obj=this.scrollFrame.buttons[i], onSB=true, noHook=true}
		        end
				self:skinStdButton{obj=this.close}
				self:skinStdButton{obj=this.abandon}
				self:skinStdButton{obj=this.push}
				self:skinStdButton{obj=this.track}
				self:skinStdButton{obj=this.options}
			end

			-- optionsFrame
			self:addSkinFrame{obj=this.optionsFrame, ft="a", kfs=true, x2=1}
			if self.modChkBtns then
				for _, bName in pairs{"UndockWindow", "LockWindow", "ShowResizeGrip", "ShowLevels", "ShowTooltips", "SolidBackground"} do
					self:skinCheckButton{obj=this.optionsFrame[bName]}
				end
			end

			self:Unhook(this, "OnShow")
		end)
	end

	self:removeInset(_G.ClassicQuestLog.count)
	self:addButtonBorder{obj=_G.ClassicQuestLog.mapButton, x1=2, y1=-1, x2=-2, y2=1}

end
