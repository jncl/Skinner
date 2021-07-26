local _, aObj = ...
if not aObj:isAddonEnabled("Clique") then return end
local _G = _G

aObj.addonsToSkin.Clique = function(self) -- v 3.1.1
	if not self.db.profile.SpellBookFrame then return end

	-- Tab on SpellBook (side)
	self:removeRegions(_G.CliqueSpellTab, {1})
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.CliqueSpellTab}
	end
	
	self:SecureHookScript(_G.CliqueDialog, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=this.button_binding}
			self:skinStdButton{obj=this.button_accept}
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CliqueConfig, "OnShow", function(this)
		self:skinObject("dropdown", {obj=this.dropdown})
		self:skinColHeads("CliqueConfigPage1Column", 2)
		self:skinObject("slider", {obj=this.page1.slider})
		self:removeMagicBtnTex(this.page1.button_spell)
		self:removeMagicBtnTex(this.page1.button_other)
		self:removeMagicBtnTex(this.page1.button_options)
		self:skinObject("slider", {obj=this.page2.clickGrabber.scrollFrame.ScrollBar})
		self:removeMagicBtnTex(this.page2.button_save)
		self:removeMagicBtnTex(this.page2.button_cancel)
		self:skinObject("frame", {obj=this.page2.clickGrabber, fb=true})
		self:skinObject("glowbox", {obj=this.bindAlert})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x1=-5, x2=3})
		if self.modBtns then
			self:skinStdButton{obj=this.page1.button_spell}
			self:skinStdButton{obj=this.page1.button_other}
			self:skinStdButton{obj=this.page1.button_options}
			self:skinStdButton{obj=this.page2.button_binding}
			self:skinStdButton{obj=this.page2.button_save}
			self:skinStdButton{obj=this.page2.button_cancel}
			self:SecureHook(this.page2.button_save, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(this.page2.button_save, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:skinObject("glowbox", {obj=_G.CliqueTabAlert})

	local function skinCB(cBtn)
		cBtn:SetSize(26, 26)
		aObj:skinCheckButton{obj=cBtn}
	end
	local pCnt = 0
	self.RegisterCallback("Clique", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Clique"
		and panel.parent ~= "Clique"
		then
			return
		end
		if not self.iofSkinnedPanels[panel] then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			if panel.name == "General Options" then
				if self.modChkBtns then
					skinCB(panel.updown)
					skinCB(panel.fastooc)
					skinCB(panel.specswap)
					skinCB(panel.stopcastingfix)
				end
				for _, dd in _G.pairs(panel.talentProfiles) do
					self:skinObject("dropdown", {obj=dd})
				end
				self:skinObject("dropdown", {obj=panel.profiledd})
			elseif panel.name == "Frame Blacklist" then
				self:skinObject("slider", {obj=panel.scrollframe.ScrollBar})
				if self.modChkBtns then
					for _, cBtn in _G.pairs(panel.rows) do
						skinCB(cBtn)
					end
				end
				if self.modBtns then
					self:skinStdButton{obj=panel.selectall}
					self:skinStdButton{obj=panel.selectnone}
				end
			elseif panel.name == "Blizzard Frame Options" then
				if self.modChkBtns then
					skinCB(panel.PlayerFrame)
					skinCB(panel.PetFrame)
					skinCB(panel.TargetFrame)
					skinCB(panel.TargetFrameToT)
					skinCB(panel.party)
					skinCB(panel.compactraid)
					skinCB(panel.boss)
					skinCB(panel.FocusFrame)
					skinCB(panel.FocusFrameToT)
					skinCB(panel.arena)
				end
			end
		end

		if pCnt == 4 then
			self.UnregisterCallback("Clique", "IOFPanel_Before_Skinning")
			pCnt = nil
		end
	end)

end
