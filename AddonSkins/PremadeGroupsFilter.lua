local _, aObj = ...
if not aObj:isAddonEnabled("PremadeGroupsFilter") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.PremadeGroupsFilter = function(self) -- v 4.0.1

	local function skinCBAct(checkbtn)
		if not checkbtn then
			return
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=checkbtn.Act}
		end
	end
	local function skinDD(parent)
		aObj:skinObject("dropdown", {obj=parent.Difficulty.DropDown})
		aObj:SecureHookScript(parent.Difficulty.DropDown.Button, "OnClick", function(this)
			aObj:skinObject("frame", {obj=aObj:getLastChild(parent), kfs=true, rns=true, ofs=0})
			aObj:Unhook(this, "OnClick")
		end)
	end
	local function skinMinMax(minmax)
		if not minmax then
			return
		end
		aObj:skinObject("editbox", {obj=minmax.Min})
		aObj:skinObject("editbox", {obj=minmax.Max})
		skinCBAct(minmax)
	end
	self:SecureHookScript(_G.PremadeGroupsFilterDialog, "OnShow", function(this)
		this.MaximizeMinimizeFrame:DisableDrawLayer("BACKGROUND")
		self:removeMagicBtnTex(this.ResetButton)
		self:removeMagicBtnTex(this.RefreshButton)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=1, y1=2, y2=-2})
		if self.modBtns then
			self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
			self:skinStdButton{obj=this.ResetButton}
			self:skinStdButton{obj=this.RefreshButton}
		end

		for _, name in _G.pairs{"Arena", "Dungeon", "Expression", "Raid", "RBG"} do
			local panel = _G["PremadeGroupsFilter" .. name .. "Panel"]
			if panel.Group then
				if panel.Group.Difficulty then
					skinDD(panel.Group)
					skinCBAct(panel.Group.Difficulty)
				end
				for _, mmName in _G.pairs{"PvPRating", "MPRating", "Members", "Tanks", "Heals", "DPS", "Defeated"} do
					skinMinMax(panel.Group[mmName])
				end
				for _, mmName in _G.pairs{"Partyfit", "BLFit", "BRFit", "MatchingId"} do
					skinCBAct(panel.Group[mmName])
				end
			end
			if panel.Dungeons then
				for i = 1, 8 do
					skinCBAct(panel.Dungeons["Dungeon" .. i])
				end
			end
			if panel.Sorting then
				self:skinObject("editbox", {obj=panel.Sorting.Expression})
			end
			self:skinObject("scrollbar", {obj=panel.Advanced.Expression.ScrollBar})
			self:skinObject("frame", {obj=panel.Advanced.Expression, kfs=true, fb=true, ofs=6})
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PremadeGroupsFilterStaticPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("editbox", {obj=this.EditBox})
		self:skinObject("frame", {obj=this, kfs=true, ofs=-4})
		if self.modBtns then
			self:skinStdButton{obj=this.Button1}
			self:skinStdButton{obj=this.Button2}
			self:skinStdButton{obj=this.Button3}
			self:skinStdButton{obj=this.Button4}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.modChkBtns then
		self:skinCheckButton{obj=_G.UsePGFButton}
	end

end
