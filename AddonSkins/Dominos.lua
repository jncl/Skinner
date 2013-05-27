local aName, aObj = ...
if not aObj:isAddonEnabled("Dominos") then return end
local _G = _G

function aObj:Dominos()

	-- hook to skin the configHelper panel
	self:SecureHook(_G.Dominos, "ShowConfigHelper", function()
		self:skinButton{obj=_G.DominosConfigHelperDialogExitConfig} -- this is a CheckButton object
		self:addSkinFrame{obj=_G.DominosConfigHelperDialog, kfs=true, y1=4, y2=4, nb=true}
		self:Unhook(_G.Dominos, "ShowConfigHelper")
	end)
	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(_G.Dominos, "NewMenu", function(this, id)
		local menu = self.hooks[this].NewMenu(this, id)
		if not self.skinned[menu] then
			self:addSkinFrame{obj=menu, x1=6, y1=-8, x2=-8, y2=6}
			self:SecureHookScript(menu, "OnShow", function(this)
				if this.dropdown then
					self:skinDropDown{obj=this.dropdown}
				end
				self:Unhook(menu, "OnShow")
			end)
		end
		self:Unhook(_G.Dominos, "NewMenu")
		return menu
	end, true)
	
	local mod
	-- PlayerPowerBarAlt
	mod = _G.Dominos:GetModule("PlayerPowerBarAlt", true)
	if mod then
		mod.frame.buttons[1].frame:SetTexture(nil)
	end
	-- EncounterBar
	mod = _G.Dominos:GetModule("encounter", true)
	if mod then
		mod.frame.PlayerPowerBarAlt.frame:SetTexture(nil)
	end
	-- ExtraBar
	mod = _G.Dominos.Frame:Get("extra", true)
	if mod then
		mod.buttons[1].style:SetTexture(nil)
		mod.buttons[1].style.SetTexture = function() end
	end
	
end

function aObj:Dominos_Config()

	-- hook the create menu function
	self:SecureHook(_G.Dominos.Menu, "New", function(this, name)
		local panel = _G["DominosFrameMenu" .. name]
		if not self.skinned[panel] then
			self:addSkinFrame{obj=panel, x1=6, y1=-8, x2=-8, y2=6}
		end
	end)
	-- hook the show panel function to skin dropdowns/editboxes & scrollbars
	self:SecureHook(_G.Dominos.Menu, "ShowPanel", function(this, name)
		self:skinAllButtons{obj=_G[this:GetName() .. name], x1=-1, x2=1}
		if this.dropdown then
			self:skinDropDown{obj=this.dropdown}
		end
		local stEB = _G[this:GetName() .. name .. "StateText"]
		if stEB then
			self:skinEditBox{obj=stEB, regs={9}, y=10}
		end
		if this.panels[2].scroll then
			self:skinScrollBar{obj=this.panels[2].scroll}
		end
	end)	

end
