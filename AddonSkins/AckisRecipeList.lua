
function Skinner:AckisRecipeList()
	if not self.db.profile.TradeSkillUI then return end

	local ARL
	if LibStub("AceAddon-3.0") then ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true) end
	if not ARL then return end
	
	local hookfunc = ARL.DisplayFrame and "DisplayFrame" or "CreateFrame"

	self:SecureHook(ARL, hookfunc, function()
		if not self.skinFrame[ARL.Frame] then
			ARL.bgTexture:SetAlpha(0)
			self:moveObject{obj=ARL_SwitcherButton, y=-9}
			self:skinDropDown{obj=ARL_DD_Sort}
			self:skinEditBox{obj=ARL_SearchText, regs={9}}
			self:skinScrollBar{obj=ARL_RecipeScrollFrame}
			self:glazeStatusBar(ARL_ProgressBar, 0)
			self:addSkinFrame{obj=ARL.Frame, y1=-9, x2=2, y2=-4}
			-- Flyaway frame (used when Filters button is clicked)
			self:addSkinFrame{obj=ARL.Flyaway, kfs=true, bg=true, x2=2}
			-- Tooltips
			if self.db.profile.Tooltips.skin then
				-- find the tooltips
				for i = 1, ARL.Frame:GetNumChildren() do
					local child = select(i, ARL.Frame:GetChildren())
					if child:IsObjectType("GameTooltip") then
						if self.db.profile.Tooltips.style == 3 then child:SetBackdrop(self.Backdrop[1]) end
						self:SecureHook(child, "Show", function()
							self:skinTooltip(child)
						end)
					end
				end
			end
		end
		self:Unhook(ARL, hookfunc)
	end)
	
	self:SecureHook(ARL, "DisplayTextDump", function(this, ...)
		self:skinScrollBar{obj=ARLCopyScroll}
		self:addSkinFrame{obj=ARLCopyFrame}
		self:Unhook(ARL, "DisplayTextDump")
	end)

end
