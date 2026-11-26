local _, aObj = ...
if not aObj:isAddonEnabled("Attune") then return end
local _G = _G

aObj.addonsToSkin.Attune = function(self) -- v 16001-41

	if not _G.Attune_NextFrame then
		self:SecureHook("Attune_NextFrameEnsure", function()
			self:skinObject("frame", {obj=_G.Attune_NextFrame, kfs=true})

			self:Unhook("Attune_NextFrameEnsure")
		end)
	else
		self:skinObject("frame", {obj=_G.Attune_NextFrame, kfs=true})
	end

	self:SecureHook("Attune_Frame", function()

		self:SecureHookScript(_G.AttuneBronzeChrome, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("frame", {obj=this, kfs=true, rns=true, cb=true})

			self:Unhook(_G.AttuneBronzeChrome, "OnShow")
		end)
		self:checkShown(_G.AttuneBronzeChrome)

		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.Attune_MainFrame, 9)} -- surveybutton (SURVEY BUTTON)
			self:skinStdButton{obj=self:getChild(_G.Attune_MainFrame, 10)} -- guildbutton (RESULTS BUTTON)
		end

		self:Unhook("Attune_Frame")
	end)

	self:SecureHook("Attune_EnsureResultHolder", function()

		local resultHolder = self:getLastChild(_G.Attune_MainFrame)
		self:skinObject("frame", {obj=resultHolder, kfs=true})

		self:Unhook("Attune_EnsureResultHolder")
	end)

	self:SecureHook("Attune_EnsureIconView", function(widget)

		self:skinObject("slider", {obj=widget.attuneIconHolder.bar})

		self:Unhook("Attune_EnsureIconView")
	end)

	self:SecureHook("Attune_CreateSkipCheck", function()

		local width = _G.Round(_G.AttuneSkipCheck:GetWidth())
		if self.modChkBtns then
			self:skinObject("button", {obj=_G.AttuneSkipCheck, ng=true, ofs=-1, x1=width - 23, y2=2})
			self:getRegion(_G.AttuneSkipCheck, 1):SetTexture(nil)
		end

		self:Unhook("Attune_CreateSkipCheck")
	end)

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			_G.RunNextFrame(function()
			    self:add2Table(self.ttList, "a", fObj)
			end)
		end)
	end}, "AttuneGiverTip")

end
