local aName, aObj = ...
if not aObj:isAddonEnabled("OneBag3") then return end
local _G = _G

function aObj:OneBag3()

	local OB3 = _G.LibStub("AceAddon-3.0"):GetAddon("OneBag3", true)
	if OB3 then
		self:addSkinFrame{obj=OB3.frame}
		self:SecureHookScript(OB3.frame, "OnShow", function(this)
			self:addButtonBorder{obj=this.sidebarButton, ofs=-2}
			self:addButtonBorder{obj=this.configButton, ofs=-2}
			self:addButtonBorder{obj=this.sortButton, ofs=1}
			self:skinEditBox{obj=this.searchbox, regs={9, 10}, mi=true} -- region 10 is search icon
			self:Unhook(OB3.frame, "OnShow")
		end)
		self:addSkinFrame{obj=OB3.sidebar}
	end

end

function aObj:OneBank3()

	local OB3 = _G.LibStub("AceAddon-3.0"):GetAddon("OneBank3", true)
	if OB3 then
		self:skinButton{obj=OB3.reagentBankButton}
		self:addSkinFrame{obj=OB3.frame}
		self:SecureHookScript(OB3.frame, "OnShow", function(this)
			self:addButtonBorder{obj=this.sidebarButton, ofs=-2}
			self:addButtonBorder{obj=this.configButton, ofs=-2}
			self:addButtonBorder{obj=this.sortButton, ofs=1}
			self:skinEditBox{obj=this.searchbox, regs={9, 10}, mi=true} -- region 10 is search icon
			self:Unhook(OB3.frame, "OnShow")
		end)
		self:addSkinFrame{obj=OB3.sidebar}
		self:addSkinFrame{obj=OB3.purchase}
	end

end
