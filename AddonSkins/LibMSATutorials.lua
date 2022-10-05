local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["MSA-Tutorials-1.0"] = function(self) -- v 4/8+
	if self.initialized["MSA-Tutorials-1.0"] then return end
	self.initialized["MSA-Tutorials-1.0"] = true

	local tut, ver = _G.LibStub:GetLibrary("MSA-Tutorials-1.0", true)
	if tut then
		local function skinFrame(frame)
			if ver >= 8 then
				for _, eb in _G.pairs(frame.editboxes) do
					aObj:skinObject("editbox", {obj=eb})
				end
			else
				aObj:skinObject("editbox", {obj=frame.editbox})
			end
			aObj:skinObject("frame", {obj=frame, kfs=true, ri=true, rns=true, cb=true, x1=-3, x2=3})
			-- show tutorial image(s)
			for _, img in _G.pairs(frame.images) do
				img:SetAlpha(1)
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.button}
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.prev, ofs=-2, x1=1, clr="gold"}
				aObj:addButtonBorder{obj=frame.next, ofs=-2, x1=1, clr="gold"}
				aObj:SecureHook(frame.prev, "Disable", function(this, _)
					aObj:clrBtnBdr(this, "gold")
				end)
				aObj:SecureHook(frame.prev, "Enable", function(this, _)
					aObj:clrBtnBdr(this, "gold")
				end)
				aObj:SecureHook(frame.next, "Disable", function(this, _)
					aObj:clrBtnBdr(this, "gold")
				end)
				aObj:SecureHook(frame.next, "Enable", function(this, _)
					aObj:clrBtnBdr(this, "gold")
				end)
			end
		end
		for _, frame in _G.pairs(tut.frames) do
			skinFrame(frame)
		end
	end

end
