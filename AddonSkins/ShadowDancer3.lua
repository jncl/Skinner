
function Skinner:ShadowDancer3()

	local obj = IGAS.GUI.CreateFrame("Frame", "ShadowDancer3")
	self:SecureHook(obj, "OpenGUI", function()
		local gui = obj.Parent:GetChild("ShadowDancer3_GUI")
-- 		self:Debug("sd3 OpenGUI:[%s, %s]", obj, gui)
		self:applySkin(gui.__UI)
		-- get children to skin
		local tabG = gui:GetChild("Tab")
		local tabCon = tabG.__HeaderContainer
		local summaryT = tabCon:GetChild("TabButton"..1)
		local weaponT = tabCon:GetChild("TabButton"..2)
		local skillT = tabCon:GetChild("TabButton"..3)
		local summaryF = summaryT.__Container.__UI
		local summaryCon = summaryT.Container
		local weaponF = weaponT.__Container.__UI
		local weaponCon = weaponT.Container
		local skillF = skillT.__Container.__UI
		local skillCon = skillT.Container
		local dd
		-- Summary Tab
		dd = summaryCon:GetChild("LockMode")
		self:applySkin(dd.__UI)
		self:applySkin(dd.__List.__UI)
		self:applySkin(summaryF)
		-- Weapon Tab
		local weaponObjs = {"WeaponName", "WpsMain", "WpsOff", "WpsRange", "WpsAmmo"}
		for _, v in pairs(weaponObjs) do
			dd = weaponCon:GetChild(v)
			self:applySkin(dd.__UI)
			self:applySkin(dd.__List.__UI)
		end
		self:applySkin(weaponF)
		-- Skill Tab
		local skillObjs = {"Time", "SkillName", "WpsMain", "WpsOff", "WpsRange", "WpsAmmo"}
		for _, v in pairs(skillObjs) do
			dd = skillCon:GetChild(v)
			self:applySkin(dd.__UI)
			self:applySkin(dd.__List.__UI)
		end
		self:applySkin(skillF)
		self:Unhook(obj, "OpenGUI")
		self.ShadowDancer3 = nil
	end)

end
