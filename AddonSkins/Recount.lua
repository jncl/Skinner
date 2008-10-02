
function Skinner:Recount()

	-- Hook this to get window objects and skin them
	self:SecureHook(Recount, "AddWindow", function(this, window)
--		self:Debug("R_AW: [%s, %s, %s, %s]", this, window, window.Title:GetText(), window.tracking)
		if window.Title:GetText() == "Report Data - Main" then
			self:skinEditBox(window.Whisper, {9})
			self:moveObject(window.Whisper, "-", 6, "-", 6, window)
		elseif window.Title:GetText() == "Reset Recount?" then
			window:SetHeight(window:GetHeight() + 4)
		end
		self:moveObject(window.Title, "+", 10, "+", 8, window)
		if window.CloseButton then
			self:moveObject(window.CloseButton, nil, nil, "+", 8, window)
		end
		if window.DragBottomRight then
			self:moveObject(window.DragBottomRight, "+", 5, nil, nil, window)
		end
		if window.DragBottomLeft then
			self:moveObject(window.DragBottomLeft, "-", 5, nil, nil, window)
		end
		-- handle Realtime Frames
		if window.tracking then
			window:SetBackdrop(nil)
			self:moveObject(window.Graph, nil, nil, "+", 6, window)
			self:addSkinFrame(window)
		else
			self:applySkin(window)
		end
	end)
	-- hook these to manage the Scroll Bar display
	self:SecureHook(Recount, "HideScrollbarElements", function(this, name)
--		self:Debug("Recount-HSbE: [%s, %s]", this, name)
		_G[name.."ScrollBar"]:SetBackdrop(nil)
	end)
	self:SecureHook(Recount, "ShowScrollbarElements", function(this, name)
--		self:Debug("Recount-SSbE: [%s, %s]", this, name)
		self:keepFontStrings(_G[name])
		self:skinScrollBar(_G[name])
	end)

-->>-- skin Realtime frames already created
	for i = 1, select("#", UIParent:GetChildren()) do
		local obj = select(i, UIParent:GetChildren())
		if obj:GetName() == nil and obj:IsObjectType("Frame") and obj.Graph then
--			self:Debug("Recount_RTW: [%s, %s, %s]", obj, obj.Title:GetText(), obj.id)
			obj:SetBackdrop(nil)
			self:moveObject(obj.Title, "+", 10, "+", 8, obj)
			self:moveObject(obj.CloseButton, nil, nil, "+", 8, obj)
			self:moveObject(obj.DragBottomRight, "+", 5, nil, nil, obj)
			self:moveObject(obj.DragBottomLeft, "-", 5, nil, nil, obj)
			self:moveObject(obj.Graph, nil, nil, "+", 6, obj)
			self:addSkinFrame(obj)
		end
	end

-->>-- Main Window
	Recount.MainWindow:SetBackdrop(nil)
	self:moveObject(Recount.MainWindow.Title, nil, nil, "+", 6)
	self:moveObject(Recount.MainWindow.RightButton, "+", 6, "+", 6)
	self:moveObject(Recount.MainWindow.CloseButton, "+", 6, "+", 8)
	self:moveObject(Recount.MainWindow.DragBottomRight, "+", 5, nil, nil)
	self:moveObject(Recount.MainWindow.DragBottomLeft, "-", 5, nil, nil)
	if Recount.db.profile.MainWindow.ShowScrollbar then
		self:keepFontStrings(Recount.MainWindow.ScrollBar)
		self:skinScrollBar(Recount.MainWindow.ScrollBar)
	end
-- 	Create a frame to mirror the MainWindow and skin that, make it wider so the bars fit on it
	self:addSkinFrame(Recount.MainWindow)

-->>-- Detail Window
	self:moveObject(Recount_DetailWindow.Title, nil, nil, "+", 8, Recount_DetailWindow)
	self:moveObject(Recount_DetailWindow.CloseButton, nil, nil, "+", 8, Recount_DetailWindow)
	self:moveObject(Recount_DetailWindow.LeftButton, nil, nil, "+", 8, Recount_DetailWindow)
	self:applySkin(Recount_DetailWindow)
-->>-- Graph Window
	self:moveObject(Recount_GraphWindow.Title, nil, nil, "+", 8, Recount_DetailWindow)
	self:keepFontStrings(Recount_GraphWindow_ScrollBar1)
	self:skinScrollBar(Recount_GraphWindow_ScrollBar1)
	self:keepFontStrings(Recount_GraphWindow_ScrollBar2)
	self:skinScrollBar(Recount_GraphWindow_ScrollBar2)
	self:applySkin(Recount_GraphWindow, true)

end
