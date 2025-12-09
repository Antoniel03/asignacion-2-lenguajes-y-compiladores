//Propuesta A: 
//Control Eficiente de Aire Acondicionado 
//Objetivo: Mantener la casa fresca (23°C) solo si las ventanas están cerradas. Si se abre una ventana, apagar el aire inmediatamente para no desperdiciar energía.


TAREA Control_Clima_Eficiente
    // Bucle infinito de supervisión
    REPETIR_SIEMPRE

        VAR temp = obtenerTemperatura()
        VAR ventana_abierta = estadoVentana()

        // Regla de seguridad: Si la ventana está abierta, apagar todo
        SI (ventana_abierta == 1) ENTONCES
            fijarEstado(A_AC_POWER, OFF)
            alertarUsuario("Aire apagado: Ventana abierta detectada")
        
        SINO
            // Si la ventana está cerrada, gestionar temperatura
            SI (temp > 24) ENTONCES
                fijarEstado(A_AC_POWER, ON)
                fijarEstado(A_AC_MODO, FRIO)
            SINO
                SI (temp < 20) ENTONCES
                    // Si hace mucho frío, solo ventilar o apagar
                    fijarEstado(A_AC_POWER, OFF)
                FIN_SI
            FIN_SI
        FIN_SI

        // Verificar cada 60 segundos
        ESPERAR(60000)
    FIN_REPETIR
FIN_TAREA


//Propuesta B: 
//Iluminación Inteligente y de Seguridad 
//Objetivo: Encender las luces del jardín automáticamente cuando oscurece. Encender las luces de la sala solo si es de noche Y hay alguien presente, para simular actividad o iluminar el paso.


TAREA Gestion_Iluminacion
    VAR umbral_oscuridad = 20 // Porcentaje de luz bajo el cual se considera noche

    REPETIR_SIEMPRE
        
        VAR luz_actual = nivelLuzExterior()
        VAR hay_gente = detectarMovimiento()

        // 1. Control de Luces de Jardín (Solo depende de la luz solar)
        SI (luz_actual < umbral_oscuridad) ENTONCES
            fijarEstado(A_LUZ_JARDIN, ON)
        SINO
            fijarEstado(A_LUZ_JARDIN, OFF)
        FIN_SI

        // 2. Control de Sala (Depende de luz solar Y presencia)
        SI (luz_actual < umbral_oscuridad AND hay_gente == 1) ENTONCES
            fijarNivel(A_LUZ_SALA, 100) // Encender al máximo
        SINO
            // Si es de día o no hay nadie, apagar sala
            fijarEstado(A_LUZ_SALA, OFF)
        FIN_SI

        // Muestreo rápido (cada 2 segundos) para respuesta inmediata al movimiento
        ESPERAR(2000)
    FIN_REPETIR
FIN_TAREA