
function Skinner:Dominos()

	-- hook to skin the configHelper panel
	self:SecureHook(Dominos, "ShowConfigHelper", function()
		self:skinButton{obj=DominosConfigHelperDialogExitConfig} -- this is a CheckButton object
		self:addSkinFrame{obj=DominosConfigHelperDialog, kfs=true, y1=4, y2=4}
		self:Unhook(Dominos, "ShowConfigHelper")
	end)
	-- hook this to skin first menu displayed and its dropdown
	self:RawHook(Dominos, "NewMenu", function(this, id)
--		self:Debug("Dominos_NewMenu: [%s, %s]", this, id)
		local menu = self.hooks[this].NewMenu(this, id)
		self:skinButton{obj=menu.close, cb=true}
		self:addSkinFrame{obj=menu, x1=6, y1=-6, x2=-6, y2=6}
		self:SecureHookScript(menu, "OnShow", function(this)
			if this.dropdown then
				self:skinDropDown{obj=this.dropdown}
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
--		self:Debug("D.M.N:[%s, %s]", this, name)
		local panel = _G["DominosFrameMenu"..name]
		if not self.skinned[panel] then
			self:skinButton{obj=panel.close, cb=true}
			self:addSkinFrame{obj=panel, x1=6, y1=-6, x2=-6, y2=6}
		end
	end)
	-- hook the show panel function to skin dropdowns & editboxes
	self:SecureHook(Dominos.Menu, "ShowPanel", function(this, name)
--		self:Debug("D.M.SP:[%s, %s]", this, name)
		self:skinAllButtons{obj=_G[this:GetName()..name], x1=-1, x2=1}
		if this.dropdown then
			self:skinDropDown{obj=this.dropdown}
		end
		local stEB = _G[this:GetName()..name.."StateText"]
		if stEB then
			self:skinEditBox{obj=stEB, regs={9}, y=10}
		end
	end)	

end
