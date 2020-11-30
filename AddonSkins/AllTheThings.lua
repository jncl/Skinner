local aName, aObj = ...
if not aObj:isAddonEnabled("AllTheThings") then return end
local _G = _G

aObj.addonsToSkin.AllTheThings = function(self) -- v 2.1.2

	local function skinFrame(frame)
		aObj:skinObject("slider", {obj=frame.ScrollBar, x1=0, x2=-1})
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, y1=0, x2=1})
	end
	-- hook this to skin new frames
	self:RawHook(_G.AllTheThings, "GetWindow", function(this, suffix, ...)
		local frame = self.hooks[this].GetWindow(this, suffix, ...)
		if not frame.sf then
			skinFrame(frame)
		end
		return frame
	end, true)

	-- skin existing frames
	self.RegisterCallback("AllTheThings", "UIParent_GetChildren", function(this, child)
		if child.Suffix
		and child.Refresh
		and child.BaseUpdate
		then
			skinFrame(child)
		end
	end)
	self:scanUIParentsChildren()

	-- TODO: add button border to Tooltip Icon

	-- Tooltip Model frame
	self:skinObject("frame", {obj=_G.ATTGameTooltipModel, kfs=true})

	-- minimap button
	if _G["AllTheThings-Minimap"] then
		self.mmButs["AllTheThings"] = _G["AllTheThings-Minimap"]
		self:getRegion(_G["AllTheThings-Minimap"], 2):SetDrawLayer("OVERLAY") -- make logo appear
	end

	-- Settings Panels
	self.RegisterCallback("AllTheThings", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "AllTheThings" then return end

		for _, btn in _G.pairs(panel.Tabs) do
			self.iofBtn[btn] = true
		end

		self.UnregisterCallback("AllTheThings", "IOFPanel_Before_Skinning")
	end)
	self.RegisterCallback("AllTheThings", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "AllTheThings" then return end

		self:removeBackdrop(panel)
		self:getRegion(panel, 4):SetTexture(nil) -- Separator line

		self:skinObject("tabs", {obj=panel, tabs=panel.Tabs, ignoreSize=true, lod=true, offsets={x1=6, y1=0, x2=-6, y2=-4}})

		for i, tabPanel in _G.pairs(panel.Tabs) do
			if i == 3 then -- Unobtainables Tab
				for _, obj in _G.ipairs(tabPanel.objects) do
					if obj:IsObjectType("Frame")
					and obj:GetWidth() == 600
					and _G.Round(obj:GetHeight()) == 2500
					then -- child frame
						for _, child in _G.ipairs{obj:GetChildren()} do
							if child:GetObjectType() == "Frame" then
								self:skinObject("frame", {obj=child, kfs=true, fb=true})
							end
						end
					elseif obj:IsObjectType("CheckButton")
					and self.modChkBtns
					then
						self:skinCheckButton{obj=obj, hf=true}
					end
				end
			end
		end

		self.UnregisterCallback("AllTheThings", "IOFPanel_After_Skinning")
	end)

end
