
function Skinner:ShadowDancer3()

	local obj = IGAS.GUI.CreateFrame("Frame", "ShadowDancer3")
--	local sd3GUI = obj:OpenGUI()
	self:SecureHook(obj, "OpenGUI", function(...)
		local gui = obj.Parent:GetChild("ShadowDancer3_GUI")
--		self:Debug("sd3 OpenGUI:[%s, %s]", obj, gui)
		self:applySkin(gui)
		-- get children to skin
--		local tab = self:getChild(gui, 7)
		local tabF = self:getChild(gui, 7).__HeaderContainer
		local summaryT = tabF:GetChild("TabButton"..1)
		local weaponT = tabF:GetChild("TabButton"..2)
		local skillT = tabF:GetChild("TabButton"..3)
		local summaryF = summaryT.__Container
		local weaponF = weaponT.__Container
		local skillF = skillT.__Container
		local dd
		-- Summary Tab
		dd = summaryF.Container:GetChild("LockMode")
		self:applySkin(dd)
		self:applySkin(dd.__List)
		self:applySkin(summaryF)
		-- Weapon Tab
		for _, v in pairs({"WeaponName", "WpsMain", "WpsOff", "WpsRange", "WpsAmmo"}) do
			dd = weaponF.Container:GetChild(v)
			self:applySkin(dd)
			self:applySkin(dd.__List)
		end
		self:applySkin(weaponF)
		-- Skill Tab
		for _, v in pairs({"Time", "SkillName", "WpsMain", "WpsOff", "WpsRange", "WpsAmmo"}) do
			dd = skillF.Container:GetChild(v)
			self:applySkin(dd)
			self:applySkin(dd.__List)
		end
		self:applySkin(skillF)
		self:Unhook(obj, "OpenGUI")
	end)

end
