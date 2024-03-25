local _, aObj = ...
if not aObj:isAddonEnabled("!Swatter") then return end
local _G = _G

aObj.addonsToSkin["!Swatter"] = function(self) -- v 3.4.6977

	-- handle the fact that the AddOn was loaded but, due to it checking for another debugging aid, didn't initialise
	if _G.Swatter
	and _G.Swatter.Version
	then
		self:skinObject("slider", {obj=_G.Swatter.Error.Scroll.ScrollBar})
		self:skinObject("frame", {obj=_G.Swatter.Error})
		if self.modBtns then
			self:skinStdButton{obj=_G.Swatter.Error.Done}
			self:skinStdButton{obj=_G.Swatter.Error.Next, schk=true}
			self:skinStdButton{obj=_G.Swatter.Error.Prev, schk=true}
		end
	end

end
