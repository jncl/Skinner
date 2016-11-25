local aName, aObj = ...
if not aObj:isAddonEnabled("Wholly") then return end
local _G = _G

function aObj:Wholly()

	-- narrow frame
	self:SecureHookScript(_G.com_mithrandir_whollyFrame, "OnShow", function(this)
		self:skinDropDown{obj=_G.com_mithrandir_whollyFrameZoneButton, x2=35}
		self:Unhook(_G.com_mithrandir_whollyFrame, "OnShow")
	end)
	self:skinSlider{obj=_G.com_mithrandir_whollyFrameScrollFrame.scrollBar, adj=-4}
	self:addSkinFrame{obj=_G.com_mithrandir_whollyFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}

	-- wide frame
	self:skinSlider{obj=_G.com_mithrandir_whollyFrameWideScrollOneFrame.scrollBar, adj=-4}
	self:skinSlider{obj=_G.com_mithrandir_whollyFrameWideScrollTwoFrame.scrollBar, adj=-4}
	self:addSkinFrame{obj=_G.com_mithrandir_whollyFrameWide, kfs=true, x1=10, y1=-11, x2=-1, y2=6}
	if self.modBtns then
		-- hook these to manage changes to button textures
		self:SecureHook(_G.Wholly, "ScrollFrameOne_Update", function()
			for i = 1, #_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
				self:checkTex(_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i])
			end
		end)
		self:SecureHook(_G.com_mithrandir_whollyFrameWideScrollOneFrame, "update", function()
			for i = 1, #_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
				self:checkTex(_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i])
			end
		end)
		for i = 1, #_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
			self:skinButton{obj=_G.com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i], mp=true, plus=true}
		end
	end

	-- tooltips
	if self.db.profile.Tooltips.skin then
		-- wait for 5 seconds to allow tooltip to be created (bug reported by several people)
		_G.C_Timer.After(0.5, function() aObj:add2Table(aObj.ttList, _G.Wholly.tooltip) end)
		-- add a metatable to skin new tooltips
		local mt = {__newindex = function(t, k, v)
				_G.rawset(t, k, v)
				aObj:add2Table(aObj.ttList, v)
			end}
		_G.setmetatable(_G.Wholly.tt, mt)
		mt = nil
	end

end