local _, aObj = ...
if not aObj:isAddonEnabled("PremadeGroupsFilter") then return end
local _G = _G

aObj.addonsToSkin.PremadeGroupsFilter = function(self) -- v 3.8.3

	local dialog = _G.PremadeGroupsFilterDialog

	dialog.MaximizeMinimizeFrame:DisableDrawLayer("BACKGROUND")
	if self.modBtns then
		self:skinOtherButton{obj=dialog.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
		self:skinOtherButton{obj=dialog.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
	end
	self:skinObject("dropdown", {obj=dialog.Difficulty.DropDown})
	self:SecureHookScript(dialog.Difficulty.DropDown.Button, "OnClick", function(this)
		self:skinObject("frame", {obj=self:getLastChild(_G.PremadeGroupsFilterDialog), ofs=0})
		self:Unhook(this, "OnClick")
	end)
	for _, name in _G.pairs{"Defeated", "MPRating", "PVPRating", "Members", "Tanks", "Heals", "Dps"} do
		self:skinObject("editbox", {obj=dialog[name].Min})
		self:skinObject("editbox", {obj=dialog[name].Max})
		if self.modChkBtns then
			self:skinCheckButton{obj=dialog[name].Act}
		end
	end
	self:skinObject("editbox", {obj=dialog.Sorting.SortingExpression})
	self:skinObject("scrollbar", {obj=dialog.Expression.ScrollBar})
	self:skinObject("frame", {obj=dialog.Expression, kfs=true, fb=true, ofs=6})
	self:removeMagicBtnTex(dialog.ResetButton)
	self:removeMagicBtnTex(dialog.RefreshButton)
	self:skinObject("frame", {obj=dialog, kfs=true, cb=true, ofs=1, y1=2, y2=-3})
	if self.modBtns then
		self:skinStdButton{obj=dialog.ResetButton}
		self:skinStdButton{obj=dialog.RefreshButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=dialog.Difficulty.Act}
	end

end
