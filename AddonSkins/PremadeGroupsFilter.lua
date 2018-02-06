-- many thanks to acirac for this skin
local aName, aObj = ...
if not aObj:isAddonEnabled("PremadeGroupsFilter") then return end
local _G = _G

aObj.addonsToSkin.PremadeGroupsFilter = function(self) -- v 1.17

	local dialog = _G.PremadeGroupsFilterDialog

	if self.modChkBtns then
		self:skinCheckButton{obj=_G.UsePFGButton}
	end

    self:skinDropDown{obj=dialog.Difficulty.DropDown}
	-- hook this to skin dropdown menu
	self:SecureHookScript(dialog.Difficulty.DropDown.Button, "OnClick", function(this)
		self:addSkinFrame{obj=self:getLastChild(_G.PremadeGroupsFilterDialog), ft="a", nb=true}
		self:Unhook(this, "OnClick")
	end)

	dialog.Advanced:DisableDrawLayer("BACKGROUND")
	dialog.Advanced:DisableDrawLayer("BORDER")

	self:skinCheckButton{obj=dialog.Difficulty.Act}
	self:skinCheckButton{obj=dialog.Ilvl.Act}
    self:skinEditBox{obj=dialog.Ilvl.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Ilvl.Max, x=-8, y=4}
	self:skinCheckButton{obj=dialog.Noilvl.Act}
	self:skinCheckButton{obj=dialog.Defeated.Act}
    self:skinEditBox{obj=dialog.Defeated.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Defeated.Max, x=-8, y=4}
	self:skinCheckButton{obj=dialog.Members.Act}
    self:skinEditBox{obj=dialog.Members.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Members.Max, x=-8, y=4}
	self:skinCheckButton{obj=dialog.Tanks.Act}
    self:skinEditBox{obj=dialog.Tanks.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Tanks.Max, x=-8, y=4}
	self:skinCheckButton{obj=dialog.Heals.Act}
    self:skinEditBox{obj=dialog.Heals.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Heals.Max, x=-8, y=4}
	self:skinCheckButton{obj=dialog.Dps.Act}
    self:skinEditBox{obj=dialog.Dps.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Dps.Max, x=-8, y=4}

    self:addSkinFrame{obj=dialog.Expression, ft="a", kfs=true, nb=true, x1=-4, x2=6, y1=4, y2=-5}
    self:skinSlider{obj=dialog.Expression.ScrollBar}

	self:skinStdButton{obj=dialog.ResetButton}
	self:removeMagicBtnTex(dialog.ResetButton)
	self:skinStdButton{obj=dialog.RefreshButton}
	self:removeMagicBtnTex(dialog.RefreshButton)
    self:addSkinFrame{obj=dialog, ft="a", kfs=true, ofs=1, y1=2, y2=-5}

	dialog = nil

end
