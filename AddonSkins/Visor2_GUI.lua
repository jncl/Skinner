if not Skinner:isAddonEnabled("Visor2_GUI") then return end

function Skinner:Visor2_GUI()

	self:skinEditBox{obj=Visor2GUIEditBox, regs={9}, move=true}
	self:skinEditBox{obj=Visor2GUIEditW, regs={9}}
	self:skinEditBox{obj=Visor2GUIEditH, regs={9}}
	self:skinEditBox{obj=Visor2GUIEditX, regs={9}}
	self:skinEditBox{obj=Visor2GUIEditY, regs={9}}
	self:addSkinFrame{obj=Visor2GUIFrame, kfs=true, y1=6}
	self:addSkinFrame{obj=Visor2GUIConfirmFrame}

end
