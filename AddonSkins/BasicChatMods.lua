local _, aObj = ...
if not aObj:isAddonEnabled("BasicChatMods") then return end
local _G = _G

aObj.addonsToSkin.BasicChatMods = function(self) -- v v10.2.2

	-- find and skin chatcopy frame
	self.RegisterCallback("BasicChatMods", "UIParent_GetChildren", function(_, child, _)
		if child.font
		and child.box
		and child.scroll
		then
			self:skinObject("frame", {obj=child})
			if self.modBtns then
				self:skinCloseButton{obj=child.ClosePanelButton}
			end
			self.UnregisterCallback("BasicChatMods", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

	self:add2Table(self.ttList, _G.BCMtooltip)

	self.RegisterCallback("BasicChatMods", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "BasicChatMods" then return end
		self.iofSkinnedPanels[panel] = true

		local function skinObjects(frame)
			for _, obj in _G.pairs{frame:GetChildren()} do
				if aObj:isDropDown(obj) then
					aObj:skinObject("dropdown", {obj=obj, x2=obj.Middle:GetWidth() - 6})
				elseif obj:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=obj})
				elseif obj:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=obj})
				elseif obj:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=obj}
				elseif obj:IsObjectType("Button")
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=obj}
				elseif obj:IsObjectType("Frame") then
					skinObjects(obj)
				end
			end
		end
		skinObjects(panel)

		self.UnregisterCallback("BasicChatMods", "IOFPanel_Before_Skinning")
	end)

end
