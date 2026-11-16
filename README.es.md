# Outreach

Aplicación Flutter para gestionar contactos de outreach sin conexión. Permite crear, editar, buscar, filtrar y eliminar leads, registrar su historial y importar o exportar datos en CSV.

La interfaz actual está en inglés.

English version: [README.md](README.md)

## Documentación

- [Arquitectura](docs/architecture.md)
- [Especificación de gestión de leads](docs/specs/001-lead-management/spec.md)
- [Plan de implementación](docs/specs/001-lead-management/plan.md)
- [Tareas de implementación](docs/specs/001-lead-management/tasks.md)
- [Guía para agentes de programación con IA](AGENTS.md)

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) con Dart `^3.10.1`.
- Un dispositivo, emulador o destino de escritorio configurado para la plataforma elegida.
- Para Android, Android Studio y el SDK de Android; para Windows, las herramientas de desarrollo de Visual Studio con C++.

Comprueba la instalación con:

```bash
flutter doctor
```

## Crear el entorno local

Clona el repositorio y entra en la carpeta del proyecto:

```bash
git clone <URL_DEL_REPOSITORIO>
cd outreach_flutter
```

Instala las dependencias y comprueba los destinos disponibles:

```bash
flutter pub get
flutter devices
```

Ejecuta la aplicación en el destino seleccionado:

```bash
flutter run
```

También puedes indicar un destino concreto:

```bash
flutter run -d windows
flutter run -d <ID_DEL_DISPOSITIVO>
```

## Comandos habituales

```bash
# Ejecutar todas las pruebas
flutter test

# Analizar el código
flutter analyze

# Formatear el código Dart
dart format lib test

# Generar el código de Drift después de cambiar la base de datos
dart run build_runner build --delete-conflicting-outputs

# Mantener el generador activo durante el desarrollo
dart run build_runner watch --delete-conflicting-outputs

# Crear un paquete de producción para Windows o Android
flutter build windows
flutter build apk
```

## Estructura

```text
lib/
  main.dart                         Punto de entrada e inyección de dependencias.
  app/
    app.dart                         MaterialApp, tema y repositorio compartido.
    router/app_router.dart           Rutas: listado, creación y edición.
    theme/app_theme.dart             Tema visual.
  core/database/
    app_database.dart                Tablas, migraciones y conexión SQLite.
    app_database.g.dart              Código generado; no editar manualmente.
  features/leads/
    domain/                          Modelos y contrato del repositorio.
    data/                            Drift y lectura/escritura de CSV.
    presentation/                    Páginas, Cubits y estados de la UI.
test/                                Pruebas de dominio, Cubits e importación/exportación.
```

## Arquitectura

Cada funcionalidad se organiza en tres capas:

- `domain`: entidades como `Lead`, enumeraciones y la interfaz `LeadsRepository`.
- `data`: implementación `DriftLeadsRepository` y servicios CSV.
- `presentation`: widgets, estados y Cubits de `flutter_bloc`.

`main.dart` crea `AppDatabase` y el repositorio. `OutreachApp` los expone a las pantallas y `AppRouter` construye los Cubits de cada ruta.

Los datos se guardan localmente en `outreach.sqlite`, dentro del directorio de soporte de la aplicación del sistema operativo. No hay backend ni configuración de credenciales.

## Modificar la aplicación

### Cambiar la interfaz o el tema

- Modifica colores, tipografías y componentes globales en `lib/app/theme/app_theme.dart`.
- Modifica el listado y las acciones CSV en `lib/features/leads/presentation/leads_list/leads_page.dart`.
- Modifica el formulario y el historial en `lib/features/leads/presentation/lead_form/` y `lead_history/`.
- Añade o cambia rutas en `lib/app/router/app_router.dart`.

Al guardar, `flutter run` aplica *hot reload* a la mayoría de cambios de widgets. Reinicia la aplicación si cambias el inicio, inyección de dependencias o la base de datos.

### Añadir o cambiar campos de un lead

1. Actualiza las entidades y validaciones de `lib/features/leads/domain/lead.dart`.
2. Actualiza el contrato en `leads_repository.dart` y su implementación en `data/drift_leads_repository.dart`.
3. Actualiza la tabla `Leads`, los mapeos y las migraciones en `lib/core/database/app_database.dart`.
4. Incrementa `schemaVersion` y añade una migración condicionada en `onUpgrade`. No modifiques migraciones anteriores: ya pueden existir bases de datos instaladas con esas versiones.
5. Regenera el archivo `app_database.g.dart` con el comando de `build_runner` anterior.
6. Adapta formulario, lista, CSV y pruebas.

Para un campo nuevo nullable, la migración normalmente usa `migrator.addColumn`. Si el campo debe ser obligatorio, define una estrategia de valor por defecto o migración de datos para las instalaciones existentes.

### Añadir una nueva funcionalidad

1. Crea la entidad o extiende las existentes en `domain`.
2. Añade las operaciones necesarias al repositorio.
3. Implementa el acceso a datos en `data`.
4. Crea un Cubit y un estado en `presentation`.
5. Conecta la pantalla en `app_router.dart` y añade pruebas en `test/`.

## CSV

La lista permite exportar todos los leads visibles, una selección o un lead individual. La importación ofrece dos modos:

- **Insert only**: crea un lead por cada fila válida.
- **Merge/update**: actualiza un lead existente cuando coincide el email.

Antes de modificar el formato CSV, revisa y prueba conjuntamente `csv_leads_importer.dart`, `csv_leads_exporter.dart` y sus pruebas correspondientes en `test/`.

## Verificación antes de entregar cambios

```bash
dart format lib test
flutter analyze
flutter test
```

Si cambias una tabla Drift, incluye además la generación de código y verifica el flujo con una base de datos existente, no solo con una instalación limpia.
