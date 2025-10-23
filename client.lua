ESX = nil
local isDead = false
local fadeStarted = false

-- ESX initialisieren
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Überwache den Spielerstatus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()

        -- Spieler ist tot und Fade noch nicht gestartet
        if IsEntityDead(playerPed) and not isDead then
            isDead = true
            fadeStarted = false

            -- Starte Fade-Out 1 Sekunde nach Tod
            Citizen.CreateThread(function()
                Citizen.Wait(1000) -- 1 Sekunde warten
                if IsEntityDead(playerPed) and not fadeStarted then
                    fadeStarted = true
                    DoScreenFadeOut(2000) -- langsam 2 Sekunden
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                end
            end)
        end
    end
end)

-- Fade-In beim Respawn
AddEventHandler('playerSpawned', function(spawn)
    if isDead or fadeStarted then
        isDead = false
        fadeStarted = false
        Citizen.CreateThread(function()
            Citizen.Wait(100)
            DoScreenFadeIn(2000) -- langsam 2 Sekunden
        end)
    end
end)
