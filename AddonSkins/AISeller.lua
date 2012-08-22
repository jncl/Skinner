if not Skinner:isAddonEnabled("AISeller") then return end

function Skinner:AISeller()

	local function skinFrame(obj)

		obj.scrollframe_1:SetBackdrop(nil)
		obj.scrollframe_1.SetBackdrop = function() end
		self:skinScrollBar{obj=obj.scf1}
		self:addSkinFrame{obj=obj.scf1, x1=-5, y1=5, x2=5, y2=-5}
		obj.scf1.SetBackdrop = function() end

	end
-->>-- Confirm GUI
	self:SecureHook(ais, "show_confirm", function(this, ...)
		self:moveObject{obj=confirm_titletext, y=-6}
		self:addSkinFrame{obj=confirm_frame, kfs=true}
		skinFrame(confirm_frame)
		self:Unhook(ais, "show_confirm")
	end)
-->>-- List GUI
	self:SecureHook(ais, "show_list", function(this)
		self:moveObject{obj=list_titletext, y=-6}
		self:addSkinFrame{obj=list_frame, kfs=true}
		self:addSkinFrame{obj=group1_border}
		skinFrame(group1)
		self:addSkinFrame{obj=group2_border}
		skinFrame(group2)
		self:Unhook(ais, "show_list")
	end)

end
