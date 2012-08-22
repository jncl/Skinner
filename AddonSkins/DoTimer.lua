local aName, aObj = ...
if not aObj:isAddonEnabled("DoTimer") then return end

function aObj:DoTimer_Options()

	local GUILib = AsheylaLib:Import("GUILib")
	-- hook this to skin the sections
	self:SecureHook(GUILib, "GenerateMenu", function(this, frame, module, options, extras)
		for k, v in pairs(frame.sections) do
			if v.borderFrame then self:applySkin{obj=v.borderFrame} end
		end
	end)
	-- hook this to skin the EditBoxes & Buttons
	self:RawHook(GUILib, "GenerateItem", function(this, module, frame, item, extras)
		local hF = self.hooks[this].GenerateItem(this, module, frame, item, extras)
		if item.type:sub(1, 7) == "editBox" then self:skinEditBox{obj=hF.item, regs={9}, noWidth=true}
		elseif item.type == "button" then self:skinButton{obj=hF.item, as=true}
		end
		return hF
	end, true)
	
end
