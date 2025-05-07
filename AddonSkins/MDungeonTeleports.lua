local _, aObj = ...
if not aObj:isAddonEnabled("MDungeonTeleports") then return end
local _G = _G

aObj.addonsToSkin.MDungeonTeleports = function(self) -- v 3.1.10

	local copyFrame
	local function skinCopyFrame()
		copyFrame = _G.CopyFrame
		self.RegisterCallback("MDT", "MDT_GetChildren#2", function(_, child, _)
			if child:GetName() == "CopyFrame"
			and child ~= copyFrame
			then
				copyFrame = child
			end
		end)
		self:scanChildren{obj=_G.UIParent, cbstr="MDT_GetChildren#2"}
		if copyFrame then
			self:secureHookScript(copyFrame, "OnShow", function(this)
				self:skinObject("editbox", {obj=self:getChild(this, 1)})
				self:skinObject("frame", {obj=this--[[, kfs=true]]})

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(copyFrame)
		end
	end

	self:SecureHookScript(_G.PortalLibrary, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.PortalLibraryRaid, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.Season1, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.Season2, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.FeatureWindow, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		for _, child in _G.ipairs_reverse{this:GetChildren()} do
			if child:IsObjectType("Button") then
				self:SecureHookScript(child, "OnClick", function(_)
					skinCopyFrame()
					self:Unhook(this, "OnClick")
				end)
			end
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.KeyTrackerPlayer, "OnShow", function(this)
		self:skinObject("frame", {obj=this})

		self:SecureHookScript(_G.KeystoneUIFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.KeystoneUIFrame)

		self:Unhook(this, "OnShow")
	end)

	-- get Frame object for Settings frame
	local settingsFrame
	self.RegisterCallback("MDT", "MDT_GetChildren", function(_, child, _)
		if child:GetName() == "Settings"
		and child.CheckButton
		then
			settingsFrame = child
			self.UnregisterCallback("MDT", "MDT_GetChildren")
		end
	end)
	self:scanChildren{obj=_G.UIParent, cbstr="MDT_GetChildren"}

	if settingsFrame then
		self:SecureHookScript(settingsFrame, "OnShow", function(this)
			_G.UIDropDownMenu_SetButtonWidth(_G.FramePackDropdown, 24)
			self:skinObject("dropdown", {obj=_G.FramePackDropdown})
			self:skinObject("slider", {obj=_G.uiScaleSlider})
			self:skinObject("frame", {obj=this, kfs=true})
			for _, child in _G.ipairs_reverse{this:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and self.modChkBtns
				then
					self:skinCheckButton{obj=child, ignNT=true, yOfs=4}
				elseif child:IsObjectType("Button") then
					self:SecureHookScript(child, "OnClick", function(_)
						skinCopyFrame()
						self:Unhook(this, "OnClick")
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)
	end

end
