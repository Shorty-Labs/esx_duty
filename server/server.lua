--[[ Variables ]]--
    ESX = exports["es_extended"]:getSharedObject()
    local resourceName = GetCurrentResourceName()
    local jobCounts = {} -- Table to store player counts for each job
    local timeTrackingData = {} -- Table to store time tracking data for each player
    local trackingFile = "/server/time_tracking_data.json" -- Rename this whatever you like, adding `/server/` before sets the folder to server
    local playerLoginState = {}
--[[ End ]]--

--[[ Functions ]]--
    --[[ Utility Functions ]]--
        --- Prints a trace message with a specified style.
        -- @param msg string The message to print.
        -- @param style number Optional. Style identifier (0 = INFO, 1 = ERROR, 2 = ADDSOMETHING ELSE ETC.).
        local Trace = function(msg, style)
            local styles = {'[^4INFO^0]: ', '[^1ERROR^0]: '}
            local selectedStyle = styles[style and (style + 1) or 1] or styles[1]
            print(selectedStyle .. (msg or NewTranslateCap("no_trace_message")))
        end

        -- Retrieves a translated string from the Locales table based on the current Config.Locale setting.
        -- If the translation for the given key does not exist or is not a table, returns the key itself.
        -- @param key (string) - The key to look up in the Locales table for translation.
        -- @return (table) - The table if found; otherwise, returns the original key.
        local NewTranslateCap = function(key)
            if Locales[Config.Locale] then
                local translation = Locales[Config.Locale][key]
                return type(translation) == "table" and translation or key
            end
            return key
        end

        --- Retrieves the Discord identifier associated with a player.
        -- @param xPlayer The player object or source identifier.
        -- @return The Discord identifier as a string if found, or 'None' if not found.
        local getdiscordID = function(xPlayer)
            local identifiers = GetNumPlayerIdentifiers(xPlayer.source)
            for i = 0, identifiers - 1 do
                local identifier = GetPlayerIdentifier(xPlayer.source, i)
                if identifier:match("^discord:") then
                    return identifier:sub(9)
                end
            end
            return 'None'
        end

        --- Waits until the player job name is available.
        -- @param xPlayer userdata The player object.
        -- @return string The player's job name.
        local getPlayerJob = function(xPlayer)
            while not xPlayer.getJob().name do Wait(1) end
            return xPlayer.getJob().name
        end

        --- Calculates the number of key-value pairs in a table.
        -- @param table The table whose length is to be calculated.
        -- @return The number of key-value pairs in the table. Returns 0 if the table is nil.
        local function tableLength(tbl)
            if not tbl then return 0 end
            local count = 0
            for _ in pairs(tbl) do
                count = count + 1
            end
            return count
        end

        --- Calculates the date with an offset from a given start date.
        -- @param startDate string The start date in YYYY-MM-DD format.
        -- @param offsetDays number The number of days to offset from the start date.
        -- @return string The calculated date in YYYY-MM-DD format.
        local calculateDate = function(startDate, offsetDays)
            local year, month, day = tonumber(startDate:sub(1, 4)), tonumber(startDate:sub(6, 7)), tonumber(startDate:sub(9, 10))
            local targetTime = os.time({ year = year, month = month, day = day }) + offsetDays * 86400
            return os.date('%Y-%m-%d', targetTime)
        end

        --- Formats a duration in seconds into a HH:MM:SS string.
        -- @param seconds The duration in seconds to format.
        -- @return A formatted string representing the duration in HH:MM:SS format.
        local formatTime = function(seconds)
            local hours = math.floor(seconds / 3600)
            local minutes = math.floor((seconds % 3600) / 60)
            local remainingSeconds = seconds % 60
            return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
        end

        -- Function to convert date from dd/mm/yy to yyyy-mm-dd format
        -- @param dateString The input date string in dd/mm/yy format
        -- @return string|nil The converted date string in yyyy-mm-dd format, or nil if input format is invalid
        local function convertDateFormat(dateString)
            local day, month, year = dateString:match("(%d+)/(%d+)/(%d+)")
            if day and month and year then
                local fullYear = tonumber(year) + 2000
                return string.format("%04d-%02d-%02d", fullYear, tonumber(month), tonumber(day))
            end
            return nil
        end

    --[[ Time Tracking Functions ]]--    
        --- Loads time tracking data from file.
        local loadTimeTrackingData = function()
            local data = LoadResourceFile(resourceName, trackingFile)
            if data then
                timeTrackingData = json.decode(data) or {}
            else
                timeTrackingData = {}
            end
        end

        --- Saves time tracking data to file.
        local saveTimeTrackingData = function()
            local success = SaveResourceFile(resourceName, trackingFile, json.encode(timeTrackingData, { indent = true }), -1)
            if not success then
                -- Handle error, maybe log it or inform administrators
                Trace(TranslateCap("failed_to_save"), 1)
            end
        end

        --- Initializes time tracking data for a new player.
        -- @param xPlayer userdata The player object.
        local initializePlayerTimeData = function(xPlayer)
            local job = getPlayerJob(xPlayer)
            local characterName = xPlayer.getName()
            local discordId = getdiscordID(xPlayer)

            if not timeTrackingData[job] then
                timeTrackingData[job] = {}
            end

            if not timeTrackingData[job][xPlayer.identifier] then
                timeTrackingData[job][xPlayer.identifier] = {
                    characterName = characterName,
                    discordId = discordId,
                    sessionStartTime = os.time(),
                    sessionTime = 0,
                    dailyTimes = {},
                    weeklyTimes = {},
                    lastLogin = os.time(),
                }
            end
            saveTimeTrackingData()
        end

        --- Retrieves the time tracking data for a player.
        -- @param xPlayer userdata The player object.
        -- @return table The time tracking data table for the player.
        local getPlayerTimeData = function(xPlayer)
            local job = getPlayerJob(xPlayer):gsub('off_', '')

            local characterName = xPlayer.getName()
            local discordId = getdiscordID(xPlayer)

            if not timeTrackingData[job] then
                initializePlayerTimeData(xPlayer)
            end

            if not timeTrackingData[job][xPlayer.identifier] then
                initializePlayerTimeData(xPlayer)
            end

            return timeTrackingData[job][xPlayer.identifier]
        end

        --- Updates player's session time.
        -- @param xPlayer userdata The player object.
        -- @param time number The time to add to the session time.
        local updateSessionTime = function(xPlayer, time)
            local playerData = getPlayerTimeData(xPlayer)
            playerData.sessionTime = playerData.sessionTime + time
            saveTimeTrackingData()
        end

        --- Updates player's daily time.
        -- @param xPlayer userdata The player object.
        -- @param time number The time to add to the daily time.
        local updateDailyTime = function(xPlayer, time)
            local playerData = getPlayerTimeData(xPlayer)
            local date = os.date("%Y-%m-%d")
            if not playerData.dailyTimes[date] then
                playerData.dailyTimes[date] = 0
            end
            playerData.dailyTimes[date] = playerData.dailyTimes[date] + time
            saveTimeTrackingData()
        end

        -- Function to reset daily times for a specific job and character.
        -- @param targetIdentifier (string or number) The identifier of the target character. If nil, resets daily times for all characters in the job.
        -- @param jobName (string) The name of the job for which daily times are reset.
        -- @return dataFound (boolean) True if data was found and reset, false otherwise.
        local function resetDailyTimesForJob(targetIdentifier, jobName)
            local dataFound = false

            if targetIdentifier then
                if timeTrackingData[jobName] and timeTrackingData[jobName][targetIdentifier] then
                    timeTrackingData[jobName][targetIdentifier].dailyTimes = {}
                    saveTimeTrackingData()
                    dataFound = true
                end
            else
                if timeTrackingData[jobName] then
                    for _, playerData in pairs(timeTrackingData[jobName]) do
                        playerData.dailyTimes = {}
                        dataFound = true
                    end
                    saveTimeTrackingData()
                end
            end

            return dataFound
        end

        -- Function to reset weekly times for a specific job and character.
        -- @param targetIdentifier (string or number) The identifier of the target character. If nil, resets weekly times for all characters in the job.
        -- @param jobName (string) The name of the job for which weekly times are reset.
        -- @return dataFound (boolean) True if data was found and reset, false otherwise.
        local function resetWeeklyTimesForJob(targetIdentifier, jobName)
            local dataFound = false

            if targetIdentifier then
                if timeTrackingData[jobName] and timeTrackingData[jobName][targetIdentifier] then
                    timeTrackingData[jobName][targetIdentifier].weeklyTimes = {}
                    saveTimeTrackingData()
                    dataFound = true
                end
            else
                if timeTrackingData[jobName] then
                    for _, playerData in pairs(timeTrackingData[jobName]) do
                        playerData.weeklyTimes = {}
                        dataFound = true
                    end
                    saveTimeTrackingData()
                end
            end

            return dataFound
        end

        --- Calculates daily time for a specific date grouped by job.
        -- @param date string Date in YYYY-MM-DD format.
        -- @return table Table containing job categories with player identifiers and their daily times for the specified date.
        local calculateDailyTimesForDate = function(date)
            local dailyTimes = {}
        
            for job, players in pairs(timeTrackingData) do
                dailyTimes[job] = {}
                for playerId, playerData in pairs(players) do
                    if Config.Jobs[job] then
                        local dailyTime = playerData.dailyTimes[date] or 0
                        if dailyTime > 0 then
                            dailyTimes[job][playerId] = playerData
                        end
                    end
                end
            end
        
            return dailyTimes
        end

        --- Calculates weekly time for a specific week start date grouped by job.
        -- @param weekStartDate string Date in YYYY-MM-DD format representing the week start.
        -- @return table Table containing job categories with player identifiers and their weekly times for the specified week start date.
        local calculateWeeklyTimesForWeek = function(weekStartDate)
            local weeklyTimes = {}
            local weekStartTimestamp = os.time({year = tonumber(weekStartDate:sub(1, 4)), month = tonumber(weekStartDate:sub(6, 7)), day = tonumber(weekStartDate:sub(9, 10)), hour = 0})
            local weekEndTimestamp = weekStartTimestamp + (6 * 86400) -- 6 days * 24 hours * 60 minutes * 60 seconds

            for job, players in pairs(timeTrackingData) do
                weeklyTimes[job] = {}
                for playerId, playerData in pairs(players) do
                    local weeklyTime = 0
                    for date, dailyTime in pairs(playerData.dailyTimes) do
                        local dateTimestamp = os.time({year = tonumber(date:sub(1, 4)), month = tonumber(date:sub(6, 7)), day = tonumber(date:sub(9, 10)), hour = 0})
                        if dateTimestamp >= weekStartTimestamp and dateTimestamp <= weekEndTimestamp then
                            weeklyTime = weeklyTime + dailyTime
                        end
                    end
                    if weeklyTime > 0 then
                        weeklyTimes[job][playerId] = playerData
                        playerData.weeklyTimes[weekStartDate] = weeklyTime
                    end
                end
            end

            return weeklyTimes
        end

        --- Calculates the start of the week (Sunday) for a given date.
        -- @param timestamp number The timestamp to calculate the week start for.
        -- @return string The week commencing date in YYYY-MM-DD format.
        local getWeekStartDate = function(timestamp)
            local dateTable = os.date("*t", timestamp)
            local dayOfWeek = dateTable.wday -- 1 is Sunday, 2 is Monday, ..., 7 is Saturday
            local daysToSunday = dayOfWeek - 1
            local weekStartTimestamp = os.time({year = dateTable.year, month = dateTable.month, day = dateTable.day, hour = 0}) - (daysToSunday * 86400)
            return os.date("%Y-%m-%d", weekStartTimestamp)
        end

        --- Updates player's weekly time.
        -- @param xPlayer userdata The player object.
        -- @param time number The time to add to the weekly time.
        local updateWeeklyTime = function(xPlayer, time)
            local playerData = getPlayerTimeData(xPlayer)
            local weekStartDate = getWeekStartDate(os.time())
            if not playerData.weeklyTimes[weekStartDate] then
                playerData.weeklyTimes[weekStartDate] = 0
            end
            playerData.weeklyTimes[weekStartDate] = playerData.weeklyTimes[weekStartDate] + time
            saveTimeTrackingData()
        end

        --- Function to remove stale player data based on last login time and activity records.
        local function removeStalePlayerData()
            local currentTime = os.time()
            local twoWeeksAgo = currentTime - (14 * 24 * 60 * 60) -- 14 days ago in seconds

            for job, players in pairs(timeTrackingData) do
                for charId, playerData in pairs(players) do
                    local lastLogin = playerData.lastLogin or 0
                    local hasDailyTimes = next(playerData.dailyTimes) ~= nil
                    local hasWeeklyTimes = next(playerData.weeklyTimes) ~= nil

                    if lastLogin < twoWeeksAgo or (not hasDailyTimes and not hasWeeklyTimes) then
                        timeTrackingData[job][charId] = nil
                    end
                end
            end

            saveTimeTrackingData()
        end

    --[[ Job and Player Management Functions ]]--
        --- Installs jobs from Config.Jobs into ESX.
        local installJobs = function()
            local function handleJob(jobName, jobData)
                Trace(TranslateCap("add_job", jobName), 0)
                for _, data in pairs(jobData.grades) do
                    Trace(TranslateCap("add_grade", data.grade, data.label), 0)
                    data.id, data.salary, data.name = nil, 0, 'off_' .. data.name
                    data.skin_male, data.skin_female = '{}', '{}'
                end
                ESX.CreateJob('off_' .. jobName, 'off_' .. jobName, jobData.grades)
            end
        
            ESX.RefreshJobs()
            for k, v in pairs(Config.Jobs) do
                local jobName = string.lower(k)
                jobCounts[jobName] = 0
                if ESX.Jobs[jobName] and not ESX.DoesJobExist('off_' .. jobName, 0) then
                    handleJob(jobName, ESX.Jobs[jobName])
                else
                    Trace(TranslateCap("ignore_job", jobName), 0)
                end
            end
            ESX.RefreshJobs()
        end

        --- Checks if the player has a required job to display the duty location/s.
        -- @param xPlayer userdata The player object.
        -- @return boolean True if the player has a required job, false otherwise.
        local checkPlayerJob = function(xPlayer)
            return Config.Jobs[getPlayerJob(xPlayer):gsub('off_', '')] ~= nil
        end

        --- Checks if the player is currently on duty.
        -- @param xPlayer userdata The player object.
        -- @return boolean True if the player is on duty, false otherwise.
        local isPlayerOnDuty = function(xPlayer)
            return not getPlayerJob(xPlayer):find("off_")
        end

        --- Checks if the player can clock in based on their job and current status.
        -- @param xPlayer userdata The player object.
        -- @return boolean True if the player can clock in, false otherwise.
        local canPlayerClockIn = function(xPlayer)
            return not isPlayerOnDuty(xPlayer) and ESX.DoesJobExist(getPlayerJob(xPlayer):gsub('off_', ''), xPlayer.getJob().grade)
        end

        --- Checks if the player can clock out based on their job and current status.
        -- @param xPlayer userdata The player object.
        -- @return boolean True if the player can clock out, false otherwise.
        local canPlayerClockOut = function(xPlayer)
            return isPlayerOnDuty(xPlayer) and ESX.DoesJobExist('off_' .. getPlayerJob(xPlayer), xPlayer.getJob().grade)
        end

        --- Updates the job count for a specified job.
        -- @param jobName string The job name.
        -- @param increment boolean Whether to increment (true) or decrement (false) the count.
        local updateJobCount = function(jobName, increment)
            if Config.Jobs[jobName] then
                if jobCounts[jobName] then
                    jobCounts[jobName] = jobCounts[jobName] + (increment and 1 or -1)
                else
                    jobCounts[jobName] = increment and 1 or -1
                end
            end
        end

        --- Returns the number of players online for a specified job.
        -- @param jobName string The job name.
        -- @return number The number of players online for the job.
        local getJobCount = function(jobName)
            return jobCounts[jobName] or 0
        end

        --- Sends a embed to discord.
        -- @param data table The data structure containing author, title, description, fields, color, and thumbnail URL.
        local sendToDiscord = function(data)
            if not data.webhook or data.webhook == "" or data.webhook == "ADD YOUR DISCORD WEBHOOK HERE" then
                Trace(TranslateCap("webhook_not_set", data.author), 1)
                return
            end
            local embed = {
                color = data.color,
                author = { name = data.author, icon_url = data.thumbnail },
                title = data.title,
                description = data.description,
                thumbnail = { url = data.thumbnail },
                fields = data.fields,
                footer = {
                    text = "© - SLabs | Duty :: " .. os.date('%c'),
                    icon_url = "https://cdn.discordapp.com/attachments/985870615535812609/1236281501784477806/New_Project_3.png?ex=6637705f&is=66361edf&hm=0d84595c6aa2067dfbda0e0fdaedb0e60a2d1149dfae5d94dea85414beca4727&"
                }
            }
        
            PerformHttpRequest(data.webhook, function(err)
                if err ~= 204 then
                    Trace(TranslateCap("failed_to_send", tostring(err)), 1)
                end
            end, 'POST', json.encode({ username = TranslateCap("discord_bot_name"), embeds = { embed } }), { ['Content-Type'] = 'application/json' })
        end

        --- Clocks the player in or out based on their eligibility.
        -- @param xPlayer userdata The player object.
        local handleClockOn = function(xPlayer)
            local jobName = getPlayerJob(xPlayer)

            if isPlayerOnDuty(xPlayer) and canPlayerClockOut(xPlayer) then
                jobName = 'off_' .. jobName
            elseif canPlayerClockIn(xPlayer) then
                jobName = jobName:gsub('off_', '')
            else
                Config.sendNotification(TranslateCap("error_has_occurred"), 'error', xPlayer.source)
                return
            end
            xPlayer.setJob(jobName, xPlayer.getJob().grade)
        end

    --[[ Embed and Discord Functions ]]--
        --- Creates an embed message for Discord logging.
        -- @param jobName string The name of the job.
        -- @param weekStartDate string The start date of the week in YYYY-MM-DD format.
        -- @param playerName string The name of the player (optional).
        -- @param playerData table The data of the player (optional).
        -- @return table The embed message table.
        local createEmbed = function (jobName, weekStartDate, playerName, playerData)
            local description = TranslateCap("no_data")
            if playerName then
                description = TranslateCap("hook_desc", playerName, playerData.discordId, TranslateCap("line_break"))
            end
            local Color = string.gsub(DiscordConfig.randomColors[math.random(#DiscordConfig.randomColors)], "^#", "0x")

            return {
                webhook = DiscordConfig.WeekLogHooks[jobName],
                author = TranslateCap("hook_auth", string.upper(jobName)),
                title = TranslateCap("hook_title", weekStartDate),
                description = description,
                color = tonumber(Color),
                thumbnail = Config.Jobs[jobName].Image, 
                fields = {}
            }
        end

        --- Calculates the total weekly time for a specific week.
        -- @param dailyTimes table The table containing daily times.
        -- @param weekStartDate string The start date of the week in YYYY-MM-DD format.
        -- @return number The total time for the week.
        local calculateWeeklyTimeForSpecificWeek = function(dailyTimes, weekStartDate)
            local total = 0
            for i = 0, 6 do
                local currentDate = calculateDate(weekStartDate, i)
                total = total + (dailyTimes[currentDate] or 0)
            end
            return total
        end

        --- Adds the total weekly time field to the embed.
        -- @param embed table The embed message table.
        -- @param totalWeeklyTime number The total weekly time in seconds.
        local addTotalTimeField = function(embed, totalWeeklyTime)
            table.insert(embed.fields, {name = TranslateCap("week_total"), value = formatTime(totalWeeklyTime), inline = true})
            for _ = 1, 2 do
                table.insert(embed.fields, {name = '', value = '', inline = true})
            end
            table.insert(embed.fields, {name = '', value = TranslateCap("line_break"), inline = false})
        end
    --[[ Export Functions ]]--
        --- Function to export a table of data containing all players within specified job and week commencing date
        -- @param jobName The name of the job to retrieve data for.
        -- @param weekStartDate The starting date of the week in "YYYY-MM-DD" format.
        -- @return A table of data containing daily and weekly times for each player, or nil and an error message if data is not available.
        local exportJobTimes = function(jobName, weekStartDate)
            local data = {}

            weekStartDate = convertDateFormat(weekStartDate)
            local weeklyTimes = calculateWeeklyTimesForWeek(weekStartDate)

            if not weeklyTimes[jobName] then
                return nil, "No data available for the specified job and week"
            end

            local weekDays = {}
            local currentTimestamp = os.time()    
            for i = 0, 6 do
                local currentDate = calculateDate(weekStartDate, i)
                local dayTimestamp = os.time({ year = tonumber(currentDate:sub(1, 4)), 
                                            month = tonumber(currentDate:sub(6, 7)), 
                                            day = tonumber(currentDate:sub(9, 10)) })
                if dayTimestamp <= currentTimestamp then 
                    local dayIndex = tonumber(os.date('%w', dayTimestamp)) + 1
                    local dayName = NewTranslateCap("dayLocalization")[dayIndex] or TranslateCap("unknown")
                    weekDays[#weekDays + 1] = { name = dayName, date = currentDate }
                end
            end

            for playerId, playerData in pairs(weeklyTimes[jobName]) do
                local playerName = playerData.characterName
                local playerTimes = {}

                for _, day in ipairs(weekDays) do
                    local currentDate = day.date
                    local date = os.date('%d', os.time({ year = tonumber(currentDate:sub(1, 4)), 
                                                        month = tonumber(currentDate:sub(6, 7)), 
                                                        day = tonumber(currentDate:sub(9, 10)) }))
                    local timeInSeconds = playerData.dailyTimes[currentDate] or 0
                    local formattedTime = formatTime(timeInSeconds)
                    
                    playerTimes[string.format('%s %s', day.name, date)] = timeInSeconds > 0 and formattedTime or TranslateCap("not_on_duty")
                end

                local totalWeeklyTime = calculateWeeklyTimeForSpecificWeek(playerData.dailyTimes, weekStartDate)
                local formattedWeeklyTime = formatTime(totalWeeklyTime)  -- Format total weekly time

                -- Add job name and formatted weekly time to player data
                data[playerName] = {
                    jobName = jobName,
                    weeklyTimes = playerTimes,
                    totalWeeklyTime = formattedWeeklyTime
                }
            end

            return data
        end

        --- Retrieves player counts for specific job(s) or all configured jobs.
        -- If jobName is provided, returns a table with the count for that specific job.
        -- If no jobName is provided, returns a table with counts for all configured jobs.
        -- @param jobName (optional) string The name of the job to retrieve the count for.
        -- @return table A table where keys are job names and values are player counts.
        local exportJobsCount = function(jobName)
            local countTable = {}

            -- If a specific jobName is provided, fetch count for that job
            if jobName then
                if Config.Jobs[jobName] then
                    countTable[jobName] = getJobCount(jobName) or 0
                end
            else
                -- If no specific jobName provided, fetch counts for all configured jobs
                for job, _ in pairs(Config.Jobs) do
                    countTable[job] = getJobCount(job) or 0
                end
            end

            return countTable
        end

        local exportDutyStatus = function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            return isPlayerOnDuty(xPlayer)
        end

--[[ End ]]--

--[[ Events ]]--
    --- Handles the duty toggle event for a player.
    RegisterServerEvent("sl_duty:ToggleDuty")
    AddEventHandler("sl_duty:ToggleDuty", function()
        local xPlayer = ESX.GetPlayerFromId(source)
        if not checkPlayerJob(xPlayer) then
            Config.sendNotification(TranslateCap("error_has_occurred"), 'error', xPlayer.source)
            return
        end

        local isOnDuty = isPlayerOnDuty(xPlayer)
        if isOnDuty then
            -- Clock out logic
            handleClockOn(xPlayer)
        else
            -- Clock in logic
            handleClockOn(xPlayer)
        end
    end)

    --- Handles adding chat suggestions for commands.
    RegisterServerEvent("sl_duty:addChatSuggestion_s")
    AddEventHandler("sl_duty:addChatSuggestion_s", function()
        local xPlayer = ESX.GetPlayerFromId(source)    
        local data = {
            {
                commandName = "/logJobTimes",
                commandDescription = TranslateCap("log_job_times_desc"),
                params = {
                    {name = TranslateCap("job_name_param"), help = TranslateCap("job_name_help")},
                    {name = TranslateCap("week_commencing_param"), help = TranslateCap("week_commencing_help")}
                }
            },
            {
                commandName = "/jobcount",
                commandDescription = TranslateCap("job_count_desc"),
                params = {
                    {name = TranslateCap("job_name_param"), help = TranslateCap("job_name_help")}
                }
            },
            {
                commandName = "/resetdailytimes",
                commandDescription = TranslateCap("reset_daily_times_desc"),
                params = {
                    { name = TranslateCap("job_name_param"), help = TranslateCap("job_name_help") },
                    { name = TranslateCap("target_name_param"), help = TranslateCap("target_name_help"), params = { TranslateCap("optional_param") } }
                }
            },
            {
                commandName = "/resetweeklytimes",
                commandDescription = TranslateCap("reset_weekly_times_desc"),
                params = {
                    { name = TranslateCap("job_name_param"), help = TranslateCap("job_name_help") },
                    { name = TranslateCap("target_name_param"), help = TranslateCap("target_name_help"), params = { TranslateCap("optional_param") } }
                }
            },
            {
                commandName = "/checkdailytimes",
                commandDescription = TranslateCap("check_daily_times_desc"),
                params = {
                    { name = TranslateCap("job_name_param"), help = TranslateCap("job_name_help") },
                    { name = TranslateCap("date_param"), help = TranslateCap("date_help")}
                }
            },
            {
                commandName = "/checkdutystatus",
                commandDescription = TranslateCap("check_duty_status_desc"),
                params = {
                    { name = TranslateCap("player_id_param"), help = TranslateCap("player_id_help"), params = { TranslateCap("optional_param") }}
                }
            },
            {
                commandName = "/"..Config.DutyCommandSettings.DutyCommandName,
                commandDescription = TranslateCap("duty_command_desc"),
                params = {}
            }

        }
    
        for _, suggestion in ipairs(data) do
            TriggerClientEvent("sl_duty:addChatSuggestion_c", xPlayer.source, suggestion)
        end
    end)
    
    RegisterServerEvent('sl_duty:playerLoggedIn')
    AddEventHandler('sl_duty:playerLoggedIn', function()
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer then
            -- Lets set the player logged in flag.
            playerLoginState[xPlayer.source] = true

            if isPlayerOnDuty(xPlayer) then
                -- Clock out the player without updating time tracking data
                xPlayer.setJob('off_' .. getPlayerJob(xPlayer), xPlayer.getJob().grade)
            end
        end
    end)

    --- Installs jobs on server start.
    AddEventHandler("onResourceStart", function(resource)
        if resource == resourceName then
            Wait(1)
            installJobs()
            loadTimeTrackingData()
            removeStalePlayerData()
        end
    end)

    --- Handles the event when a player's job is set or updated.
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(source, job, lastJob)
        local xPlayer = ESX.GetPlayerFromId(source)
    
        -- Ensure player, job, and lastJob exist
        if xPlayer and job and job.name and lastJob then
            local newJobName = job.name
            local oldJobName = lastJob.name

            if playerLoginState[xPlayer.source] then
                playerLoginState[xPlayer.source] = nil
                return
            end

            -- Check if the new job exists in the configuration and is not an 'off_' job
            if newJobName and newJobName ~= oldJobName and Config.Jobs[newJobName:gsub('off_', '')] then
                -- Handling job change to a new active job
                if oldJobName and not oldJobName:find("off_") then
                    -- Update job count for the old job (decrement)
                    updateJobCount(oldJobName, false)
                end
    
                -- Update job count for the new job (increment)
                if not newJobName:find("off_") then
                    updateJobCount(newJobName, true)
    
                    -- Update player's time tracking data
                    local playerData = getPlayerTimeData(xPlayer)
                    playerData.lastLogin = os.time()
                    playerData.sessionStartTime = os.time()
                    playerData.sessionTime = 0
                    saveTimeTrackingData()
    
                    -- Notify player about clocking in
                    Config.sendNotification(TranslateCap("went_on_duty"), 'success', xPlayer.source)
    
                    -- Log to Discord if enabled
                    if DiscordConfig.UseLogs then
                        local data = {
                            webhook = DiscordConfig.ClockInHook,
                            color = 65280,
                            author = TranslateCap("clocked_notif", TranslateCap("in")),
                            title = TranslateCap("clocked_in_out", TranslateCap("in")),
                            description = string.format('**%s** - <@%s>\n', xPlayer.getName(), getdiscordID(xPlayer)),
                            thumbnail = Config.Jobs[newJobName].Image,
                            fields = {
                                {name = TranslateCap("job"), value = newJobName:gsub('off_', ''), inline = true},
                                {name = TranslateCap("grade"), value = job.grade_name:gsub('off_', ''), inline = true},
                                {name = TranslateCap("reason"), value = TranslateCap("clocked_in_out", TranslateCap("in")), inline = true},
                                {name = TranslateCap("online"), value = getJobCount(newJobName), inline = true},
                                {name = '', value = '', inline = true}
                            }
                        }
                        sendToDiscord(data)
                    end
                end
            end
    
            -- Handling job change from old job to 'off_' version
            if oldJobName and oldJobName ~= newJobName and Config.Jobs[oldJobName:gsub('off_', '')] then
                if not oldJobName:find("off_") then
                    -- Update player's session time for the old job
                    local playerData = getPlayerTimeData(xPlayer)
                    local loginTime = playerData.sessionStartTime
                    local sessionTime = os.time() - loginTime
                    local jobName = oldJobName:gsub('off_', '')
    
                    updateSessionTime(xPlayer, sessionTime)
                    updateDailyTime(xPlayer, sessionTime)
                    updateWeeklyTime(xPlayer, sessionTime)
    
                    -- Set the job to the 'off_' version
                    xPlayer.setJob('off_' .. jobName, lastJob.grade)
    
                    -- Notify player about clocking out
                    Config.sendNotification(TranslateCap("went_off_duty"), 'success', xPlayer.source)
    
                    -- Log to Discord if enabled
                    if DiscordConfig.UseLogs then
                        local data = {
                            webhook = DiscordConfig.ClockOutHook,
                            color = 16711680,
                            author = TranslateCap("clocked_notif", TranslateCap("out")),
                            title = TranslateCap("clocked_in_out", TranslateCap("out")),
                            description = string.format('**%s** - <@%s>\n', xPlayer.getName(), getdiscordID(xPlayer)),
                            thumbnail = Config.Jobs[jobName].Image,
                            fields = {
                                {name = TranslateCap("job"), value = jobName, inline = true},
                                {name = TranslateCap("grade"), value = lastJob.grade_name:gsub('off_', ''), inline = true},
                                {name = TranslateCap("time"), value = formatTime(sessionTime), inline = true},
                                {name = TranslateCap("reason"), value = TranslateCap("clocked_in_out", TranslateCap("out")), inline = true},
                                {name = TranslateCap("online"), value = getJobCount(oldJobName), inline = true},
                                {name = '', value = '', inline = true}
                            }
                        }
                        sendToDiscord(data)
                    end
                end
            end
        end
    end)      

    --- Handles player disconnection.
    AddEventHandler('playerDropped', function(reason)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer and isPlayerOnDuty(xPlayer) then
            local isOnDuty = isPlayerOnDuty(xPlayer)
            if isOnDuty then
                if isOnDuty then
                    handleClockOn(xPlayer)
                end
            end

            local loginTime = getPlayerTimeData(xPlayer).lastLogin
            local sessionTime = os.time() - loginTime
            updateSessionTime(xPlayer, sessionTime)
            updateDailyTime(xPlayer, sessionTime)
            updateWeeklyTime(xPlayer, sessionTime)
        end
    end)
--[[ End ]]--

--[[ Commands ]]--
    --- Command to retrieve and display the count of online players for a specific job.
    -- This command checks the number of players online in a specified job and sends a notification to the player.
    RegisterCommand('jobcount', function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobName = args[1] and string.lower(args[1]) or nil

        if jobName and Config.Jobs[jobName] then
            local count = getJobCount(jobName)
            local message = TranslateCap("job_count", jobName, count)
            Config.sendNotification(message, 'info', xPlayer.source)
        else
            local errorMessage = TranslateCap("invalid_job_name")
            Config.sendNotification('~r~' .. errorMessage, 'error', xPlayer.source)
        end
    end, false)

    --- Command to log session times for all players of a specific job for a given week commencing date
    -- Registers the command to log job times for a specific job and week.
    RegisterCommand('logJobTimes', function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobName = string.lower(args[1])
        local weekStartDate = args[2]
    
        while not xPlayer.getJob().name do 
            Wait(1) 
        end
    
        local job = xPlayer.getJob()    
        if (job.name == jobName and job.grade_name == 'boss') or xPlayer.getGroup() == 'admin' then
            if not jobName or not weekStartDate then
                local errorMessage = TranslateCap("logjobtimes_usage")
                Config.sendNotification(errorMessage, 'error', xPlayer.source)
                return
            end
            weekStartDate = convertDateFormat(args[2])
            local weeklyTimes = calculateWeeklyTimesForWeek(weekStartDate)    
            if not weeklyTimes[jobName] then
                local errorMessage = TranslateCap("no_job_data", jobName)
                Config.sendNotification(errorMessage, 'error', xPlayer.source)
                return
            end
    
            if tableLength(weeklyTimes[jobName]) == 0 then
                local embed = createEmbed(jobName, weekStartDate)
                sendToDiscord(embed)
                return
            end
            
            local weekDays = {}
            local currentTimestamp = os.time()    
            for i = 0, 6 do
                local currentDate = calculateDate(weekStartDate, i)
                local dayTimestamp = os.time({ year = tonumber(currentDate:sub(1, 4)), 
                                               month = tonumber(currentDate:sub(6, 7)), 
                                               day = tonumber(currentDate:sub(9, 10)) })
                if dayTimestamp <= currentTimestamp then 
                    local dayIndex = tonumber(os.date('%w', dayTimestamp)) + 1
                    local dayName = NewTranslateCap("dayLocalization")[dayIndex] or TranslateCap("unknown")
                    weekDays[#weekDays + 1] = { name = dayName, date = currentDate }
                end
            end
    
            for playerId, playerData in pairs(weeklyTimes[jobName]) do
                local playerName = playerData.characterName
                local embed = createEmbed(jobName, weekStartDate, playerName, playerData)
    
                for _, day in ipairs(weekDays) do
                    local currentDate = day.date
                    local date = os.date('%d', os.time({ year = tonumber(currentDate:sub(1, 4)), 
                                                        month = tonumber(currentDate:sub(6, 7)), 
                                                        day = tonumber(currentDate:sub(9, 10)) }))
                    local timeInSeconds = playerData.dailyTimes[currentDate] or 0
                    local formattedTime = formatTime(timeInSeconds)
    
                    table.insert(embed.fields, {
                        name = string.format('%s %s', day.name, date),
                        value = timeInSeconds > 0 and formattedTime or TranslateCap("not_on_duty"),
                        inline = true
                    })
                end
    
                local totalWeeklyTime = calculateWeeklyTimeForSpecificWeek(playerData.dailyTimes, weekStartDate)
                addTotalTimeField(embed, totalWeeklyTime)
    
                sendToDiscord(embed)
            end
        else
            local errorMessage = '~r~' .. TranslateCap("no_permission")
            Config.sendNotification(errorMessage, 'error', xPlayer.source)
        end
    end, false)


    -- Register the command to reset daily times
    RegisterCommand('resetdailytimes', function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobName = args[1] -- Job name
        local targetIdentifier -- Target character name or server ID
        local targetName = args[2] ..' '.. args[3]

        if xPlayer.getGroup() == 'admin' or (xPlayer.getJob().name == jobName and xPlayer.getJob().grade_name == 'boss') then
            if jobName and Config.Jobs[jobName] then
                if args[2] then
                    local targetPlayer = ESX.GetPlayerFromIdentifier(args[2])
                    if targetPlayer then
                        playerName = targetPlayer.getName()
                        targetIdentifier = targetPlayer.identifier
                    else
                        local players = ESX.GetPlayers()
                        for i = 1, #players do
                            local player = ESX.GetPlayerFromId(players[i])
                            playerName = player.getName()
                            if string.lower(playerName) == string.lower(targetName) then
                                targetIdentifier = player.identifier
                                break
                            end
                        end
                    end

                    if targetIdentifier then
                        local resetResult = resetDailyTimesForJob(targetIdentifier, jobName)
                        if resetResult then
                            Config.sendNotification(TranslateCap("daily_times_reset_job_char", jobName, playerName), 'success', xPlayer.source)
                        else
                            Config.sendNotification(TranslateCap("no_data_found"), 'error', xPlayer.source)
                            return
                        end
                    else
                        Config.sendNotification(TranslateCap("invalid_target"), 'error', xPlayer.source)
                        return
                    end
                else
                    local resetResult = resetDailyTimesForJob(nil, jobName)
                    if resetResult then
                        Config.sendNotification(TranslateCap("daily_times_reset_job", jobName), 'success', xPlayer.source)
                    else
                        Config.sendNotification(TranslateCap("no_data_found"), 'error', xPlayer.source)
                        return
                    end
                end

                -- Log to Discord
                if DiscordConfig.UseLogs then
                    local targetName = targetName or TranslateCap("all_players")
                    local data = {
                        webhook = DiscordConfig.ResetTimesHook,
                        color = 16711680,
                        author = TranslateCap("reset_times_notif"),
                        title = TranslateCap("reset_times_title", TranslateCap("daily")),
                        description = string.format('%s - <@%s>\n', xPlayer.getName(), getdiscordID(xPlayer)),
                        thumbnail = Config.Jobs[jobName].Image,
                        fields = {
                            {name = TranslateCap("job"), value = jobName, inline = true},
                            {name = TranslateCap("target"), value = targetName, inline = true},
                            {name = TranslateCap("reset_type"), value = TranslateCap("daily"), inline = true},
                            {name = ' ', value = ' ', inline = true}
                        }
                    }
                    sendToDiscord(data)
                end
            else
                Config.sendNotification(TranslateCap("invalid_job_name"), 'error', xPlayer.source)
            end
        else
            Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
        end
    end, true)

    -- Register the command to reset weekly times
    RegisterCommand('resetweeklytimes', function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobName = args[1] -- Job name
        local targetIdentifier -- Target character name or server ID
        local targetName = args[2] .. ' ' .. args[3]

        if xPlayer.getGroup() == 'admin' or (xPlayer.getJob().name == jobName and xPlayer.getJob().grade_name == 'boss') then
            if jobName and Config.Jobs[jobName] then
                if args[2] then
                    local targetPlayer = ESX.GetPlayerFromIdentifier(args[2])
                    if targetPlayer then
                        playerName = targetPlayer.getName()
                        targetIdentifier = targetPlayer.identifier
                    else
                        local players = ESX.GetPlayers()
                        for i = 1, #players do
                            local player = ESX.GetPlayerFromId(players[i])
                            playerName = player.getName()
                            if string.lower(playerName) == string.lower(targetName) then
                                targetIdentifier = player.identifier
                                break
                            end
                        end
                    end

                    if targetIdentifier then
                        local resetResult = resetWeeklyTimesForJob(targetIdentifier, jobName)
                        if resetResult then
                            Config.sendNotification(TranslateCap("weekly_times_reset_job_char", jobName, playerName), 'success', xPlayer.source)
                        else
                            Config.sendNotification(TranslateCap("no_data_found"), 'error', xPlayer.source)
                            return
                        end
                    else
                        Config.sendNotification(TranslateCap("invalid_target"), 'error', xPlayer.source)
                        return
                    end
                else
                    local resetResult = resetWeeklyTimesForJob(nil, jobName)
                    if resetResult then
                        Config.sendNotification(TranslateCap("weekly_times_reset_job", jobName), 'success', xPlayer.source)
                    else
                        Config.sendNotification(TranslateCap("no_data_found"), 'error', xPlayer.source)
                        return
                    end
                end

                -- Log to Discord
                if DiscordConfig.UseLogs then
                    local targetName = targetName or TranslateCap("all_players")
                    local data = {
                        webhook = DiscordConfig.ResetTimesHook,
                        color = 16711680,
                        author = TranslateCap("reset_times_notif"),
                        title = TranslateCap("reset_times_title", TranslateCap("weekly")),
                        description = string.format('%s - <@%s>\n', xPlayer.getName(), getdiscordID(xPlayer)),
                        thumbnail = Config.Jobs[jobName].Image,
                        fields = {
                            {name = TranslateCap("job"), value = jobName, inline = true},
                            {name = TranslateCap("target"), value = targetName, inline = true},
                            {name = TranslateCap("reset_type"), value = TranslateCap("weekly"), inline = true},
                            {name = ' ', value = ' ', inline = true}
                        }
                    }
                    sendToDiscord(data)
                end
            else
                Config.sendNotification(TranslateCap("invalid_job_name"), 'error', xPlayer.source)
            end
        else
            Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
        end
    end, true)

    -- Command to check the duty status of a player
    RegisterCommand('checkdutystatus', function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)

        if args[1] and xPlayer.getGroup() ~= 'admin' then
            Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
            return
        end

        local targetPlayerId = tonumber(args[1]) or source
        local targetXPlayer = ESX.GetPlayerFromId(targetPlayerId)
        if targetXPlayer then
            if checkPlayerJob(targetXPlayer) then
                local isDutyStatus = isPlayerOnDuty(targetXPlayer)
                local statusMessage = isDutyStatus and TranslateCap("on_duty") or TranslateCap("off_duty")
                local targetName = targetXPlayer == xPlayer and TranslateCap("self") or targetXPlayer.getName()
                Config.sendNotification(TranslateCap("duty_status", targetName, statusMessage), 'info', xPlayer.source)
            else
                Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
            end
        else
            Config.sendNotification(TranslateCap("player_not_found"), 'error', xPlayer.source)
        end
    end, true)

    -- Command to check daily times for a specific job and date
    RegisterCommand('checkdailytimes', function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobName = args[1]
        local dateString = args[2]

        if dateString then
            local date = convertDateFormat(dateString)
            if date then
                local dailyTimes = calculateDailyTimesForDate(date)
                if next(dailyTimes) then
                    if xPlayer.getGroup() == 'admin' or (xPlayer.getJob().name == jobName and xPlayer.getJob().grade_name == 'boss') then
                        -- Admin or boss can check daily times for any job
                        for job, players in pairs(dailyTimes) do
                            for playerId, playerData in pairs(players) do
                                local playerName = playerData.characterName
                                local dailyTime = playerData.dailyTimes[date] or 0
                                local formattedTime = formatTime(dailyTime)
                                Config.sendNotification(TranslateCap("daily_time", playerName, job, formattedTime), 'info', xPlayer.source)
                            end
                        end
                    else
                        -- Regular player can only check their own daily times
                        local playerJob = getPlayerJob(xPlayer)
                        if Config.Jobs[playerJob] then
                            local playerData = getPlayerTimeData(xPlayer)
                            local dailyTime = playerData.dailyTimes[date] or 0
                            local formattedTime = formatTime(dailyTime)
                            Config.sendNotification(TranslateCap("your_daily_time", playerJob, formattedTime), 'info', xPlayer.source)
                        else
                            Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
                        end
                    end
                else
                    Config.sendNotification(TranslateCap("no_data_found"), 'error', xPlayer.source)
                end
            else
                Config.sendNotification(TranslateCap("invalid_date_format"), 'error', xPlayer.source)
            end
        else
            Config.sendNotification(TranslateCap("missing_date"), 'error', xPlayer.source)
        end
    end, true)
    

    if Config.DutyCommandSettings.UseDutyCommand then
        RegisterCommand(Config.DutyCommandSettings.DutyCommandName, function(source, args, rawCommand)
            local xPlayer = ESX.GetPlayerFromId(source)


            if Config.DutyCommandSettings.AdminOnly and xPlayer.getGroup() ~= 'admin' then
                Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
                return
            end

            if not checkPlayerJob(xPlayer) then
                Config.sendNotification(TranslateCap("no_permission"), 'error', xPlayer.source)
                return
            end
    
            local isOnDuty = isPlayerOnDuty(xPlayer)
            if isOnDuty then
                -- Clock out logic
                handleClockOn(xPlayer)
            else
                -- Clock in logic
                handleClockOn(xPlayer)
            end

        end, false)
    end

--[[ End ]]--   

--[[ Exports ]]--
    exports('exportJobTimes', exportJobTimes)
    exports('exportJobsCount', exportJobsCount)
    exports('resetDailyTimesForJob', resetDailyTimesForJob)
    exports('resetWeeklyTimesForJob', resetWeeklyTimesForJob)
    exports('exportDutyStatus', exportDutyStatus)
--[[ End ]]--