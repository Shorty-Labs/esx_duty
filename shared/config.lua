Config = {
    InteractDistance = 2, --The distance at which players can interact with duty locations .
    Radius = 0.5, -- The radius of the duty location zones. 
    Locale = "en", -- The default locale for translations.
    DefaultIcon = 'fa-solid fa-business-time', --https://fontawesome.com/ - The default icon to use for duty menu items.

    -- Duty Command Settings: Settings for the /duty command, including whether to use it, the command name, and whether it should be admin-only.
    DutyCommandSettings = {
        UseDutyCommand = true, -- enable the duty command
        DutyCommandName = 'duty', -- /duty
        AdminOnly = true -- Can be used by admin only or any one with a job in Config.jobs
    },

    -- Jobs: Configuration for each job, including the icon, image, and duty location coordinates.
    Jobs = {
        police = {
            Icon = 'fa-solid fa-handcuffs',
            Image = '', -- url to logo image.
            Locations = {
                -- Mission Row Police Station
                vector3(441.0725402832,-980.10986328125,30.678344726562),
                -- Vinewood Police Station
                vector3(642.6, 1.8, 81.8)
            }
        },

        ambulance = {
            Icon = 'fa-solid fa-truck-medical',
            Image = '',
            Locations = {
                -- Pillbox Hill Medical Center
                vector3(312.0, -603.3, 43.3),
                -- Sandy Shores Medical Center
                vector3(1839.2, 3673.0, 34.2)
            }
        },

        mechanic = {
            Icon = nil,
            Image = '',
            Locations = {
                -- Los Santos Custom (Mission Row)
                vector3(-365.2, -137.9, 38.3),
                -- Los Santos Custom (Burton)
                vector3(-349.7, -136.6, 38.3)
            }
        }
    },

    -- Notification Function: currently uses ESX but can be changed to use whatever notification system you want.
    sendNotification = function(msg, style, source)
        if IsDuplicityVersion() then
            if source then
                TriggerClientEvent('esx:showNotification', source, msg, style)
            end
        else
            ESX.ShowNotification(msg, style)
        end
    end
}
