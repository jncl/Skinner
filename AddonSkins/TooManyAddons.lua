local _G = _G

function Skinner:TooManyAddons()

	local TMAaddonframe = _G[TMA_ADDON_LIST_NAME.."frame"]
	local TMAprofileframe = _G[TMA_PROFILE_LIST_NAME.."frame"]
	local TMAglobalprofileframe = _G[TMA_GLOBAL_PROFILE_LIST_NAME.."frame"]
	-- Frames
	self:skinAllButtons{obj=TMAaddonframe}
	self:addSkinFrame{obj=TMAaddonframe}
	self:skinAllButtons{obj=TMAprofileframe}
	self:addSkinFrame{obj=TMAprofileframe}
	self:skinAllButtons{obj=TMAglobalprofileframe}
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
	self:skinDropDown{obj=TMAimportmenu}
	self:skinDropDown{obj=TMAsortMenu}

end
