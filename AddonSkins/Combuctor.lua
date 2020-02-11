local _, aObj = ...
if not aObj:isAddonEnabled("Combuctor") then return end
local _G = _G

aObj.addonsToSkin.Combuctor = function(self) -- v 8.3.1
	if not self.db.profile.ContainerFrames.skin then return end

	local function skinTabs(frame)

		local tab
		for i = 1, #frame.bottomFilter.buttons do
			tab = frame.bottomFilter.buttons[i]
			if not tab.sknd then
				aObj:keepRegions(tab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
				aObj:addSkinFrame{obj=tab, ft="a", kfs=true, nb=true, noBdr=aObj.isTT, x1=6, y1=4, x2=-6, y2=2}
				if i == 1 then
					if aObj.isTT then aObj:setActiveTab(tab.sf) end
				else
					if aObj.isTT then aObj:setInactiveTab(tab.sf) end
				end
				aObj:secureHook(tab, "UpdateHighlight", function(this)
					skinTabs(frame)
				end)
			end

			if tab.id == frame.subrule or tab.id == frame.rule and not frame.subrule then
				aObj:setActiveTab(tab.sf)
			else
				aObj:setInactiveTab(tab.sf)
			end
		end
		tab = nil

	end
	local function skinFrame(frame)

		if frame.sf then return end

		-- frame
		self:removeNineSlice(frame.NineSlice)
		self:moveObject{obj=frame.ownerSelector, x=6, y=-8}
		self:skinEditBox{obj=frame.searchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		frame.bagToggle.Border:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ri=true}
		if self.modBtns then
			self:skinCloseButton{obj=frame.CloseButton}
		end
		--side tabs
		for i = 1, #frame.sideFilter.buttons do
			self:removeRegions(frame.sideFilter.buttons[i], {1}) -- N.B. other regions are icon and highlight
		end
		--bottom tabs
		skinTabs(frame)

	end
	-- hook this to skin new frames
	self:RawHook(_G.Combuctor.Frames, "New", function(this, id)
		local frame = self.hooks[this].New(this, id)
		if frame then
			skinFrame(frame, id)
			return frame
		else
			return
		end
	end)

end
