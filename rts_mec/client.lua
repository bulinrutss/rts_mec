local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
RutssDev = Tunnel.getInterface("rts_mec")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "utilidades-comprar-nitro" then
		TriggerServerEvent("departamento-comprar","nitro")
	elseif data == "utilidades-comprar-repairkit" then
		TriggerServerEvent("departamento-comprar","repairkit")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 4847.02, -4633.54, 15.09 }
}
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local nyoSleep = 500
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 2.0 then
				nyoSleep = 5
				DrawText3D(x,y,z-0.1,"~b~[Conveniência]\n~w~Pressione ~g~[E]~w~ para acessar a lojinha",0.5,3)
				if IsControlJustPressed(0,38) then
				    if RutssDev.checkPorte() then
					ToggleActionMenu()
					end
				end
			end
		end
		Citizen.Wait(nyoSleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
function DrawText3D(x,y,z, text, scl, font) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	 
    if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
    end
end