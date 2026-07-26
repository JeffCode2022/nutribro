# FitLife - Aplicación de Fitness y Nutrición

## Descripción
FitLife es una aplicación móvil desarrollada en Flutter diseñada para ayudarte a alcanzar tus objetivos de pérdida de peso mediante el seguimiento de comidas, rutinas de ejercicio y progreso personal.

## Características Principales

### 📊 Seguimiento de Progreso
- Registro de peso diario, semanal y mensual
- Gráficos de evolución con fl_chart
- Cálculo automático de IMC (Índice de Masa Corporal)
- Historial de mediciones corporales

### 🏋️ Rutinas de Ejercicio
- Plan semanal personalizado
- Biblioteca de ejercicios por grupo muscular:
  - **Pecho**: Press de banca, press inclinado, etc.
  - **Espalda**: Jalón al pecho, remo con barra
  - **Piernas**: Sentadilla, prensa de piernas
  - **Hombros**: Press militar, elevaciones laterales
  - **Brazos**: Curl de bíceps, extensiones de tríceps
- Detalles completos de cada ejercicio:
  - Series y repeticiones recomendadas
  - Tiempo de descanso entre series
  - Consejos de técnica correcta
  - Equipamiento necesario

### 🍎 Nutrición
- Seguimiento de calorías diarias
- Registro de macronutrientes (proteínas, carbohidratos, grasas)
- Control de consumo de agua
- Recomendaciones de comidas saludables
- Registro de comidas por tipo (desayuno, almuerzo, cena, snacks)

### 📈 Evaluación y Métricas
- Cálculo de calorías diarias recomendadas (fórmula Harris-Benedict)
- Déficit calórico automático para pérdida de peso
- Progreso por día, semana y mes
- Estadísticas de pérdida de peso total

## Estructura del Proyecto

```
fitlife_app/
├── lib/
│   ├── main.dart                 # Punto de entrada
│   ├── models/                   # Modelos de datos
│   │   ├── user_profile.dart     # Perfil de usuario
│   │   ├── exercise.dart         # Ejercicios y rutinas
│   │   └── meal.dart             # Comidas y registro nutricional
│   ├── providers/                # Gestión de estado
│   │   └── app_provider.dart     # Provider principal
│   ├── screens/                  # Pantallas de la app
│   │   ├── splash_screen.dart    # Pantalla de carga
│   │   ├── onboarding_screen.dart# Configuración inicial
│   │   ├── home_screen.dart      # Dashboard principal
│   │   ├── workout_screen.dart   # Rutinas de ejercicio
│   │   ├── nutrition_screen.dart # Seguimiento nutricional
│   │   └── progress_screen.dart  # Gráficos de progreso
│   ├── widgets/                  # Componentes reutilizables
│   └── services/                 # Servicios (DB, API)
├── assets/                       # Recursos estáticos
│   ├── images/
│   └── fonts/
└── pubspec.yaml                  # Dependencias
```

## Dependencias Principales

- **provider**: Gestión de estado
- **fl_chart**: Gráficos para visualización de progreso
- **shared_preferences**: Almacenamiento local
- **sqflite**: Base de datos local
- **intl**: Formato de fechas y números
- **google_fonts**: Tipografías
- **font_awesome_flutter**: Iconos adicionales

## Instalación

1. Asegúrate de tener Flutter instalado (versión 3.0 o superior)
2. Clona el repositorio
3. Navega a la carpeta del proyecto:
   ```bash
   cd fitlife_app
   ```
4. Instala las dependencias:
   ```bash
   flutter pub get
   ```
5. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Cómo Usar

### Primera Vez
1. La aplicación te guiará por un proceso de configuración inicial
2. Ingresa tu información personal (nombre, edad, género)
3. Registra tus medidas corporales (altura, peso actual)
4. Establece tu peso objetivo
5. La app calculará automáticamente tus calorías diarias recomendadas

### Uso Diario
1. **Dashboard**: Vista rápida de tu progreso diario
2. **Registrar Peso**: Mantén tu peso actualizado
3. **Ejercicios**: Consulta tu rutina del día y la biblioteca de ejercicios
4. **Nutrición**: Registra tus comidas y consumo de agua
5. **Progreso**: Visualiza tu evolución con gráficos

## Próximas Mejoras

- [ ] Integración con base de datos real (SQLite)
- [ ] Autenticación de usuarios
- [ ] Sincronización en la nube
- [ ] Más ejercicios con imágenes/video
- [ ] Recetario saludable
- [ ] Recordatorios y notificaciones
- [ ] Exportar datos a PDF/Excel
- [ ] Modo oscuro
- [ ] Soporte para múltiples idiomas

## Requisitos del Sistema

- Android 5.0 o superior
- iOS 12.0 o superior
- Flutter SDK 3.0+
- Dart SDK 3.0+

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---

**¡Comienza tu viaje fitness hoy con FitLife!** 💪
