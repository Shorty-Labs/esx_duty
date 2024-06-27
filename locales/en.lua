Locales["en"] = {
    -- General
    ["error_has_occurred"] = "An error has occurred",
    ["no_trace_message"] = "No trace message set",
    ["no_permission"] = "You do not have permission to use this command.",
    ["self"] = "Yourself",

    -- Date and Time
    ["invalid_date_format"] = "Invalid date format. Please use DD/MM/YY format (e.g., /checkDailyTime 15/01/24).",
    ["date_param"] = "Date",
    ["date_help"] = "Enter the date in DD/MM/YY format.",
    ["missing_date"] = "Please provide a date in DD/MM/YY format!",
    ["week_commencing_param"] = "Week Commencing",
    ["week_commencing_help"] = "Enter the week commencing date in DD/MM/YY format",

    -- Jobs
    ["invalid_job_name"] = "Invalid job name!",
    ["job_name_param"] = "Job Name",
    ["job_name_help"] = "Enter the name of the job.",
    ["ignore_job"] = "Ignoring job ^5'off_%s'^0, job already exists!",
    ["add_job"] = "Adding job ^5'off_%s'^0",
    ["add_grade"] = "Adding job grade ^5'%s - %s'^0",

    -- Duty Status
    ["go_off_duty"] = "Go Off Duty!",
    ["go_on_duty"] = "Go On Duty!",
    ["not_on_duty"] = "*Not On Duty*",
    ["went_off_duty"] = "You went '~b~OFF~s~' Duty!",
    ["went_on_duty"] = "You went '~g~ON~s~' Duty!",
    ["on_duty"] = "On Duty",
    ["off_duty"] = "Off Duty",
    ["duty_status"] = "%s's duty status: %s",

    -- Player Identification
    ["invalid_player_id"] = "Invalid player ID!",
    ["missing_player_id"] = "Please provide a player ID!",
    ["player_id_param"] = "Player ID",
    ["player_id_help"] = "Enter the server ID of the player",
    ["optional_param"] = "(Optional)",

    -- Time Tracking
    ["job"] = "Job",
    ["grade"] = "Grade",
    ["time"] = "Session Time",
    ["reason"] = "Reason",
    ["out"] = "Out",
    ["week_total"] = "Week Total",
    ["online"] = "Online",
    ["in"] = "In",
    ["daily_time"] = "%s (%s): %s",
    ["your_daily_time"] = "Your daily time for %s: %s",
    ["no_data_found"] = "No data found",
    ["missing_parameters"] = "Missing required parameters!",

    -- Discord Webhooks
    ["webhook_not_set"] = "Webhook `%s` is not set or empty.",
    ["failed_to_send"] = "Failed to send message to discord ErrorCode: '^1%d^0'",
    ["failed_to_save"] = "Failed to save time tracking data!",
    ["hook_auth"] = "%s - Weekly Job Times",
    ["hook_title"] = "Week Commencing %s",
    ["hook_desc"] = "**%s** - <@%s> \n%s",
    ["line_break"] = "══════════════════",
    ["no_data"] = "**No Data Found**",
    ["no_job_data"] = "~r~No data found for job: %s",
    ["discord_bot_name"] = "SL_Duty Logs",
    ["discord_title"] = "%s has gone %s Duty!",
    ["clocked_in_out"] = "Clocked %s",
    ["clocked_notif"] = "Clock %s Notification",

    -- Command Descriptions
    ["logjobtimes_usage"] = "~r~Usage:~s~ /logJobTimes ~g~[jobName] [weekStartDate ~s~(DD/MM/YY)]",
    ["job_count"] = "There are %d %s on duty",
    ["job_count_desc"] = "Shows how many players are online for Specific Job",
    ["log_job_times_desc"] = "Sends a log to discord with all players daily and weekly duty times.",
    ["check_duty_status_desc"] = "Check the duty status of a player",
    ["check_daily_times_desc"] = "Check daily times for a specific date",
    ["check_weekly_times_desc"] = "Check weekly times for a specific job and week commencing date",
    ["duty_command_desc"] = "Toggle your duty status (clock in or clock out).",

    -- Day Localization
    ["dayLocalization"] = {
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    },
}
