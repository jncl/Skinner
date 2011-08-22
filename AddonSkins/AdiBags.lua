local aName, aObj = ...
if not aObj:isAddonEnabled("AdiBags") then return end

function aObj:AdiBags()

	local aBag = LibStub("AceAddon-3.0"):GetAddon("AdiBags", true)
	
	-- hook this for bag panel creation
	self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
		local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
		self:addSkinFrame{obj=bPanel}
		for _, v in pairs(bPanel.buttons) do
			self:addButtonBorder{obj=v}
		end
		return bPanel
	end, true)
	-- hook this for bag creation
	aBag:HookBagFrameCreation(aObj, function(bag)
		aObj:ScheduleTimer(function(bag) 
			aObj:Debug("OnBagFrameCreated: [%s, %s]", bag, bag.bagName)
			aObj:addSkinFrame{obj=bag:GetFrame()}
			if bag.bagName == "Backpack" then aObj:skinEditBox{obj=AdiBagsSearchFrame, regs={9}} end
		end, 0.2, bag) -- wait for 2/10th second for frame to be created fully
	end)

end
