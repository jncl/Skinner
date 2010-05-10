if not Skinner:isAddonEnabled("AdiBags") then return end

function Skinner:AdiBags()

	local aBag = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
	
	-- hook this for bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:addSkinFrame{obj=bPanel}
		return bPanel
	end, true)
	-- hook this for bag creation
	aBag:HookBagFrameCreation(self, function(bag)
		self:Debug("OnBagFrameCreated: [%s]", bag)
		if bag.bagName == "Backpack" then self:skinEditBox{obj=AdiBagsSearchEditBox, regs={9}} end
		local frame = bag:GetFrame()
		self:addSkinFrame{obj=frame}
	end)

end
