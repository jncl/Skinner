local _, aObj = ...
if not aObj:isAddonEnabled("REFlex") then return end
local _G = _G

aObj.addonsToSkin.REFlex = function(self) -- v 2.75

	self:SecureHookScript(_G.REFlexFrame, "OnShow", function(this)
		self:moveObject{obj=_G.REFlexFrame_Title, y=-6}
		_G.REFlexFrame_HKBar:SetBackdrop(nil)
		self:skinScrollingTable(_G.REFlex.TableBG)
		self:skinScrollingTable(_G.REFlex.TableArena)
		self:skinStatusBar{obj=_G.REFlexFrame_HKBar_I, fi=0}
		self:skinAceDropdown(_G.REFlex.SpecDropDown, nil, 0)
		self:skinAceDropdown(_G.REFlex.BracketDropDown, nil, 0)
		self:skinAceDropdown(_G.REFlex.MapDropDown, nil, 0)
		self:skinAceDropdown(_G.REFlex.DateDropDown, nil, 0)
		self:addSkinFrame{obj=_G.REFlexFrame, ft="a", kfs=true, nb=true, hdr=true, y2=-1}
		self:skinTabs{obj=this, lod=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.REFlexFrame_CloseButton}
			self:skinStdButton{obj=_G.REFlexFrame_DumpButton}
			self:skinStdButton{obj=_G.REFlexFrame_StatsButton}
		end

		self:skinTextDump(_G.REFlex.DumpFrame)

		self:Unhook(this, "OnShow")
	end)

end
