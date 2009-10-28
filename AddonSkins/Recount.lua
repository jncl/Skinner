
function Skinner:Recount()

	local x1, y1, x2, y2 = -4, -10, 4, -4
	-- Hook this to get window objects and skin them
	self:SecureHook(Recount, "AddWindow", function(this, window)
		if window:GetName() == "Recount_ReportWindow" then -- report window
			self:skinEditBox{obj=window.Whisper, regs={9}, noHeight=true}
			window.Whisper:SetHeight(window.Whisper:GetHeight() + 6)
			self:skinButton{obj=window.ReportButton}
			x1, y1, x2, y2 = -2, -8, 2, -2
		elseif window:GetName() == "Recount_ConfigWindow" then -- config window(s)
			self:skinAllButtons(window.Data)
			self:skinAllButtons(window.Window)
			self:skinAllButtons(window.ColorOpt)
			x1, y1, x2, y2 = -4, -8, 3, -2
		elseif window.YesButton then -- reset window
			self:skinAllButtons(window)
		end
		self:addSkinFrame{obj=window, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
	end)

-->>-- Main Window
	self:addSkinFrame{obj=Recount.MainWindow, kfs=true, x1=-2, y1=-8, x2=2}
-->>-- Detail Window
	self:addSkinFrame{obj=Recount_DetailWindow, kfs=true, x1=-2, y1=-8, x2=3, y2=-2}
-->>-- Graph Window
	self:addSkinFrame{obj=Recount_GraphWindow, kfs=true, hdr=true, x1=-2, y1=-8, x2=2, y2=-2}

-->>-- skin Realtime frames already created
	local kids = {UIParent:GetChildren()}
	for _, child in ipairs(kids) do
		if child:GetName() == nil and child:IsObjectType("Frame") and child.Graph then
			self:addSkinFrame{obj=child, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	end
	kids = nil

end
