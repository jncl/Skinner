local aName, aObj = ...
if not aObj:isAddonEnabled("Leatrix_Plus") then return end
local _G = _G

aObj.addonsToSkin.Leatrix_Plus = function(self) -- v 1.13.30

	local function skinKids(frame)
		for _, child in ipairs{frame:GetChildren()} do
			if child:IsObjectType("Slider") then
				aObj:skinSlider{obj=child, hgt=-4}
			elseif child:IsObjectType("ScrollFrame") then
				aObj:skinSlider{obj=child.ScrollBar}
			elseif child:IsObjectType("EditBox") then
				aObj:skinEditBox{obj=child, regs={6}} -- 6 is text
				child.f:SetBackdrop(nil)
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button")
			and child.tiptext
			and aObj.modBtns
			then
				aObj:skinStdButton{obj=child}
			elseif child:IsObjectType("Frame")
			and child:GetNumChildren() == 2
			and aObj:getChild(child, 1):GetNumRegions() == 5
			then
				local dd = aObj:getChild(child, 1) -- dropdown frame
				dd.Left = aObj:getRegion(dd, 1)
				dd.Right = aObj:getRegion(dd, 2)
				dd.Button = aObj:getChild(dd, 1)
				aObj:skinDropDown{obj=dd}
				aObj:addSkinFrame{obj=aObj:getChild(child, 2), ft="a", kfs=true, nb=true, ofs=0} -- dropdown list
				dd = nil
			end
		end
	end

	-- LeaPlusGlobalPanel
	skinKids(_G.LeaPlusGlobalPanel)
	self:addSkinFrame{obj=_G.LeaPlusGlobalPanel, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinCloseButton{obj=self:getChild(_G.LeaPlusGlobalPanel, 2)}
	end

	-- Pages
	for _, frame in _G.ipairs{_G.LeaPlusGlobalPanel:GetChildren()} do
		if frame:IsObjectType("Frame") then
			skinKids(frame)
		end
	end

	-- Side frames
	for _, frameRef in pairs{"ChainPanel", "SideMinimap", "QuestTextPanel", "MailTextPanel", "SideFrames", "CooldownPanel", "SideTip", "SideViewport"} do
		local sideF = _G["LeaPlusGlobalPanel_" .. frameRef]
		if sideF then
			skinKids(sideF)
			self:addSkinFrame{obj=sideF, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinCloseButton{obj=sideF.c}
			end
		end
	end

end
