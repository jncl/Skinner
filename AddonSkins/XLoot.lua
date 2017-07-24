local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end
local _G = _G

function aObj:XLoot() -- 7.2-8

	-- skin anchors
	self.RegisterCallback("Xloot", "UIParent_GetChildren", function(this, child)
		if child.hide
		and child.label
		then
			self:addSkinFrame{obj=child, nb=true}
		end
	end)

	local function skinFrame(frame)

		frame.overlay:DisableDrawLayer("ARTWORK") -- border textures
		aObj:addSkinFrame{obj=frame.overlay}
		self:skinButton{obj=frame.old_close, cb=true}

		frame.overlay.SetBackdrop = _G.nop
		frame.overlay.SetBackdropColor = _G.nop
		frame.overlay.gradient:SetTexture(nil)
		frame.overlay.SetGradientColor = _G.nop

		-- handle frame border colour change
		if frame.opt.quality_color_frame then
			frame.overlay.SetBorderColor = function(this, r, g, b, a)
				frame.overlay.sf:SetBackdropBorderColor(r, g, b, 1)
			end
		else
			frame.overlay.SetBorderColor = _G.nop
		end

	end

	-- skin XLoot frames
	local addon = _G.XLoot:GetModule("Frame", true)
	if addon then
		self:SecureHook(addon, "BuildLootFrame", function(this, frame)
			skinFrame(frame)
		end)
	end

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "XLootTooltip")
	end

end

