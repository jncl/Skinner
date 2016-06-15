local aName, aObj = ...
if not aObj:isAddonEnabled("ServerHop") then return end
local _G = _G

function aObj:ServerHop() -- v1.20

	-- ServerHop_Init
	self:addSkinFrame{obj=hopAddon, ofs=-2}
	self:skinButton{obj=hopAddon_LFGWarning.btn}

	-- MainFrame
	self:skinButton{obj=hopAddon.buttonChangeMode}
	hopAddon.buttonChangeMode:DisableDrawLayer("BACKGROUND")

	-- HopFrame
	hopAddon.hopFrame.background:SetTexture(nil)
	self:skinDropDown{obj=hopAddon.hopFrame.pvpDrop}
	self:skinDropDown{obj=hopAddon.hopFrame.dropDown}
	self:skinButton{obj=hopAddon.hopFrame.buttonHop}
	hopAddon.hopFrame.buttonHop:DisableDrawLayer("BACKGROUND")
	hopAddon.hopFrame.buttonHop:GetPushedTexture():SetTexture(nil)
	self:skinButton{obj=hopAddon.hopFrame.buttonHopBack}
	hopAddon.hopFrame.buttonHopBack:DisableDrawLayer("BACKGROUND")

	-- SearchFrame
	hopAddon.searchFrame.background:SetTexture(nil)
	self:skinDropDown{obj=hopAddon.searchFrame.dungeonsDrop}
	self:skinDropDown{obj=hopAddon.searchFrame.raidsDrop}
	self:skinDropDown{obj=hopAddon.searchFrame.dropDown}
	self:skinEditBox{obj=hopAddon.searchFrame.searchBox, regs={9, 10}, mi=true}
	local hCF = hopAddon.searchFrame.holderCatFilters
	self:addSkinFrame{obj=hCF, ofs=-6}
	self:skinEditBox{obj=hCF.timeEdit, regs={9}}
	self:skinEditBox{obj=hCF.ilvlEdit, regs={9}}
	-- skin search result buttons
	local kids = {hopAddon.searchFrame.searchBox:GetChildren()}
	local r, g, b, a = unpack(self.bbColour)
	for _, child in _G.ipairs(kids) do
		if self:getInt(child:GetWidth()) == 228 then
			child:SetBackdrop(self.Backdrop[1])
			child:SetBackdropBorderColor(r, g, b, a)
		end
	end
	kids = nil

	-- ServerHop_Favourites
	local fF = hopAddon.favouritesFrame
	self:addSkinFrame{obj=fF, ofs=-2}
	fF.bg:SetTexture(nil)
	fF.closeButton:SetSize(22, 22)
	self:skinScrollBar{obj=fF.scrollframe}
	self:skinButton{obj=fF.scrollframe.buttonAdd}
	fF.scrollframe.buttonAdd:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=fF.editFrame.editBoxName, regs={9}}
	self:addSkinFrame{obj=fF.editFrame.editBoxWords, ofs=5}
	self:skinButton{obj=fF.editFrame.buttonSave}
	fF.editFrame.buttonSave:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=fF.editFrame.buttonCancel}
	fF.editFrame.buttonCancel:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=fF.editFrame.buttonDelete}
	fF.editFrame.buttonDelete:DisableDrawLayer("BACKGROUND")

	-- SettingFrame
	local oF = hopAddon.optionsFrame
	self:addSkinFrame{obj=oF, ofs=-4}
	oF.closeButton:SetSize(20, 20)
	oF.header:SetTexture(nil)
	self:moveObject{obj=oF.headerString, x=0, y=-6}
	self:addSkinFrame{obj=oF.optionsAuthor}
	self:skinEditBox{obj=oF.optionsAuthor.linkBox, regs={9}}
	self:addSkinFrame{obj=oF.tabList}
	self:addSkinFrame{obj=oF.globalOptionsFrame}
	self:skinDropDown{obj=oF.globalOptionsFrame.statusFrameDrop}
	self:addSkinFrame{obj=oF.customSearchOptionsFrame}
	if oF.customSearchOptionsFrame.languageFilterButton then
		self:skinButton{obj=oF.customSearchOptionsFrame.languageFilterButton}
	end
	self:addSkinFrame{obj=oF.hopSearchOptionsFrame}
	self:skinButton{obj=oF.hopSearchOptionsFrame.buttonClearBL}
	oF.hopSearchOptionsFrame.buttonClearBL:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=self:getChild(oF.hopSearchOptionsFrame, oF.hopSearchOptionsFrame:GetNumChildren() - 2), regs={9}}
	self:skinEditBox{obj=oF.hopSearchOptionsFrame.linkBox, regs={9}}
	self:addSkinFrame{obj=oF.aboutTab}

	-- ServerHop_GroupCreation
	self:addSkinFrame{obj=hopAddon.groupCreationHolder, ofs=-4}
	self:skinButton{obj=hopAddon.groupCreationHolder.createGroup}
	hopAddon.groupCreationHolder.createGroup:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=hopAddon.groupCreationHolder.editBoxName, regs={9}, move=true}
	self:addSkinFrame{obj=hopAddon.groupCreationHolder.editBoxWords, ofs=5}
	hopAddon.groupCreationHolder.editBoxWords:DisableDrawLayer("BACKGROUND")

	-- ServerHop_Status
	self:addSkinFrame{obj=hopAddon.hopStatus}
	local gSF = hopAddon.hopStatus.groupStatusFrame
	self:skinButton{obj=gSF.convertToParty}
	gSF.convertToParty:DisableDrawLayer("BACKGROUND")
	gSF.convertToParty:SetWidth(120)
	self:skinButton{obj=gSF.convertToRaid}
	gSF.convertToRaid:DisableDrawLayer("BACKGROUND")
	gSF.convertToRaid:SetWidth(120)
	self:skinButton{obj=gSF.leaveButton}
	gSF.leaveButton:DisableDrawLayer("BACKGROUND")

	-- ServerHop_Queue
	local kids = {hopAddon:GetChildren()}
	for _, child in _G.ipairs(kids) do
		if self:getInt(child:GetWidth()) == 40 then
			self:skinButton{obj=child}
		end
	end
	kids = nil

end
