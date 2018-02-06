local aName, aObj = ...
if not aObj:isAddonEnabled("ServerHop") then return end
local _G = _G

aObj.addonsToSkin.ServerHop = function(self) -- v 7.3.0.1

	-- ServerHop_Init
	self:skinButton{obj=self:getLastChild(_G.LFGListFrame)}

	-- HopFrame
	self:addButtonBorder{obj=_G.ServerHop.buttonOptions, ofs=-1}
	self:addButtonBorder{obj=_G.ServerHop.closeButton, ofs=-1}
	_G.ServerHop.hopFrame.background:SetTexture(nil)
	self:skinDropDown{obj=_G.ServerHop.hopFrame.pvpDrop}
	self:skinDropDown{obj=_G.ServerHop.hopFrame.dropDown}
	self:skinButton{obj=_G.ServerHop.hopFrame.buttonHop}
	_G.ServerHop.hopFrame.buttonHop:DisableDrawLayer("BACKGROUND")
	_G.ServerHop.hopFrame.buttonHop:GetPushedTexture():SetTexture(nil)
	self:addButtonBorder{obj=_G.ServerHop.hopFrame.buttonResetBL, ofs=-1}
	self:skinEditBox{obj=_G.ServerHop.hopFrame.description, regs={6}, mi=true} -- 6 is text
	self:addSkinFrame{obj=_G.ServerHop.hopFrame, nb=true}

	-- SettingFrame
	local oF = _G.ServerHop.optionsFrame
	self:addSkinFrame{obj=oF, ofs=-4}
	oF.closeButton:SetSize(20, 20)
	oF.header:SetTexture(nil)
	self:moveObject{obj=oF.headerString, x=0, y=-6}
	self:addSkinFrame{obj=oF.optionsAuthor}
	self:skinEditBox{obj=oF.optionsAuthor.linkBox, regs={6}}
	self:addSkinFrame{obj=oF.tabList}
	self:addSkinFrame{obj=oF.hopSearchOptionsFrame}
	self:skinEditBox{obj=oF.hopSearchOptionsFrame.linkBox, regs={6}}
	self:addSkinFrame{obj=oF.aboutTab}
	oF = nil

	-- ServerHop_Queue buttons
	local kids = {_G.ServerHop:GetChildren()}
	for _, child in _G.ipairs(kids) do
		if self:getInt(child:GetWidth()) == 40 then
			self:skinButton{obj=child}
		end
	end
	kids = nil

end
