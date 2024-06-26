Locales["es"] = {
    -- General
    ["error_has_occurred"] = "Ha ocurrido un error.",
    ["no_trace_message"] = "No se ha proporcionado ningún mensaje de seguimiento.",
    ["no_permission"] = "No tienes permiso para usar este comando.",
    ["self"] = "Tú mismo",

    -- Fecha y hora
    ["invalid_date_format"] = "Formato de fecha inválido. Por favor, use el formato AAAA-MM-DD (ej.: /checkDailyTime 2023-05-15).",
    ["date_param"] = "Fecha",
    ["date_help"] = "Ingrese la fecha en formato AAAA-MM-DD.",
    ["missing_date"] = "¡Por favor, proporcione una fecha en formato AAAA-MM-DD!",
    ["week_commencing_param"] = "Semana comenzando",
    ["week_commencing_help"] = "Ingrese la fecha de inicio de la semana en formato AAAA-MM-DD.",

    -- Trabajos
    ["invalid_job_name"] = "¡Nombre de trabajo inválido!",
    ["job_name_param"] = "Nombre del trabajo",
    ["job_name_help"] = "Ingrese el nombre del trabajo.",
    ["ignore_job"] = "Ignorando el trabajo 'off_%s' ya que ya existe.",
    ["add_job"] = "Agregando el trabajo 'off_%s'",
    ["add_grade"] = "Agregando el grado de trabajo '%s - %s'",

    -- Estado de servicio
    ["go_off_duty"] = "¡Salir de servicio!",
    ["go_on_duty"] = "¡Entrar en servicio!",
    ["not_on_duty"] = "*Fuera de servicio*",
    ["went_off_duty"] = "¡Has salido de servicio!",
    ["went_on_duty"] = "¡Has entrado en servicio!",
    ["on_duty"] = "En servicio",
    ["off_duty"] = "Fuera de servicio",
    ["duty_status"] = "Estado de servicio de %s: %s",

    -- Identificación del jugador
    ["invalid_player_id"] = "¡ID de jugador inválido!",
    ["missing_player_id"] = "¡Por favor, proporcione un ID de jugador!",
    ["player_id_param"] = "ID de jugador",
    ["player_id_help"] = "Ingrese el ID de servidor del jugador.",
    ["optional_param"] = "(Opcional)",

    -- Seguimiento de tiempo
    ["job"] = "Trabajo",
    ["grade"] = "Grado",
    ["time"] = "Tiempo de sesión",
    ["reason"] = "Razón",
    ["out"] = "Fuera",
    ["week_total"] = "Total de la semana",
    ["online"] = "En línea",
    ["in"] = "Dentro",
    ["daily_time"] = "%s (%s): %s",
    ["your_daily_time"] = "Tu tiempo diario para %s: %s",
    ["no_data_found"] = "No se encontraron datos.",
    ["missing_parameters"] = "¡Faltan parámetros requeridos!",

    -- Webhooks de Discord
    ["webhook_not_set"] = 'El webhook "%s" no está configurado o está vacío.',
    ["failed_to_send"] = "Error al enviar el mensaje a Discord. Código de error: %d",
    ["failed_to_save"] = "¡Error al guardar los datos de seguimiento de tiempo!",
    ["hook_auth"] = "%s - Tiempos de trabajo semanales",
    ["hook_title"] = "Semana comenzando el %s",
    ["hook_desc"] = "**%s** - <@%s>\n%s",
    ["line_break"] = "══════════════════",
    ["no_data"] = "**No se encontraron datos**",
    ["no_job_data"] = "No se encontraron datos para el trabajo: %s",
    ["discord_bot_name"] = "SL_Duty Logs",
    ["discord_title"] = "¡%s ha %s el servicio!",
    ["clocked_in_out"] = "%s registrado",
    ["clocked_notif"] = "Notificación de registro %s",

    -- Descripciones de comandos
    ["logjobtimes_usage"] = "Uso: /logJobTimes [nombreTrabajo] [fechaInicioSemana (DD/MM/AA)]",
    ["job_count_desc"] = "Muestra cuántos jugadores están en línea para un trabajo específico.",
    ["log_job_times_desc"] = "Envía un registro a Discord con los tiempos de servicio diarios y semanales de todos los jugadores.",
    ["check_duty_status_desc"] = "Verificar el estado de servicio de un jugador.",
    ["check_daily_times_desc"] = "Verificar los tiempos diarios para una fecha específica.",
    ["check_weekly_times_desc"] = "Verificar los tiempos semanales para un trabajo y una fecha de inicio de semana específicos.",

    -- Localización de días
    ["dayLocalization"] = {
        "Domingo",
        "Lunes",
        "Martes",
        "Miércoles",
        "Jueves",
        "Viernes",
        "Sábado"
    },
}
