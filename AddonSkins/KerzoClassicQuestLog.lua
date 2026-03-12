local _, aObj = ...
if not aObj:isAddonEnabled("Kerzo Classic Quest Log") then return end
local _G = _G

aObj.addonsToSkin["Kerzo Classic Quest Log"] = function(self) -- v 1.1.1

	self:SecureHookScript(_G.KerzosQuestLog, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=0})

		self:SecureHookScript(this.Barra, "OnShow", function(fObj)
			self:removeInset(fObj.IndicadorMisiones)
			-- .PanelParty
				-- .Button
			-- .BotonConfig
				-- .PanelAyuda
					-- .Button
			if self.modBtns then
				for _, btn in _G.pairs(fObj.ArrayBotonesAccion) do
					self:skinStdButton{obj=btn, sechk=true}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=fObj.BotonConfig, ofs=0, x1=2, x2=2, clr="grey"}
				self:addButtonBorder{obj=fObj.BotonMapaMundi, ofs=-2, y1=0, y2=0, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Barra)

		-- Quest List
		self:SecureHookScript(this.RegistroMisiones, "OnShow", function(fObj)
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar})
			fObj.ScrollFrame.BotonExpandirTodo:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=fObj.InputBusqueda})
			self:moveObject{obj=fObj.InputBusqueda, x=-30}
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})
			if self.modBtns then
				self:skinExpandButton{obj=fObj.ScrollFrame.BotonExpandirTodo, onSB=true}
				-- TODO: skin button texture [fObj.ScrollFrame.Content.Buttons]
				self:skinCloseButton{obj=fObj.BotonLimpiar, noSkin=true} -- for EditBox content
				self:skinStdButton{obj=fObj.BotonOcultas, sechk=true, x1=-4, x2=4}
			end

			self:add2Table(self.ttList, fObj.TooltipCampanha)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.RegistroMisiones)

		-- Quest Detail
		self:SecureHookScript(this.VisorDetalle, "OnShow", function(fObj)
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar})
			fObj.ScrollFrame.Content.TitleHeader:SetTextColor(self.HT:GetRGB())
			fObj.ScrollFrame.Content.ObjectivesText:SetTextColor(self.BT:GetRGB())
			fObj.ScrollFrame.Content.GroupSize:SetTextColor(self.BT:GetRGB())
			fObj.ScrollFrame.Content.DescriptionHeader:SetTextColor(self.HT:GetRGB())
			fObj.ScrollFrame.Content.DescriptionText:SetTextColor(self.BT:GetRGB())
			-- .AccountCompletedNotice (text colour?)
			fObj.ScrollFrame.Content.StatusTitle:SetTextColor(self.BT:GetRGB())
			fObj.ScrollFrame.Content.StatusText:SetTextColor(self.BT:GetRGB())
				-- .PortraitFrame
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})

			self:SecureHook(fObj, "RenderizarTitulo", function(frame, _)
				frame.ScrollFrame.Content.TitleHeader:SetTextColor(self.HT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTextoObjetivos", function(frame, _)
				frame.ScrollFrame.Content.ObjectivesText:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTamanoGrupo", function(frame, _)
				frame.ScrollFrame.Content.GroupSize:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTextoDescripcion", function(frame, _)
				frame.ScrollFrame.Content.DescriptionText:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTituloEstado", function(frame, _)
				frame.ScrollFrame.Content.StatusTitle:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTextoEstado", function(frame, _)
				frame.ScrollFrame.Content.StatusText:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarTemporizador", function(frame, _)
				frame.ScrollFrame.Content.StatusText:SetTextColor(self.BT:GetRGB())
			end)
			self:SecureHook(fObj, "RenderizarMarcoTipo", function(frame, _)
				for _, btn in _G.pairs(frame.ScrollFrame.Content.TypeFrame.Buttons) do
					btn.Text:SetTextColor(self.BT:GetRGB())
				end
			end)
			self:SecureHook(fObj, "InsertarTextoPremio", function(_, string, _)
				string:SetTextColor(self.BT:GetRGB())

			end)
			self:SecureHook(fObj, "RellenarPremio", function(_, btn, _)
				btn.Back:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Amount}, ofs=4, clr={btn.Rarity:GetVertexColor()}}
				end
			end)

			self:SecureHookScript(fObj.ScrollFrame.Content.ObjectivesFrame, "OnShow", function(oFrame)
				self:SecureHook(fObj, "RenderizarObjetivos", function(_, _)
					for _, oLine in _G.pairs(oFrame.Objectives) do
						oLine:SetTextColor(self.BT:GetRGB())
					end
				end)
				self:Unhook(oFrame, "OnShow")
			end)
			self:checkShown(fObj.ScrollFrame.Content.ObjectivesFrame)

			self:SecureHookScript(fObj.ScrollFrame.Content.SpecialObjectivesFrame, "OnShow", function(soFrame)
				soFrame.SpellObjectiveLearnLabel:SetTextColor(self.BT:GetRGB())
				-- .SpellObjectiveFrame
				self:Unhook(soFrame, "OnShow")
			end)
			self:checkShown(fObj.ScrollFrame.Content.SpecialObjectivesFrame)

			self:SecureHookScript(fObj.ScrollFrame.Content.RequiredMoneyFrame, "OnShow", function(rmFrame)
				rmFrame.RequiredMoneyText:SetTextColor(self.BT:GetRGB())
				-- .RequiredMoneyDisplay
				self:Unhook(rmFrame, "OnShow")
			end)
			self:checkShown(fObj.ScrollFrame.Content.RequiredMoneyFrame)

			self:SecureHookScript(fObj.ScrollFrame.Content.SealFrame, "OnShow", function(sFrame)
				sFrame.Text:SetTextColor(self.BT:GetRGB())

				self:Unhook(sFrame, "OnShow")
			end)
			self:checkShown(fObj.ScrollFrame.Content.SealFrame)

			self:SecureHookScript(fObj.ScrollFrame.Content.RewardsFrame, "OnShow", function(rFrame)
				rFrame.Header:SetTextColor(self.HT:GetRGB())

				self:Unhook(rFrame, "OnShow")
			end)
			self:checkShown(fObj.ScrollFrame.Content.RewardsFrame)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.VisorDetalle)

		-- Campaign Detail
		self:SecureHookScript(this.PanelCampanha, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			fObj:DisableDrawLayer("BORDER")
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})

			self:Unhook(fObj, "OnShow")
		end)

		-- Settings
		self:SecureHookScript(this.PanelAjustes, "OnShow", function(fObj)
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar})
			self:skinObject("slider", {obj=fObj.ScrollFrame.Content.ScaleSlider})
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.ScrollFrame.Content.AboutButton}
			end
			-- TODO: skin check button textures [fObj.ScrollFrame.Content.CheckButtons]

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.VentanaDialogo, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
			if self.modBtns then
				 self:skinStdButton{obj=fObj.BotonAceptar}
				 self:skinStdButton{obj=fObj.BotonCancelar}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.InfoAddon, "OnShow", function(fObj)
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Close}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.KerzosQuestLog)

end
