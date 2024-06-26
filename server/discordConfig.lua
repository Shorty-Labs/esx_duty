DiscordConfig = {
    UseLogs = true, -- Whether to use Discord logs

    -- Webhooks for clock-in and clock-out events
    ClockInHook = "ADD YOUR DISCORD WEBHOOK HERE",
    ClockOutHook = "ADD YOUR DISCORD WEBHOOK HERE",
    ResetTimesHook = "ADD YOUR DISCORD WEBHOOK HERE",
    
    -- Webhooks for weekly logs by job type
    WeekLogHooks = {
        police = "https://discord.com/api/webhooks/1252620221143978044/vfOTMWtWroFxJmsov_SmnibGb_SF6ToUr7mxl_uBkpD5k4e6vUnQh5d63F_Z4BYLcCoK",
        ambulance = "ADD YOUR DISCORD WEBHOOK HERE",
        mechanic = "ADD YOUR DISCORD WEBHOOK HERE",
    
    },

    -- Random colors for discord Embeds, add or remove as you wish.
    randomColors = {
        '#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231',
        '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe',
        '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000',
        '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080',
        '#ffffff', '#000000'
    }
}