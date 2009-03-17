
function Skinner:Dominos()

	-- hook to skin the configHelper panel
	self:SecureHook(Dominos, "ShowConfigHelper", function()
		local cH = Dominos.configHelper
		self:keepFontStrings(cH)
		self:applySkin(cH)
		self:Unhook(Dominos, "ShowConfigHelper")
	end)
	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(Dominos, "NewMenu", function(this, id)
		local menu = self.hooks[this].NewMenu(this, id)
		self:applySkin(menu)
		self:SecureHookScript(menu, "OnShow", function(this)
			if menu.dropdown and not self.skinned[menu.dropdown] then
				self:skinDropDown(menu.dropdown)
			end
			self:Unhook(menu, "OnShow")
		end)
		self.skinned[menu] = true
		self:Unhook(Dominos, "NewMenu")
		return menu
	end, true)
	
end

function Skinner:Dominos_Config()

	-- hook the create menu function
	self:SecureHook(Dominos.Menu, "New", function(this, name)
		self:Debug("D.M.N:[%s, %s]", this, name)
		local panel = _G["DominosFrameMenu"..name]
		if not self.skinned[panel] then
			self:applySkin(panel)
		end
	end)
	-- hook the shop panel function to skin dropdowns & editboxes
	self:SecureHook(Dominos.Menu, "ShowPanel", function(this, name)
		self:Debug("D.M.SP:[%s, %s, %s]", this, this:GetName(), name)
		if this.dropdown and not self.skinned[this.dropdown] then
			self:skinDropDown(this.dropdown)
		end
		local stEB = _G[this:GetName()..name.."StateText"]
		if stEB and not self.skinned[stEB] then
			self:moveObject(stEB, nil, nil, "+", 10)
			self:skinEditBox(stEB, {9})
		end
	end)	

end
