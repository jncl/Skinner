local aName, aObj = ...
if not aObj:isAddonEnabled("TooManyAddons") then return end

function aObj:TooManyAddons()

	local TMAaddonframe = _G[TMA_ADDON_LIST_NAME.."frame"]
	local TMAprofileframe = _G[TMA_PROFILE_LIST_NAME.."frame"]
	local TMAglobalprofileframe = _G[TMA_GLOBAL_PROFILE_LIST_NAME.."frame"]
	-- Frames
	TMAoptionbutton:SetWidth(20)
	TMAclosebutton:SetWidth(20)
	TMAclosebutton:SetText("X")
	self:addSkinFrame{obj=TMAaddonframe}
	self:addSkinFrame{obj=TMAprofileframe}
	self:addSkinFrame{obj=TMAglobalprofileframe}
	-- scrollbars
	self:skinScrollBar{obj=_G[TMA_ADDON_LIST_NAME.."scrollbar"]}
	self:skinScrollBar{obj=_G[TMA_PROFILE_LIST_NAME.."scrollbar"]}
	self:skinScrollBar{obj=_G[TMA_GLOBAL_PROFILE_LIST_NAME.."scrollbar"]}
	-- editbox
	self:skinEditBox{obj=TMAnewprofileeditbox, regs={9}}
	-- GameMenu Button
	self:skinButton{obj=TMAgamemenubutton}
	-- dropdowns
	self:skinDropDown{obj=TMAimportmenu, x2=27}
	self:skinDropDown{obj=TMAsortMenu, x2=27}

end
