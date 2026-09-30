# signi_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

## Base de datos local

La base local usa MariaDB en Docker. Inicia Docker Desktop y, desde la carpeta del proyecto, ejecuta:

```powershell
docker compose up -d
```

El contenedor crea la base `signi_db` y la tabla `usuarios` al inicializarse. Después ejecuta la app en Windows o en un emulador Android; Flutter Web no admite esta conexión directa a MySQL.

Las credenciales incluidas son solo para desarrollo local. No las uses en una app publicada: las credenciales de la base no deben guardarse dentro de una aplicación cliente.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
