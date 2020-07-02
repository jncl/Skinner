local _, aObj = ...
if not aObj:isAddonEnabled("Dominos") then return end
local _G = _G

aObj.addonsToSkin.Dominos = function(self) -- v 8.3.11

	-- ConfigOverlay
	local mod = _G.Dominos:GetModule('ConfigOverlay', true)
	if mod then
		-- hook to skin the configHelper panel
		self:RawHook(mod, "CreateHelpDialog", function(this)
			local dialog = self.hooks[this].CreateHelpDialog(this)
			self:rmRegionsTex(dialog, {10}) -- header texture, N.B. created after other textures
			self:addSkinFrame{obj=dialog, ft="a", kfs=true, nb=true, ofs=0, y1=4, y2=4}
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(dialog, 1)} -- this is a CheckButton object
			end

			self:Unhook(this, "CreateHelpDialog")
			return dialog
		end, true)
	end
	mod = nil

end

aObj.lodAddons.Dominos_Config = function(self) -- v 8.3.11

	local Options = _G.Dominos.Options

	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(Options.Menu, "New", function(this, parent)
		local menu = self.hooks[this].New(this, parent)
		self:addSkinFrame{obj=menu, ft="a", kfs=true, nb=true, ofs=0, y1=-2, x2=-1}
		if self.modBtns then
			self:skinCloseButton{obj=_G[menu:GetName() .. "Close"]}
		end
		return menu
	end, true)

	self:RawHook(Options.ScrollableContainer, "New", function(this, options)
		local container = self.hooks[this].New(this, options)
		self:skinSlider{obj=container.scrollFrame.ScrollBar, wdth=-6}
		return container
	end, true)

	self:RawHook(Options.Slider, "New", function(this, options)
		local slider = self.hooks[this].New(this, options)
		self:skinSlider{obj=slider, wdth=-6}
		return slider
	end, true)

	self:RawHook(Options.Dropdown, "New", function(this, options)
		local dropdown = self.hooks[this].New(this, options)
		self:skinDropDown{obj=dropdown.dropdownMenu, x2=109}
		return dropdown
	end, true)

	self:RawHook(Options.TextInput, "New", function(this, options)
		local textInput = self.hooks[this].New(this, options)
		-- self:skinEditBox{obj=textInput.editBox, regs={6}} -- 6 is text
		self:skinSlider{obj=textInput.vScrollBar, rt="backgroubd", wdth=-6}
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
