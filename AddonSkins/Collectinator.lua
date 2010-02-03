
function Skinner:Collectinator()

	-- button on PetPaperDoll frame
	self:skinButton{obj=Collectinator.ScanButton, ty=0}

	-- skin the frame
	self:SecureHook(Collectinator, "DisplayFrame", function(this)
		Collectinator.bgTexture:SetAlpha(0)
		self:moveObject{obj=this.Frame.mode_button, y=-9}
		self:skinDropDown{obj=Collectinator_DD_Sort}
		self:skinEditBox{obj=Collectinator_SearchText, regs={9}}
		self:glazeStatusBar(this.Frame.progress_bar, 0)
		self:skinScrollBar{obj=Collectinator_CollectibleScrollFrame}
		self:addSkinFrame{obj=this.Frame, y1=-9, x2=2, y2=-4}
		self:addSkinFrame{obj=this.Flyaway, kfs=true, bg=true, x2=2}
		-- tooltips
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then CollectinatorSpellTooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHookScript(CollectinatorSpellTooltip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
		end
		-- buttons
		self:skinAllButtons{obj=this.Frame} -- not working as the textures aren't named !!!
		--	minus/plus buttons
		for i = 1, #this.PlusListButton do 
			self:skinButton{obj=this.PlusListButton[i], mp2=true, plus=true, tx=-3, ty=0}
		end
		self:Unhook(Collectinator, "DisplayFrame")
	end)
	
end
