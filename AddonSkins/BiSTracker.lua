local _, aObj = ...
if not aObj:isAddonEnabled("BiSTracker") then return end
local _G = _G

aObj.addonsToSkin.BiSTracker = function(self) -- v 5.02

	local function skinEditBox(obj)
		aObj:skinObject("editbox", {obj=obj.editbox, ofs=0, x1=-2})
		-- hook this as insets are changed
		aObj:rawHook(obj.editbox, "SetTextInsets", function(this, left, ...)
			return left + 6, ...
		end, true)
		if aObj.modBtns then
			aObj:skinStdButton{obj=obj.button, as=true}
			if objType == "NumberEditBox" then
				aObj:skinStdButton{obj=obj.minus, as=true}
				aObj:skinStdButton{obj=obj.plus, as=true}
			end
		end
	end
	local function skinTabGroup(obj)
		aObj:skinObject("tabs", {obj=obj.frame, tabs=obj.tabs, lod=self.isTT and true, upwards=true, offsets={x1=8, y1=-2, x2=-8, y2=self.isTT and -5 or 0}, noCheck=true, track=false})
		aObj:skinObject("frame", {obj=obj.border, kfs=true, fb=true, ofs=0})
		if aObj.modBtns then
			if aObj.isTT then
				aObj:secureHook(obj, "SelectTab", function(this, value)
					for _, tab in _G.ipairs(this.tabs) do
						if tab.value == value then
							aObj:setActiveTab(tab.sf)
						else
							aObj:setInactiveTab(tab.sf)
						end
					end
				end)
			end
		end
	end
	self:SecureHookScript(_G.BiSTracker.MainFrame.frame, "OnShow", function(this)
		skinEditBox(this.obj.SetName)
		self:skinAceDropdown(this.obj.ActionsGroup.ClassDropdown, nil, 1)
		self:skinAceDropdown(this.obj.ActionsGroup.SetDropdown, nil, 1)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.obj.closebutton}
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BiSTracker.MainFrame.EditSlot.frame, "OnShow", function(this)
		skinEditBox(this.obj.Values.ID)
		self:skinAceDropdown(this.obj.Values.ObtainMethod, nil, 1)
		skinEditBox(this.obj.Values.ObtainID)
		skinEditBox(this.obj.Values.Zone)
		skinEditBox(this.obj.Values.NpcName)
		skinEditBox(this.obj.Values.DropChance)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.obj.closebutton}
			self:skinStdButton{obj=this.obj.Values.CancelButton.frame}
			self:skinStdButton{obj=this.obj.Values.SaveButton.frame}
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BiSTracker.MainFrame.ConfirmDelete.frame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.obj.closebutton}
			self:skinStdButton{obj=this.obj.Values.CancelButton.frame}
			self:skinStdButton{obj=this.obj.Values.ConfirmButton.frame}
		end
		
		self:Unhook(this, "OnShow")
	end)
	-- Import/Export
	self:SecureHookScript(_G.BiSTracker.Serializer.GUI.frame, "OnShow", function(this)
		skinTabGroup(this.obj.Tabs)
		this.obj.Tabs:SelectTab("Import") -- this skins the frame contents
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.obj.closebutton}
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BiSTracker.Options.GUI.frame, "OnShow", function(this)
		skinTabGroup(_G.BiSTracker.Options.GUI.Tabs)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.obj.closebutton}
		end
		
		self:Unhook(this, "OnShow")
	end)


end
