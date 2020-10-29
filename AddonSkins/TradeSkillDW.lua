local _, aObj = ...
if not aObj:isAddonEnabled("TradeSkillDW") then return end
local _G = _G

aObj.lodAddons.TradeSkillDW = function(self) -- v 1.99.3

	self:SecureHook("TradeSkillDW_Update", function()
		-- handle in combat
		if _G.InCombatLockdown() then return end

		-- skill buttons on RHS
		local tsfc, child = _G.TradeSkillFrame:GetNumChildren()
		for i = tsfc, tsfc - 8, -1 do
			child = self:getChild(_G.TradeSkillFrame, i)
			if child:IsObjectType("CheckButton") then
				aObj:Debug("TSF GC: [%s, %s]", tsfc, i)
				self:getRegion(child, 1):SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=child}
				end
			end
		end

		if self.modBtns then
			self:skinStdButton{obj=_G.TradeSkillQueueButton, ofs=0}
			for i = 9, 40 do
				self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], onSB=true}
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TradeSkillDWExpandButton, ofs=-2}
		end
		-- remove extra textures
		_G.TradeSkillFrame:DisableDrawLayer("ARTWORK")

		self:Unhook(this, "TradeSkillDW_Update")
	end)

	self:SecureHookScript(_G.TradeSkillDWQueueFrame, "OnShow", function(this)
		self:skinSlider{obj=this.sf.ScrollBar}
		this.df:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.df.ScrollBar}
		self:keepFontStrings(this.df.cf)
		for _, btn in _G.pairs(this.df.cf.Reagents) do
			_G[btn:GetName() .. "NameFrame"]:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, libt=true}
			end
		end
		self:removeMagicBtnTex(this.DoButton)
		self:removeMagicBtnTex(this.UpButton)
		self:removeMagicBtnTex(this.DownButton)
		self:removeMagicBtnTex(this.ClearButton)
		-- addon already uses .sf so nil out entry otherwise skinframe won't be created
		this.sf = nil
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true, y1=2, x2=1, y2=-3}
		-- reinstate the original .sf entry
		this.sf = _G[("%sScrollFrame"):format(this:GetName())]
		if self.modBtns then
			for _, btn in _G.pairs{"DoButton", "UpButton", "DownButton", "ClearButton"} do
				self:skinStdButton{obj=this[btn]}
				self:SecureHook(this[btn], "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(this[btn], "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
			self:SecureHook("TradeSkillDW_QueueInit", function()
				for _, btn in _G.pairs(this.sf.buttons) do
					self:skinExpandButton{obj=_G[btn:GetName() .. "Remove"], as=true}
				end

				self:Unhook(this, "TradeSkillDW_QueueInit")
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.df.cf.Icon, reParent={this.df.cf.Icon.Count}}
		end

		self:Unhook(this, "OnShow")
	end)

end
