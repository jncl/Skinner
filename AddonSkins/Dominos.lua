
function Skinner:Dominos_Config()

	-- hook the create menu function
	self:SecureHook(Dominos.Menu, "New", function(this, name)
--		self:Debug("D.M.N:[%s, %s]", this, name)
		self:applySkin(_G["DominosFrameMenu"..name])
		end)
	self:SecureHook(Dominos.Menu, "ShowPanel", function(this, name)
--		self:Debug("D.M.SP:[%s, %s, %s]", this, this:GetName(), name)
		if this.dropdown and not this.dropdown.sknned then
			self:skinDropDown(this.dropdown)
			this.dropdown.sknned = true
		end
		if this:GetName()..name..'StateText' then self:skinEditBox(_G[this:GetName()..name..'StateText'], {9}) end
		end)

end
