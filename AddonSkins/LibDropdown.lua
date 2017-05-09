local aName, aObj = ...
local _G = _G
-- This is a Library

function aObj:LibDropdown()
	if self.initialized.LibDropdown then return end
	self.initialized.LibDropdown = true

	local lDD = _G.LibStub("LibDropdown-1.0", true)

	if lDD then
		self:RawHook(lDD, "OpenAce3Menu", function(this, tab, parent)
			if parent == nil and tab.args then
				-- creation pass of the function
				local frame = self.hooks[this].OpenAce3Menu(this, tab, parent)
				self:applySkin{obj=frame}
				return frame
			else
				-- setup pass of the function, second and subsequent calls
				self.hooks[this].OpenAce3Menu(this, tab, parent)
				self:applySkin{obj=parent}
			end
		end, true)
		self:SecureHook(lDD, "Ace3InputShow", function(this, tab, parent)
			self:skinEditBox{obj=parent:GetParent().input, regs={9}}
			parent:GetParent().input.SetHeight = function() end -- stop height being reset
			self:applySkin{obj=parent}
		end, true)
	end

end
