DiscordConfig = {
    UseLogs = true, -- Whether to use Discord logs

    -- Webhooks for clock-in and clock-out events
    ClockInHook = "ADD YOUR DISCORD WEBHOOK HERE",
    ClockOutHook = "ADD YOUR DISCORD WEBHOOK HERE",
    ResetTimesHook = "ADD YOUR DISCORD WEBHOOK HERE",
    
    -- Webhooks for weekly logs by job type
    WeekLogHooks = {
        police = "ADD YOUR DISCORD WEBHOOK HERE",
        ambulance = "ADD YOUR DISCORD WEBHOOK HERE",
        mechanic = "ADD YOUR DISCORD WEBHOOK HERE",
        -- Remember to add Hooks for any jobs you add in Config.Jobs
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
