Locales["fr"] = {
    -- General
    ["error_has_occurred"] = "Une erreur s'est produite.",
    ["no_trace_message"] = "Aucun message de trace fourni.",
    ["no_permission"] = "Vous n'avez pas la permission d'utiliser cette commande.",
    ["self"] = "Vous-même",

    -- Date et heure
    ["invalid_date_format"] = "Format de date invalide. Veuillez utiliser le format AAAA-MM-JJ (ex. : /checkDailyTime 2023-05-15).",
    ["date_param"] = "Date",
    ["date_help"] = "Entrez la date au format AAAA-MM-JJ.",
    ["missing_date"] = "Veuillez fournir une date au format AAAA-MM-JJ !",
    ["week_commencing_param"] = "Semaine commençant le",
    ["week_commencing_help"] = "Entrez la date de début de la semaine au format AAAA-MM-JJ.",

    -- Emplois
    ["invalid_job_name"] = "Nom d'emploi invalide !",
    ["job_name_param"] = "Nom de l'emploi",
    ["job_name_help"] = "Entrez le nom de l'emploi.",
    ["ignore_job"] = "Ignorer l'emploi 'off_%s' car il existe déjà.",
    ["add_job"] = "Ajout de l'emploi 'off_%s'",
    ["add_grade"] = "Ajout du grade d'emploi '%s - %s'",

    -- Statut de service
    ["go_off_duty"] = "Quitter le service",
    ["go_on_duty"] = "Prendre son service",
    ["not_on_duty"] = "*Hors service*",
    ["went_off_duty"] = "Vous avez quitté le service !",
    ["went_on_duty"] = "Vous avez pris votre service !",
    ["on_duty"] = "En service",
    ["off_duty"] = "Hors service",
    ["duty_status"] = "Statut de service de %s : %s",

    -- Identification du joueur
    ["invalid_player_id"] = "ID de joueur invalide !",
    ["missing_player_id"] = "Veuillez fournir un ID de joueur !",
    ["player_id_param"] = "ID du joueur",
    ["player_id_help"] = "Entrez l'ID serveur du joueur.",
    ["optional_param"] = "(Optionnel)",

    -- Suivi du temps
    ["job"] = "Emploi",
    ["grade"] = "Grade",
    ["time"] = "Temps de session",
    ["reason"] = "Raison",
    ["out"] = "Sorti",
    ["week_total"] = "Total de la semaine",
    ["online"] = "En ligne",
    ["in"] = "Entré",
    ["daily_time"] = "%s (%s) : %s",
    ["your_daily_time"] = "Votre temps quotidien pour %s : %s",
    ["no_data_found"] = "Aucune donnée trouvée.",
    ["missing_parameters"] = "Paramètres requis manquants !",

    -- Webhooks Discord
    ["webhook_not_set"] = 'Le webhook "%s" n\'est pas défini ou est vide.',
    ["failed_to_send"] = "Échec de l'envoi du message sur Discord. Code d'erreur : %d",
    ["failed_to_save"] = "Échec de l'enregistrement des données de suivi du temps !",
    ["hook_auth"] = "%s - Temps de travail hebdomadaires",
    ["hook_title"] = "Semaine commençant le %s",
    ["hook_desc"] = "**%s** - <@%s>\n%s",
    ["line_break"] = "══════════════════",
    ["no_data"] = "**Aucune donnée trouvée**",
    ["no_job_data"] = "Aucune donnée trouvée pour l'emploi : %s",
    ["discord_bot_name"] = "SL_Duty Logs",
    ["discord_title"] = "%s a %s son service !",
    ["clocked_in_out"] = "%s enregistré",
    ["clocked_notif"] = "Notification d'enregistrement %s",

    -- Descriptions des commandes
    ["logjobtimes_usage"] = "Utilisation : /logJobTimes [nomEmploi] [dateDebutSemaine (JJ/MM/AA)]",
    ["job_count_desc"] = "Affiche le nombre de joueurs en ligne pour un emploi spécifique.",
    ["log_job_times_desc"] = "Envoie un journal sur Discord avec les temps de service quotidiens et hebdomadaires de tous les joueurs.",
    ["check_duty_status_desc"] = "Vérifier le statut de service d'un joueur.",
    ["check_daily_times_desc"] = "Vérifier les temps quotidiens pour une date spécifique.",
    ["check_weekly_times_desc"] = "Vérifier les temps hebdomadaires pour un emploi et une date de début de semaine spécifiques.",

    -- Localisation des jours
    ["dayLocalization"] = {
        "Dimanche",
        "Lundi",
        "Mardi",
        "Mercredi",
        "Jeudi",
        "Vendredi",
        "Samedi"
    },
}
