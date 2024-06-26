# Slabs-Duty
-- My other Scripts [Shorty-Labs-Store]([https://documentation.esx-framework.org/legacy/installation/](https://shorty-labs.tebex.io/]))

Slabs-Duty is an ESX Duty System resource for FiveM servers. It provides a comprehensive solution for managing player duty times, tracking daily and weekly hours, and logging duty-related events to Discord.

## Description

This resource allows players to clock in and out of duty for their respective jobs. It keeps track of their session times, daily times, and weekly times, storing the data in a JSON file. Additionally, it offers various commands for `admin` and `boss` to manage and view duty times, as well as log events to Discord webhooks.

## Installation

1. Download the latest version of the resource from the [Slabs-Duty repository](https://github.com/your-repo/slabs-duty).
2. Extract the contents of the ZIP file into your FiveM server's `resources` directory.
3. Add `start slabs-duty` to your server's `server.cfg` file.
4. Configure the resource settings in the `config.lua` and `discordConfig` files, including job configurations, duty command settings, and Discord webhook URLs, (Examples are provided).

## Dependencies

- [es_extended](https://documentation.esx-framework.org/legacy/installation/)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)

## Exports

The Slabs-Duty resource provides the following exports that can be used in other resources or scripts:

### `exportJobTimes(jobName, weekStartDate)`

This export function retrieves daily and weekly times for all players within a specified job and week commencing date.

**Example Usage:**

```lua
local jobTimesData = Slabs-Duty.exportJobTimes("police", "23/06/24")

if jobTimesData then
    -- Iterate over the data to print or process it
    for playerName, playerData in pairs(jobTimesData) do
        print("Player Name:", playerName)
        print("Job Name:", playerData.jobName)
        print("Total Weekly Time:", playerData.totalWeeklyTime)
        print("Daily Times:")
        for day, time in pairs(playerData.weeklyTimes) do
            print(string.format("%s: %s", day, time))
        end
        print("----------------------")
    end
else
    -- Handle the error message
    print("Error:", error_message)
end
```

### `exportJobsCount(jobName)`

This export function retrieves the count of online players for a specific job or all configured jobs.

**Example Usage:**

```lua
-- Get the count for a specific job
local policeCount = Slabs-Duty.exportJobsCount("police")
print("Player count for police job:", policeCount)

-- Get the count for all jobs
local jobCounts = Slabs-Duty.exportJobsCount()
for job, count in pairs(jobCounts) do
    print("Player count for job '" .. job .. "': " .. count)
end
```

### `exportPlayerTimes(playerName)`

This export function retrieves the duty times for a specific player or all online players.

**Example Usage:**

```lua
-- Get the count for a specific job
local policeCount = Slabs-Duty.exportJobsCount("police")
print("Player count for police job:", policeCount)

-- Get the count for all jobs
local jobCounts = Slabs-Duty.exportJobsCount()
for job, count in pairs(jobCounts) do
    print("Player count for job '" .. job .. "': " .. count)
end
```

### `resetDailyTimesForJob(targetIdentifier, jobName)`

This export function resets the daily times for a specific job for all players or a specific player.

**Example Usage:**

```lua
-- Reset daily times for all players in the police job
Slabs-Duty.resetDailyTimesForJob(nil, "police")

-- Reset daily times for a specific player in the police job
local targetIdentifier = "char1:1fb3c3519c199949245beeedbebabce30ddbb707"
Slabs-Duty.resetDailyTimesForJob(targetIdentifier, "police")
```

### `resetWeeklyTimesForJob(targetIdentifier, jobName)`

This export function resets the weekly times for a specific job for all players or a specific player.

**Example Usage:**

```lua
-- Reset weekly times for all players in the ambulance job
Slabs-Duty.resetWeeklyTimesForJob(nil, "ambulance")

-- Reset weekly times for a specific player in the ambulance job
local targetIdentifier = "char1:1fb3c3519c199949245beeedbebabce30ddbb77"
Slabs-Duty.resetWeeklyTimesForJob(targetIdentifier, "ambulance")
```

### `exportDutyStatus(playerId)`

This export function retrieves the duty status for a specific player.

**Example Usage:**

```lua
local playerId = source -- Assuming 'source' is the player's server ID
local isDutyStatus = Slabs-Duty.exportDutyStatus(playerId)
print("Player is " .. (isDutyStatus and "on duty" or "off duty"))
```

# Commands

The Slabs-Duty resource provides the following commands:

### `/logJobTimes [jobName] [weekStartDate]`
* Description: Sends a log to Discord with all players' daily and weekly duty times for the specified job and week commencing date.
  
* Parameters:
  - jobName: The name of the job to log times for.
  - weekStartDate: The start date of the week in the format DD/MM/YY.
    
* Permissions: Admins and job supervisors (boss) can use this command.

### `/jobcount [jobName]`
* Description: Shows how many players are online for a specific job or all configured jobs.
 
* Parameters:
  - jobName (optional): The name of the job to get the count for. If not provided, it will show the count for all jobs.
 
* Permissions: All players can use this command.

### `/resetdailytimes [jobName] [targetName]`
* Description: Reset daily times for a specific job and optionally for a target player.
  
* Parameters:
  - jobName: The name of the job to reset daily times for.
  - targetName (optional): The name of the target player to reset daily times for. If not provided, it will reset daily times for all players in the job.

* Permissions: Admins and job supervisors (boss) can use this command.

### `/resetweeklytimes [jobName] [targetName]`
* Description: Reset weekly times for a specific job and optionally for a target player.
  
* Parameters:
  - jobName: The name of the job to reset weekly times for.
  - targetName (optional): The name of the target player to reset weekly times for. If not provided, it will reset weekly times for all players in the job.
    
* Permissions: Admins and job supervisors (boss) can use this command.

### `/checkdailytimes [date]`
* Description: Check daily times for a specific date.
  
* Parameters:
  - date: The date in the format DD/MM/YY.
    
* Permissions: Admins and job supervisors (boss) can check daily times for any job, while regular players can only check their own daily times.

### `/checkweeklytimes [jobName] [weekCommencing]`
* Description: Check weekly times for a specific job and week commencing date.
  
* Parameters:
  - jobName: The name of the job to check weekly times for.
  - weekCommencing: The start date of the week in the format DD/MM/YY.
    
* Permissions: Admins and job supervisors (boss) can use this command.

### `/checkdutystatus [playerId]`
* Description: Check the duty status (on-duty or off-duty) of a player.
  
* Parameters:
  - playerId (optional): The server ID of the player to check the duty status for. If not provided, it will check the duty status of the player executing the command.
  
* Permissions: Admins can use this command to check the duty status of any player.

### `/duty`
* Description: Toggle the player's duty status (clock in or clock out).
* Permissions: Players with a valid job can use this command. Admins can use this command for any job.

# Configuration
The Slabs-Duty resource can be configured through the config.lua file. Here are the main configuration options:

* InteractDistance: The distance at which players can interact with duty locations.
* Radius: The radius of the duty location zones.
* Locale: The default locale for translations.
* DefaultIcon: The default icon to use for duty locations.
* DutyCommandSettings: Settings for the /duty command, including whether to use it, the command name, and whether it should be admin-only.
* Jobs: Configuration for each job, including the icon, image, and duty location coordinates.

Additionally, you can configure the Discord webhook URLs in the discordConfig.lua file for logging clock-in/out events, weekly job times, and reset time events.

# Localization
The Slabs-Duty resource supports localization through the locales directory. The default locale is English (en.lua), but you can add translations for other languages by creating new locale files.

# Contributing
Contributions to the Slabs-Duty resource are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on the GitHub repository.


