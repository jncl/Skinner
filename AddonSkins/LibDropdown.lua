local aName, aObj = ...
-- This is a Library

function aObj:LibDropdown()
	if self.initialized.LibDropdown then return end
	self.initialized.LibDropdown = true

	local lDD = LibStub("LibDropdown-1.0", true)
	if lDD then
		self:RawHook(lDD, "OpenAce3Menu", function(this, tab, parent)
			-- self:Debug("OpenAce3Menu: [%s, %s, %s]", this, tab, parent)
			if parent == nil and tab.args then
				-- creation pass of the function
				local frame = self.hooks[this].OpenAce3Menu(this, tab, parent)
				-- self:Debug("OpenAce3Menu: [%s, %s, %s, %s, %s, %s, %s]", this, tab, parent, frame, frame:GetHeight(), frame:GetWidth(), frame:IsVisible())
				self:applySkin{obj=frame}
				return frame
			else
				-- setup pass of the function, second and subsequent calls
				self.hooks[this].OpenAce3Menu(this, tab, parent)
				self:applySkin{obj=parent}
			end
		end, true)
		self:SecureHook(lDD, "Ace3InputShow", function(this, tab, parent)
			-- self:Debug("Ace3InputShow: [%s, %s, %s, %s, %s, %s]", this, tab, parent, parent.data, parent.Showing, parent:GetParent().input)
			self:skinEditBox{obj=parent:GetParent().input, regs={9}}
			parent:GetParent().input.SetHeight = function() end -- stop height being reset
			self:applySkin{obj=parent}
		end, true)
	end
	
end
