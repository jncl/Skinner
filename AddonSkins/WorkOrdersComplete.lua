local _, aObj = ...
if not aObj:isAddonEnabled("WorkOrdersComplete") then return end
local _G = _G

aObj.addonsToSkin.WorkOrdersComplete = function(self) -- v 2.8

	self:SecureHookScript(_G.WorkOrdersCompleteUIMainFrame, "OnShow", function(this)
		local fName = this:GetName()
		self:skinObject("tabs", {obj=_G[fName .. "SubFrameHeader"], prefix=fName .. "SubFrameHeader", ignoreSize=true,  offsets={x1=4, y1=-6, x2=-4, y2=-6}})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3})
		local sfName = "Tab1SubFrame"
		local btn
		for _, bName in _G.pairs{"Icon", "Ready", "InProgress", "Capacity", "NextOut", "AllOut", "No"} do
			btn = _G[fName .. sfName .. bName .. "ColumnHeaderButton"]
			self:removeRegions(btn, {1, 2, 3})
			self:skinObject("frame", {obj=btn, ofs=0})
			self:adjHeight{obj=btn, adj=1}
		end
		btn = nil
		self:skinObject("slider", {obj=_G[fName .. sfName .. "ScrollFrame"].ScrollBar, rpTex="artwork"})
		self:skinObject("frame", {obj=_G[fName .. sfName], fb=true, ofs=5, x1=-10, x2=11, y2=-6})
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. sfName .. "RefreshButton"]}
		end
		sfName = "Tab2SubFrame"
		self:skinObject("dropdown", {obj=_G[fName .. sfName .. "CharacterDropDownMenu"]})
		self:skinObject("frame", {obj=_G[fName .. sfName], fb=true, ofs=5, x1=-10, x2=11, y2=-6})
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. sfName .. "DeleteCharacterButton"]}
		end
		if self.modChkBtns then
			for i = 1, 9 do
				self:skinCheckButton{obj=_G[fName .. sfName .. "BuildingCheckButton" .. i]}
			end
			self:skinCheckButton{obj=_G[fName .. sfName .. "GCacheCheckButton"]}
		end
		sfName = "Tab3SubFrame"
		self:skinObject("dropdown", {obj=_G[fName .. sfName .. "AlertTypeDropDownMenu"]})
		self:skinObject("dropdown", {obj=_G[fName .. sfName .. "AlertSecondsDropDownMenu"]})
		self:skinObject("frame", {obj=_G[fName .. sfName], fb=true, ofs=5, x1=-10, x2=11, y2=-6})
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[fName .. sfName .. "showMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[fName .. sfName .. "showCharacterRealmsCheckButton"]}
		end
		sfName = "Tab4SubFrame"
		self:skinObject("frame", {obj=_G[fName .. sfName], fb=true, ofs=5, x1=-10, x2=11, y2=-6})

		fName, sfName = nil, nil

		self:Unhook(this, "OnShow")
	end)

end
