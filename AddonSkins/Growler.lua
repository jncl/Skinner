local aName, aObj = ...
if not aObj:isAddonEnabled("Growler") then return end
local _G = _G

function aObj:Growler()

	-- Bar
	self:addSkinFrame{obj=_G.Growler.bar}
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.Growler.bar.lockbtn, ofs=2}
		self:addButtonBorder{obj=_G.Growler.bar.stablebtn, ofs=0, y1=2, y2=-2}
		self:addButtonBorder{obj=_G.Growler.bar.petslotbtn, ofs=0, y1=2, y2=-2}
		for k, v in pairs(_G.Growler.btn) do
			aObj:Debug("Growler btn: [%s, %s]", k, v)
			self:addButtonBorder{obj=v, sec=true}
		end
	end

	-- Stable
	_G.GrowlerStable_TitleFrame:SetBackdrop(nil)
	_G.GrowlerStable_ModelFrame:SetBackdrop(nil)
	_G.GrowlerStable_PetTitleFrame:SetBackdrop(nil)
	self:skinButton{obj=_G.GrowlerStable_Exitbtn, cb=true}
	_G.GrowlerStable_Exitbtn.texture:SetTexture(nil)
	self:addSkinFrame{obj=_G.Growler_Stable, ofs=-10, y1=-16, x2=-16}

end
