--[[ Variables ]]--
    ESX = exports["es_extended"]:getSharedObject() -- Get the ESX Object
    local menuIDs = {} -- Table to hold menu item IDs

--[[ Functions ]]--
    --- Retrieves the current job of the player
    -- @return string The player's job name
    local getPlayerJob = function()
        while ESX.GetPlayerData().job == nil do Wait(100) end
        return ESX.GetPlayerData().job.name
    end

    --- Checks if the player has a required job to display the duty location/s.
    -- @return boolean True if the player has a required job, false otherwise
    local checkPlayerJob = function()
        local jobName = getPlayerJob():gsub('off_', '')
        return Config.Jobs[jobName] ~= nil
    end

    --- Checks if the player is currently on duty.
    -- @return boolean True if the player is on duty, false otherwise
    local isPlayerOnDuty = function()
        return not string.match(getPlayerJob(), "off_")
    end

    --- Checks if the player can perform a duty action based on their current job and status.
    -- @param action string The action type ("in" for clock in, "out" for clock out)
    -- @return boolean True if the player can perform the action, false otherwise
    local canPlayerPerformAction = function(action)
        if action == "in" then
            return not isPlayerOnDuty()
        elseif action == "out" then
            return isPlayerOnDuty()
        end
        return false
    end

    --- Performs a duty action (clock in or out) if the player is eligible.
    -- @param action string The action type ("in" for clock in, "out" for clock out)
    local performAction = function(action)
        if canPlayerPerformAction(action) then
            TriggerServerEvent("sl_duty:ToggleDuty")
        else
            Config.sendNotification(TranslateCap("error_has_occured"), 'error')
        end
    end

    --- Adds duty location based on locations set in Config
    -- @param loc table The location coordinates
    -- @param menuOptions table The menu options for the duty location
    local addDutyLocation = function(loc, menuOptions)
        local id = exports.ox_target:addSphereZone({
            coords = loc,
            radius = Config.Radius,
            debug = false,
            options = {
                menuOptions
            }
        })
        table.insert(menuIDs, id)
    end

    --- Sets first letter of the given string to uppercase.
    -- @param str string The input string
    -- @return string The string with the first letter set to uppercase
    local firstToUpper = function(str)
        return (str:gsub("^%l", string.upper))
    end

    --- Clears old menu items, ensuring no duplicate entries.
    local clearOldItems = function()
        for _, id in ipairs(menuIDs) do
            exports.ox_target:removeZone(id)
        end
        menuIDs = {}
    end

    --- Updates the duty menu based on the player's job and status.
    local updateDutyMenu = function()
        clearOldItems()
        if checkPlayerJob() then 
            local jobName = getPlayerJob():gsub('off_', '')
            local jobConfig = Config.Jobs[jobName]
            local menuOptions = {
                name = jobName,
                icon = jobConfig.Icon or Config.DefaultIcon,
                label = '[' .. firstToUpper(jobName) .. '] - ' .. (isPlayerOnDuty() and TranslateCap("go_off_duty") or TranslateCap("go_on_duty")),
                distance = Config.InteractDistance,
                onSelect = function(data)
                    if isPlayerOnDuty() then
                        performAction("out")
                    else
                        performAction("in")
                    end
                end
            }
            for _, loc in pairs(jobConfig.Locations) do
                addDutyLocation(loc, menuOptions)
            end
        end
    end

--[[ Events ]]--
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
        TriggerServerEvent('sl_duty:playerLoggedIn')
        Wait(1000)
        clearOldItems()
        updateDutyMenu()
        TriggerServerEvent("sl_duty:addChatSuggestion_s")
    end)

    RegisterNetEvent('esx:setJob', function(job, lastJob)
        clearOldItems()
        while ESX.GetPlayerData().job.name == lastJob.name do Wait(1) end
        updateDutyMenu()
    end)

    AddEventHandler('onClientResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            clearOldItems()
            updateDutyMenu()
            TriggerServerEvent("sl_duty:addChatSuggestion_s")
        end
    end)

    RegisterNetEvent('sl_duty:addChatSuggestion_c')
    AddEventHandler('sl_duty:addChatSuggestion_c', function(data)
        TriggerEvent('chat:addSuggestion', data.commandName, data.commandDescription, data.params)
    end)