local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["MSA-Tutorials-1.0"] = function(self) -- v 4
	if self.initialized["MSA-Tutorials-1.0"] then return end
	self.initialized["MSA-Tutorials-1.0"] = true

	local tut = _G.LibStub:GetLibrary("MSA-Tutorials-1.0", true)
	if tut then
		local function skinFrame(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			frame.portrait:SetTexture(nil)
			aObj:skinObject("editbox", {obj=frame.editbox})
			aObj:skinObject("frame", {obj=frame, ri=true, rns=true, cb=true, x1=-3, x2=3})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.button}
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.prev, clr="gold",ofs=-2, x1=1}
				aObj:addButtonBorder{obj=frame.next, clr="gold",ofs=-2, x1=1}
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
		-- skin existing frames
		for _, frame in _G.pairs(tut.frames) do
			skinFrame(frame)
		end
		-- add mt to skin new ones ?
	end

end
