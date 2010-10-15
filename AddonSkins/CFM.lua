if not Skinner:isAddonEnabled("CFM") then return end

function Skinner:CFM()

-->>-- Config frame(s)
	self:SecureHook("CFM_GUI", function(this)
		self:addSkinFrame{obj=CFM_Config}
		-- Mouseover panel
		self:addSkinFrame{obj=CFM_MouseInfoFrame, y2=-2}
		-- Scroll panel
		self:addSkinFrame{obj=CFM_ScrollFrame}
		-- dont skin scrollbar as it moves to the right when frames are added
		-- Properties panel (1)
		self:addSkinFrame{obj=CFM_Panel1}
		for _, label in pairs{"Width", "Height", "Scale", "Level", "Alpha"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_"..label.."_Plus"], mp2=true, plus=true, noWidth=true}
			self:skinButton{obj=_G["CFM_"..label.."_Minus"], mp2=true}
		end
		-- Anchor panel (2)
		self:skinEditBox{obj=CFM_ChangeParentBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:addSkinFrame{obj=CFM_Panel2}
		self:skinDropDown{obj=CFM_FromBox}
		self:skinDropDown{obj=CFM_ToBox}
		self:skinDropDown{obj=CFM_StrataBox}
		for _, label in pairs{"X", "Y"} do
			self:skinEditBox{obj=_G["CFM_"..label.."Box"], regs={9}, noHeight=true, noWidth=true, noInsert=true}
			self:skinButton{obj=_G["CFM_"..label.."Plus"], mp2=true, plus=true}
			self:skinButton{obj=_G["CFM_"..label.."Minus"], mp2=true}
		end
		-- Add Frame panel (3)
		self:addSkinFrame{obj=CFM_Panel3}
		self:skinEditBox{obj=CFM_FrameBox, regs={9}, noHeight=true, noWidth=true, noInsert=true}
		self:Unhook("CFM_GUI")
	end)

end
