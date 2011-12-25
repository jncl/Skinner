local aName, aObj = ...
if not aObj:isAddonEnabled("AdiBags") then return end

function aObj:AdiBags()

	local aBag = LibStub("AceAddon-3.0"):GetAddon("AdiBags", true)
	
	-- hook this for equipped bag panel creation
	if self.modBtnBs then
		self:RawHook(aBag, "CreateBagSlotPanel", function(this, ...)
			local bPanel = self.hooks[this].CreateBagSlotPanel(this, ...)
			self:addSkinFrame{obj=bPanel}
			for _, v in pairs(bPanel.buttons) do
				self:addButtonBorder{obj=v}
			end
			return bPanel
		end, true)
	end
	-- hook this for bag creation
	aBag:HookBagFrameCreation(aObj, function(bag)
		aObj:ScheduleTimer(function(bag)
			local frame = bag:GetFrame()
			aObj:Debug("OnBagFrameCreated: [%s, %s, %s]", bag, bag.bagName, frame)
			aObj:addSkinFrame{obj=frame}
			aObj:skinEditBox{obj=_G[frame:GetName().."SearchBox"], regs={9}, mi=true}
		end, 0.2, bag) -- wait for 2/10th second for frame to be created fully
	end)

end
