-- many thanks to acirac for this skin
local aName, aObj = ...
if not aObj:isAddonEnabled("PremadeGroupsFilter") then return end
local _G = _G

function aObj:PremadeGroupsFilter()

	local dialog = _G.PremadeGroupsFilterDialog

    self:skinDropDown{obj=dialog.Difficulty.DropDown}
	-- hook this to skin dropdown menu
	self:SecureHookScript(dialog.Difficulty.DropDown.Button, "OnClick", function(this)
		self:addSkinFrame{obj=self:getChild(_G.PremadeGroupsFilterDialog, _G.PremadeGroupsFilterDialog:GetNumChildren())}
		self:Unhook(this, "OnClick")
	end)

	dialog.Advanced:DisableDrawLayer("BACKGROUND")
	dialog.Advanced:DisableDrawLayer("BORDER")

    self:skinEditBox{obj=dialog.Ilvl.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Ilvl.Max, x=-8, y=4}
    self:skinEditBox{obj=dialog.Defeated.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Defeated.Max, x=-8, y=4}
    self:skinEditBox{obj=dialog.Members.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Members.Max, x=-8, y=4}
    self:skinEditBox{obj=dialog.Tanks.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Tanks.Max, x=-8, y=4}
    self:skinEditBox{obj=dialog.Heals.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Heals.Max, x=-8, y=4}
    self:skinEditBox{obj=dialog.Dps.Min, x=-8, y=4}
    self:skinEditBox{obj=dialog.Dps.Max, x=-8, y=4}

    self:addSkinFrame{obj=dialog.Expression, kfs=true, x1=-4, x2=6, y1=4, y2=-5}
    self:skinSlider{obj=dialog.Expression.ScrollBar}

	self:removeMagicBtnTex(dialog.ResetButton)
	self:removeMagicBtnTex(dialog.RefreshButton)

    self:addSkinFrame{obj=dialog, kfs=true, ofs=1, y1=2, y2=-5}

	dialog = nil

end
