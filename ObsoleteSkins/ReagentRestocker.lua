local aName, aObj = ...
if not aObj:isAddonEnabled("ReagentRestocker") then return end
local _G = _G

function aObj:ReagentRestocker() -- 10.2

	-- Options Frame (created in UI.lua)
	local ui = self:findFrame2(_G.UIParent, "Frame", 500, 700)
	if ui then
		ui.obj.titletext:SetPoint("TOP", ui.obj.frame, "TOP", 0, -6)
		self:applySkin{obj=ui, kfs=true}
		self:skinButton{obj=self:getChild(ui, 1), y1=1}
		self:applySkin{obj=self:getChild(ui, 2)} -- backdrop frame
		-- Tree Group
		local tg = self:getChild(self:getChild(self:getChild(self:getChild(self:getChild(ui, 7), 1), 1), 2), 1)
		if tg then
			self:keepRegions(tg.obj.scrollbar, {1})
			self:skinUsingBD{obj=tg.obj.scrollbar}
			self:applySkin{obj=tg.obj.border}
			self:applySkin{obj=tg.obj.treeframe}
			if self.modBtns then
				-- hook to manage changes to button textures
				self:SecureHook(tg.obj, "RefreshTree", function(this)
					local btn
					for i = 1, #this.buttons do
						btn = this.buttons[i]
						if not btn.toggle.sknd then
							self:skinButton{obj=btn.toggle, mp2=true, plus=true, as=true}
						end
					end
				end)
			end
		end
	end

	-- Merchant frame
	self:addSkinFrame{obj=_G.RRMerchantClose:GetParent(), ofs=2} -- N.B. RRMerchant name is used by several frames
	_G.RRMerchantTitle:SetBackdrop(nil)
	self:moveObject{obj=_G.RRMerchantTitle, x=0, y=-26}

end
