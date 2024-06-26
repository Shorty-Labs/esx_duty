Locales["pt"] = {
    -- Geral
    ["error_has_occurred"] = "Ocorreu um erro.",
    ["no_trace_message"] = "Nenhuma mensagem de rastreamento fornecida.",
    ["no_permission"] = "Você não tem permissão para usar este comando.",
    ["self"] = "Você mesmo",

    -- Data e hora
    ["invalid_date_format"] = "Formato de data inválido. Por favor, use o formato AAAA-MM-DD (ex.: /checkDailyTime 2023-05-15).",
    ["date_param"] = "Data",
    ["date_help"] = "Insira a data no formato AAAA-MM-DD.",
    ["missing_date"] = "Por favor, forneça uma data no formato AAAA-MM-DD!",
    ["week_commencing_param"] = "Semana Começando",
    ["week_commencing_help"] = "Insira a data de início da semana no formato AAAA-MM-DD.",

    -- Empregos
    ["invalid_job_name"] = "Nome de emprego inválido!",
    ["job_name_param"] = "Nome do Emprego",
    ["job_name_help"] = "Insira o nome do emprego.",
    ["ignore_job"] = "Ignorando o emprego 'off_%s', pois já existe.",
    ["add_job"] = "Adicionando o emprego 'off_%s'",
    ["add_grade"] = "Adicionando o grau de emprego '%s - %s'",

    -- Status de Serviço
    ["go_off_duty"] = "Sair de Serviço!",
    ["go_on_duty"] = "Entrar em Serviço!",
    ["not_on_duty"] = "*Fora de Serviço*",
    ["went_off_duty"] = "Você saiu de serviço!",
    ["went_on_duty"] = "Você entrou em serviço!",
    ["on_duty"] = "Em Serviço",
    ["off_duty"] = "Fora de Serviço",
    ["duty_status"] = "Status de serviço de %s: %s",

    -- Identificação do Jogador
    ["invalid_player_id"] = "ID de jogador inválida!",
    ["missing_player_id"] = "Por favor, forneça uma ID de jogador!",
    ["player_id_param"] = "ID do Jogador",
    ["player_id_help"] = "Insira a ID do servidor do jogador.",
    ["optional_param"] = "(Opcional)",

    -- Rastreamento de Tempo
    ["job"] = "Emprego",
    ["grade"] = "Grau",
    ["time"] = "Tempo de Sessão",
    ["reason"] = "Razão",
    ["out"] = "Fora",
    ["week_total"] = "Total da Semana",
    ["online"] = "Online",
    ["in"] = "Dentro",
    ["daily_time"] = "%s (%s): %s",
    ["your_daily_time"] = "Seu tempo diário para %s: %s",
    ["no_data_found"] = "Nenhum dado encontrado.",
    ["missing_parameters"] = "Parâmetros obrigatórios ausentes!",

    -- Webhooks do Discord
    ["webhook_not_set"] = 'O webhook "%s" não está definido ou está vazio.',
    ["failed_to_send"] = "Falha ao enviar mensagem para o Discord. Código de erro: %d",
    ["failed_to_save"] = "Falha ao salvar os dados de rastreamento de tempo!",
    ["hook_auth"] = "%s - Tempos de Trabalho Semanais",
    ["hook_title"] = "Semana Começando em %s",
    ["hook_desc"] = "**%s** - <@%s>\n%s",
    ["line_break"] = "══════════════════",
    ["no_data"] = "**Nenhum Dado Encontrado**",
    ["no_job_data"] = "Nenhum dado encontrado para o emprego: %s",
    ["discord_bot_name"] = "SL_Duty Logs",
    ["discord_title"] = "%s %s de serviço!",
    ["clocked_in_out"] = "%s registrado",
    ["clocked_notif"] = "Notificação de Registro %s",

    -- Descrições de Comando
    ["logjobtimes_usage"] = "Uso: /logJobTimes [nomeEmprego] [dataInicioSemana (DD/MM/AA)]",
    ["job_count_desc"] = "Mostra quantos jogadores estão online para um emprego específico.",
    ["log_job_times_desc"] = "Envia um log para o Discord com os tempos diários e semanais de serviço de todos os jogadores.",
    ["check_duty_status_desc"] = "Verificar o status de serviço de um jogador.",
    ["check_daily_times_desc"] = "Verificar os tempos diários para uma data específica.",
    ["check_weekly_times_desc"] = "Verificar os tempos semanais para um emprego e data de início de semana específicos.",

    -- Localização de Dias
    ["dayLocalization"] = {
        "Domingo",
        "Segunda-feira",
        "Terça-feira",
        "Quarta-feira",
        "Quinta-feira",
        "Sexta-feira",
        "Sábado"
    },
}
