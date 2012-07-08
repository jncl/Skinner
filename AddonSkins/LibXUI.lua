-- This is a Library
local aName, aObj = ...

function aObj:LibXUI()
	if self.initialized.LibXUI then return end
	self.initialized.LibXUI = true

	local XUI = LibStub("X-UI", true)
	if XUI then
		self:RawHook(XUI, "CreateEditbox", function(this, frame)
			local edit = self.hooks[this].CreateEditbox(this, frame)
			-- self:Debug("CreateEditbox: [%s, %s, %s]", this, frame, edit)
			self:skinEditBox{obj=edit, regs={9}, noHeight=true, noWidth=true}
			return edit
		end, true)
		self:RawHook(XUI, "CreateSelect", function(this, frame, items)
			local wrapper, widget = self.hooks[this].CreateSelect(this, frame, items)
			-- self:Debug("CreateSelect: [%s, %s, %s, %s, %s]", this, frame, items, wrapper, widget)
			self:skinDropDown{obj=widget, y2=4}
			return wrapper, widget
		end, true)
	end
	
end
