local _, aObj = ...
if not aObj:isAddonEnabled("Dominos") then return end
local _G = _G

aObj.lodAddons.Dominos_Config = function(self) -- v 11.0.2

	local Options = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("Dominos_Config", true)
	if not Options then return end

	self:SecureHookScript(Options.HelpDialog, "OnShow", function(this)
		self:removeRegions(this, {10}) -- header texture
		self:moveObject{obj=self:getRegion(this, 11), y=-6}
		self:skinObject("slider", {obj=self:getLastChild(this), rpTex="background"})
		-- remove header box texture
		for _, reg in _G.ipairs{this:GetRegions()} do
			if reg.GetTextureFileID
			and reg:GetTextureFileID() == 131080
			then
				reg:SetTexture(nil)
				break
			end
		end
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.exitButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.showGridButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(Options.HelpDialog)
	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(Options.Menu, "New", function(this, parent)
		local menu = self.hooks[this].New(this, parent)
		self:skinObject("frame", {obj=menu, kfs=true, ofs=0, y1=-2, x2=-1})
		if self.modBtns then
			self:skinCloseButton{obj=_G[menu:GetName() .. "Close"]}
		end
		return menu
	end, true)

	self:RawHook(Options.ScrollableContainer, "New", function(this, options)
		local container = self.hooks[this].New(this, options)
		self:skinObject("slider", {obj=container.scrollFrame.ScrollBar})
		return container
	end, true)

	self:RawHook(Options.Slider, "New", function(this, options)
		local slider = self.hooks[this].New(this, options)
		self:skinObject("slider", {obj=slider})
		return slider
	end, true)

	self:RawHook(Options.Dropdown, "New", function(this, options)
		local dropdown = self.hooks[this].New(this, options)
		self:skinObject("dropdown", {obj=dropdown.dropdownMenu, x2=109})
		return dropdown
	end, true)

	self:RawHook(Options.TextInput, "New", function(this, options)
		local textInput = self.hooks[this].New(this, options)
		self:skinObject("slider", {obj=textInput.vScrollBar, rpTex="background"})
		return textInput
	end, true)

	if self.modChkBtns then
		self:RawHook(Options.CheckButton, "New", function(this, options)
			local button = self.hooks[this].New(this, options)
			self:skinCheckButton{obj=button}
			return button
		end, true)
	end

end
