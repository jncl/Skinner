local ipairs = ipairs

function Skinner:Recount()

	-- Hook this to get window objects and skin them
	self:SecureHook(Recount, "AddWindow", function(this, window)
		local tText = window.Title:GetText()
		local x1, x2, y2 = -4, 4, -4
		if tText:find("Report Data - ") then
			self:skinEditBox{obj=window.Whisper, regs={9}, noHeight=true}
			window.Whisper:SetHeight(window.Whisper:GetHeight() + 6)
			x1, x2, y2 = 0, 0, 0
		elseif tText == "Config Recount" then
			x1, x2, y2 = -2, 3, -2
		end
		self:addSkinFrame{obj=window, kfs=true, x1=x1, y1=-10, x2=x2, y2=y2}
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
			self:addSkinFrame{obj=child, kfs=true, x1=-4, y1=-10, x2=4, y2=-4}
		end
	end
	kids = nil

end
