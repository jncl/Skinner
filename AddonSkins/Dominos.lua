local _, aObj = ...
if not aObj:isAddonEnabled("Dominos") then return end
local _G = _G

aObj.lodAddons.Dominos_Config = function(self) -- v 10.0.8

	local Options = _G.Dominos.Options

	_G.C_Timer.After(0.25, function()
		self:removeRegions(Options.HelpDialog, {10}) -- header texture
		self:moveObject{obj=self:getRegion(Options.HelpDialog, 11), y=-6}
	end)
	self:skinObject("slider", {obj=self:getLastChild(Options.HelpDialog), rpTex="background"})
	self:skinObject("frame", {obj=Options.HelpDialog, kfs=true, hdr=true, ofs=0})
	if self.modBtns then
		self:skinStdButton{obj=Options.HelpDialog.exitButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=Options.HelpDialog.showGridButton}
	end

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
