Locales["de"] = {
    -- Allgemein
    ["error_has_occurred"] = "Es ist ein Fehler aufgetreten.",
    ["no_trace_message"] = "Keine Trace-Nachricht angegeben.",
    ["no_permission"] = "Sie haben keine Berechtigung, diesen Befehl zu verwenden.",
    ["self"] = "Selbst",

    -- Datum und Uhrzeit
    ["invalid_date_format"] = "Ungültiges Datumsformat. Bitte verwenden Sie das Format JJJJ-MM-TT (z.B. /checkDailyTime 2023-05-15).",
    ["date_param"] = "Datum",
    ["date_help"] = "Geben Sie das Datum im Format JJJJ-MM-TT ein.",
    ["missing_date"] = "Bitte geben Sie ein Datum im Format JJJJ-MM-TT an!",
    ["week_commencing_param"] = "Woche beginnend am",
    ["week_commencing_help"] = "Geben Sie das Startdatum der Woche im Format JJJJ-MM-TT ein.",

    -- Jobs
    ["invalid_job_name"] = "Ungültiger Job-Name!",
    ["job_name_param"] = "Job-Name",
    ["job_name_help"] = "Geben Sie den Job-Namen ein.",
    ["ignore_job"] = "Job 'off_%s' wird ignoriert, da er bereits existiert.",
    ["add_job"] = "Job 'off_%s' wird hinzugefügt",
    ["add_grade"] = "Job-Stufe '%s - %s' wird hinzugefügt",

    -- Dienststatusstatus
    ["go_off_duty"] = "Gehen Sie außer Dienst!",
    ["go_on_duty"] = "Gehen Sie in Dienst!",
    ["not_on_duty"] = "*Nicht im Dienst*",
    ["went_off_duty"] = "Sie sind außer Dienst gegangen!",
    ["went_on_duty"] = "Sie sind in Dienst gegangen!",
    ["on_duty"] = "Im Dienst",
    ["off_duty"] = "Außer Dienst",
    ["duty_status"] = "Dienststatusstatus von %s: %s",

    -- Spieleridentifikation
    ["invalid_player_id"] = "Ungültige Spieler-ID!",
    ["missing_player_id"] = "Bitte geben Sie eine Spieler-ID an!",
    ["player_id_param"] = "Spieler-ID",
    ["player_id_help"] = "Geben Sie die Server-ID des Spielers ein.",
    ["optional_param"] = "(Optional)",

    -- Zeiterfassung
    ["job"] = "Job",
    ["grade"] = "Stufe",
    ["time"] = "Sitzungszeit",
    ["reason"] = "Grund",
    ["out"] = "Aus",
    ["week_total"] = "Wochengesamt",
    ["online"] = "Online",
    ["in"] = "Ein",
    ["daily_time"] = "%s (%s): %s",
    ["your_daily_time"] = "Ihre tägliche Zeit für %s: %s",
    ["no_data_found"] = "Keine Daten gefunden.",
    ["missing_parameters"] = "Erforderliche Parameter fehlen!",

    -- Discord-Webhooks
    ["webhook_not_set"] = 'Webhook "%s" ist nicht gesetzt oder leer.',
    ["failed_to_send"] = "Fehler beim Senden der Nachricht an Discord. Fehlercode: %d",
    ["failed_to_save"] = "Fehler beim Speichern der Zeiterfassungsdaten!",
    ["hook_auth"] = "%s - Wöchentliche Jobzeiten",
    ["hook_title"] = "Woche beginnend am %s",
    ["hook_desc"] = "**%s** - <@%s>\n%s",
    ["line_break"] = "══════════════════",
    ["no_data"] = "**Keine Daten gefunden**",
    ["no_job_data"] = "Keine Daten für den Job gefunden: %s",
    ["discord_bot_name"] = "SL_Duty Logs",
    ["discord_title"] = "%s hat den Dienst %s!",
    ["clocked_in_out"] = "%s erfasst",
    ["clocked_notif"] = "%s Erfassungsbenachrichtigung",

    -- Befehlsbeschreibungen
    ["logjobtimes_usage"] = "Verwendung: /logJobTimes [jobName] [wochenStartDatum (TT/MM/JJ)]",
    ["job_count_desc"] = "Zeigt an, wie viele Spieler für einen bestimmten Job online sind.",
    ["log_job_times_desc"] = "Sendet einen Log an Discord mit den täglichen und wöchentlichen Dienstzeiten aller Spieler.",
    ["check_duty_status_desc"] = "Überprüfen Sie den Dienststatusstatus eines Spielers.",
    ["check_daily_times_desc"] = "Überprüfen Sie die täglichen Zeiten für ein bestimmtes Datum.",
    ["check_weekly_times_desc"] = "Überprüfen Sie die wöchentlichen Zeiten für einen bestimmten Job und ein Wochenstartdatum.",

    -- Tageslokalisierung
    ["dayLocalization"] = {
        "Sonntag",
        "Montag",
        "Dienstag",
        "Mittwoch",
        "Donnerstag",
        "Freitag",
        "Samstag"
    },
}
