local aName, aObj = ...
if not aObj:isAddonEnabled("LilSparkysWorkshop") then return end
local _G = _G

function aObj:LilSparkysWorkshop()

	-- look for menuInputBox
	local mIB = self:findFrame2(_G.UIParent, "Frame", 40, 150)
	self:skinEditBox{obj=mIB.editBox, regs={9}}
	self:addSkinFrame{obj=mIB}
	
	-- hook this to skin the progressBar
	self:SecureHook(_G.LSW, "Initialize", function(this)
		for _, child in pairs{this.parentFrame:GetChildren()} do
			if type(child) == "Frame"
			and self.getInt(child:GetWidth()) == 310
			and self.getInt(child:GetHeight()) == 30
			then
				self:addSkinFrame{obj=child}
				break
			end
		end
		self:Unhook(_G.LSW, "Initialize")
	end)
	
end
