local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local headerShown = false
local sendData = nil

-- Functions
local function openMenu(data)
    if not data or not next(data) then return end
	for _, v in pairs(data) do
		if v["icon"] then
			local img = "nui://qb-inventory/html/"
			if QBCore.Shared.Items[tostring(v["icon"])] then
				if not string.find(QBCore.Shared.Items[tostring(v["icon"])].image, "http") then
					if not string.find(QBCore.Shared.Items[tostring(v["icon"])].image, "images/") then
						img = img.."images/"
					end
					v["icon"] = img..QBCore.Shared.Items[tostring(v["icon"])].image
				end
			end
		end
	end
    SetNuiFocus(true, true)
    headerShown = false
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = data
    })
end

local function closeMenu()
    headerShown = false
    SetNuiFocus(false)
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

local function showHeader(data)
    headerShown = true
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = data
    })
end

RegisterNetEvent('qb-menu:client:openMenu', function(data)
    openMenu(data)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    closeMenu()
end)

RegisterNUICallback('clickedButton', function(data)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel','DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    SetNuiFocus(false)
    if data.event then
        if data.isServer then
            TriggerServerEvent(data.event, data.args)
        elseif data.isCommand then
            ExecuteCommand(data.event)
        elseif data.isQBCommand then
            TriggerServerEvent('QBCore:CallCommand', data.event, data.args)
        elseif isAction then
            data.event(data.args)
        else
            TriggerEvent(data.event, data.args)
        end
    end
end)

RegisterNUICallback('closeMenu', function()
    headerShown = false
    SetNuiFocus(false)
    TriggerEvent("wert-notes:client:qb-menu-close")
end)

RegisterCommand('+playerfocus', function()
    if headerShown then
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping('+playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)
exports('clearHistory', clearHistory)
