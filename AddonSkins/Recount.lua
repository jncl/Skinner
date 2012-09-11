local aName, aObj = ...
if not aObj:isAddonEnabled("Recount") then return end

function aObj:Recount()

	local x1, y1, x2, y2 = -4, -10, 4, -4
	-- Hook this to get window objects and skin them
	self:SecureHook(Recount, "AddWindow", function(this, window)
		if window:GetName() == "Recount_ReportWindow" then -- report window
			self:skinEditBox{obj=window.Whisper, regs={9}, noHeight=true}
			window.Whisper:SetHeight(window.Whisper:GetHeight() + 6)
			self:skinSlider{obj=window.slider}
			x1, y1, x2, y2 = -2, -8, 2, -2
		elseif window:GetName() == "Recount_ConfigWindow" then -- config window(s)
			self:skinSlider{obj=Recount_ConfigWindow_Scaling_Slider}
			self:skinSlider{obj=Recount_ConfigWindow_RowHeight_Slider}
			self:skinSlider{obj=Recount_ConfigWindow_RowSpacing_Slider}
			x1, y1, x2, y2 = -4, -8, 5, -2
		end
		self:addSkinFrame{obj=window, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
	end)

-->>-- Main Window, don't skin all buttons
	self:addSkinFrame{obj=Recount.MainWindow, kfs=true, nb=true, x1=-2, y1=-8, x2=2}
	self:skinButton{obj=self:getChild(Recount.MainWindow, 1), cb=true}
-->>-- Detail Window
	self:addSkinFrame{obj=Recount.DetailWindow, kfs=true, nb=true, x1=-2, y1=-8, x2=3, y2=-2}
-->>-- Graph Window
	self:addSkinFrame{obj=Recount.GraphWindow, kfs=true, hdr=true, x1=-2, y1=-8, x2=2, y2=-2}

-->>-- skin Realtime frames already created
	for _, child in pairs{UIParent:GetChildren()} do
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and child.Graph
		then
			self:addSkinFrame{obj=child, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	end

end
