local aName, aObj = ...
if not aObj:isAddonEnabled("CollectMe") then return end

function aObj:CollectMe()

	local CM = LibStub("AceAddon-3.0"):GetAddon("CollectMe", true)

	if CM and CM.UI then
		self:moveObject{obj=CM.UI.frame.titlebg, y=-6}
		self:applySkin{obj=CM.UI.tabs.content:GetParent(), kfs=true}
		self:skinEditBox{obj=CM.UI.search_box.editbox, regs={9}}
		self:RawHook(CM.UI.search_box.editbox, "SetTextInsets", function(this, left, right, top, bottom)
			return left + 6, right, top, bottom
		end, true)
		self:skinButton{obj=CM.UI.search_box.button, as=true}
		self:glazeStatusBar(CM.UI.frame.statusbar, 0,  nil)
		self:addSkinFrame{obj=CM.UI.frame.frame, kfs=true}
		-- tooltip
		if self.db.profile.Tooltips.skin then
			self:add2Table(self.ttList, "CollectMeTooltip")
		end

	end

end