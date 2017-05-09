local aName, aObj = ...
if not aObj:isAddonEnabled("ServerHop") then return end
local _G = _G

function aObj:ServerHop() -- v1.20

	-- ServerHop_Init
	self:addSkinFrame{obj=hopAddon, ofs=0}

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
	self:skinEditBox{obj=hopAddon.hopFrame.description, regs={6}} -- 6 is text

	-- SearchFrame
	hopAddon.searchFrame.background:SetTexture(nil)
	self:skinDropDown{obj=hopAddon.searchFrame.dungeonsDrop}
	self:skinDropDown{obj=hopAddon.searchFrame.raidsDrop}
	self:skinDropDown{obj=hopAddon.searchFrame.dropDown}
	self:skinEditBox{obj=hopAddon.searchFrame.searchBox, regs={6 ,7}, mi=true}
	local hCF = hopAddon.searchFrame.holderCatFilters
	self:addSkinFrame{obj=hCF, ofs=-6}
	self:skinEditBox{obj=hCF.timeEdit, regs={6}}
	self:skinEditBox{obj=hCF.ilvlEdit, regs={6}}
	hCF = nil
	self:skinSlider{obj=hopAddon.searchFrame.scrollframe.scrollBar.ScrollBar}
	for i = 1, 5 do
		-- use applySkin as auti-invite changes background colour
		self:applySkin{obj=hopAddon.searchFrame.scrollframe.rows[i]}
	end

	-- ServerHop_Favourites
	local fF = hopAddon.favouritesFrame
	self:addSkinFrame{obj=fF, ofs=-2}
	fF.bg:SetTexture(nil)
	fF.closeButton:SetSize(22, 22)
	self:skinSlider{obj=fF.scrollframe.ScrollBar}
	self:skinButton{obj=fF.scrollframe.buttonAdd}
	fF.scrollframe.buttonAdd:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=fF.editFrame.editBoxName, regs={6}}
	self:addSkinFrame{obj=fF.editFrame.editBoxWords, ofs=5}
	self:skinButton{obj=fF.editFrame.buttonSave}
	fF.editFrame.buttonSave:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=fF.editFrame.buttonCancel}
	fF.editFrame.buttonCancel:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=fF.editFrame.buttonDelete}
	fF.editFrame.buttonDelete:DisableDrawLayer("BACKGROUND")
	fF = nil

	-- SettingFrame
	local oF = hopAddon.optionsFrame
	self:addSkinFrame{obj=oF, ofs=-4}
	oF.closeButton:SetSize(20, 20)
	oF.header:SetTexture(nil)
	self:moveObject{obj=oF.headerString, x=0, y=-6}
	self:addSkinFrame{obj=oF.optionsAuthor}
	self:skinEditBox{obj=oF.optionsAuthor.linkBox, regs={6}}
	self:addSkinFrame{obj=oF.tabList}
	self:addSkinFrame{obj=oF.globalOptionsFrame}
	self:skinDropDown{obj=oF.globalOptionsFrame.minimapStrataDrop}
	self:skinDropDown{obj=oF.globalOptionsFrame.statusFrameDrop}
	oF.globalOptionsFrame.buttonClearBL:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=oF.globalOptionsFrame.buttonClearBL}
	self:addSkinFrame{obj=oF.customSearchOptionsFrame}
	if oF.customSearchOptionsFrame.languageFilterButton then
		self:skinButton{obj=oF.customSearchOptionsFrame.languageFilterButton}
	end
	self:addSkinFrame{obj=oF.hopSearchOptionsFrame}
	self:skinEditBox{obj=oF.hopSearchOptionsFrame.linkBox, regs={6}}
	oF.hopSearchOptionsFrame.buttonClearBL:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=oF.hopSearchOptionsFrame.buttonClearBL}
	self:addSkinFrame{obj=oF.hostOptionsFrame}
	self:addSkinFrame{obj=oF.aboutTab}
	oF = nil

	-- ServerHop_GroupCreation
	self:addSkinFrame{obj=hopAddon.EntryCreationHolder, ofs=-4}
	self:skinButton{obj=hopAddon.EntryCreationHolder.createGroup}
	hopAddon.EntryCreationHolder.createGroup:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=hopAddon.EntryCreationHolder.editBoxName, regs={6}, move=true}
	self:addSkinFrame{obj=hopAddon.EntryCreationHolder.editBoxWords, ofs=5}
	hopAddon.EntryCreationHolder.editBoxWords:DisableDrawLayer("BACKGROUND")

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
	gSF = nil

	-- ServerHop_Queue
	local kids = {hopAddon:GetChildren()}
	for _, child in _G.ipairs(kids) do
		if self:getInt(child:GetWidth()) == 40 then
			self:skinButton{obj=child}
		end
	end
	kids = nil

	-- hostFrame
	self:skinDropDown{obj=hopAddon.hostFrame.sizeDrop}
	hopAddon.hostFrame.buttonHost:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=hopAddon.hostFrame.buttonHost}
	hopAddon.hostFrame.openList:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=hopAddon.hostFrame.openList}
	hopAddon.hostFrame.background:SetTexture(nil)
	self:addSkinFrame{obj=hopAddon.hostFrame}

	-- hostingGroupFrame
	self:skinButton{obj=hopAddon.hostFrame.hostingGroupFrame.buttonStop}

	-- HopList
	self:skinSlider{obj=hopAddon.hopList.scrollframe.ScrollBar}
	self:addSkinFrame{obj=hopAddon.hopList, kfs=true}
	-- remove Header backdrop
	self:SecureHook(hopAddon.hopList, "RecreateList", function(this)
		local kids = {this.scrollframe.scrollchild:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child.textHeader then
				child:SetBackdrop(nil)
			end
		end
		kids = nil
	end)

end
