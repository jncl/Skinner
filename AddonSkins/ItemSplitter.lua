local _, aObj = ...
if not aObj:isAddonEnabled("ItemSplitter") then return end
local _G = _G

aObj.addonsToSkin.ItemSplitter = function(self) -- v 11.0.2

	self:SecureHook("CreateItemSplitterDialog", function(_)
		local frame = _G.ItemSplitterFrame
		self:skinObject("editbox", {obj=frame.editBox})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=frame.decrementButton}
			self:skinStdButton{obj=frame.incrementButton}
			self:skinStdButton{obj=frame.splitButton}
			self:skinStdButton{obj=frame.autoSplitButton}
		end

		self:Unhook("CreateItemSplitterDialog")
	end)

end
