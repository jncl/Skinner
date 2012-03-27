local aName, aObj = ...
if not aObj:isAddonEnabled("CFM") then return end

function aObj:CFM()

	self:SecureHook("CFM_GUI", function(this)
		CFM_Config:SetScale(1.25)
		self:addSkinFrame{obj=CFM_Config}
		-- Mouseover panel
		CFM_MouseOverActive:SetTextColor(self.BTr, self.BTg, self.BTb)
		CFM_MouseOverActiveParent:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addSkinFrame{obj=CFM_MouseInfoFrame, y2=-2}
		-- Scroll panel
		for i = 1, 8 do
			_G["CFM_ScrollButton"..i]:SetBackdrop(nil)
		end
		-- don't skin scrollbar as the scrollbar moves too far right when its width is changed
		self:addSkinFrame{obj=CFM_ScrollFrame, kfs=true}
		-- Properties panel (1)
		for _, label in pairs{"Width", "Height", "Scale", "Level", "Alpha"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_"..label.."_Plus"], mp2=true, plus=true, noWidth=true}
			self:skinButton{obj=_G["CFM_"..label.."_Minus"], mp2=true}
		end
		self:addSkinFrame{obj=CFM_Panel1}
		-- Anchor panel (2)
		self:skinEditBox{obj=CFM_ChangeParentBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinDropDown{obj=CFM_FromBox}
		self:skinDropDown{obj=CFM_ToBox}
		self:skinDropDown{obj=CFM_StrataBox}
		for _, label in pairs{"X", "Y"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_"..label.."Plus"], mp2=true, plus=true}
			self:skinButton{obj=_G["CFM_"..label.."Minus"], mp2=true}
		end
		self:addSkinFrame{obj=CFM_Panel2}
		-- Add Frame panel (3)
		self:skinEditBox{obj=CFM_NameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinEditBox{obj=CFM_FrameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:addSkinFrame{obj=CFM_Panel3}
		-- Options panel (4)
		self:skinEditBox{obj=CFM_ChangeNameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:skinDropDown{obj=CFM_CopyBox}
		self:skinDropDown{obj=CFM_LoadBox}
		self:addSkinFrame{obj=CFM_Panel4}
		self:Unhook("CFM_GUI")
	end)

end
