local aName, aObj = ...
if not aObj:isAddonEnabled("ACP") then return end
local _G = _G

function aObj:ACP()

	_G.ACP_AddonList:SetScale(0.75) -- shrink frame

	self:skinDropDown{obj=_G.ACP_AddonListSortDropDown, x2=110}
	self:skinScrollBar{obj=_G.ACP_AddonList_ScrollFrame}
	self:addSkinFrame{obj=_G.ACP_AddonList, kfs=true, hdr=true, x1=12, x2=-40, y2=12}
	-- skin the buttons
	self:skinButton{obj=_G.ACP_AddonListCloseButton, cb=true}
	self:skinButton{obj=_G.ACP_AddonListDisableAll}
	self:skinButton{obj=_G.ACP_AddonListEnableAll}
	self:skinButton{obj=_G.ACP_AddonListSetButton}
	self:skinButton{obj=_G.ACP_AddonList_ReloadUI}
	self:skinButton{obj=_G.ACP_AddonListBottomClose}
	for i = 1, 20 do
		self:skinButton{obj=_G["ACP_AddonListEntry"..i.."LoadNow"]}
	end

	-- skin GameMenuFrame button and adjust GameMenuFrame height
	self:skinButton{obj=_G.GameMenuButtonAddOns}
	self:SecureHook("GameMenuFrame_UpdateVisibleButtons", function(this)
		if self:getInt(_G.GameMenuFrame:GetHeight()) < 335 then
			self:adjHeight{obj=_G.GameMenuFrame, adj=25}
		end
	end)

end
