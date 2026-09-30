import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

class DBHelper {
  static Future<MySqlConnection> getConnection() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'La conexión directa a MySQL no está disponible en Flutter Web.',
      );
    }

    final settings = ConnectionSettings(
      host: defaultTargetPlatform == TargetPlatform.android
          ? '10.0.2.2'
          : '127.0.0.1',
      port: 3307,
      user: 'signi_app',
      password: 'signi_local_password',
      db: 'signi_db',
    );
    return MySqlConnection.connect(settings);
  }

  static Future<bool> validarLogin(String correo, String contrasena) async {
    final conn = await getConnection();
    try {
      final results = await conn.query(
        'SELECT id, nombre, correo FROM usuarios WHERE correo = ? AND contrasena = ?',
        [correo, contrasena],
      );
      return results.isNotEmpty;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> registrarUsuario(
    String nombre,
    String correo,
    String contrasena,
  ) async {
    final conn = await getConnection();
    try {
      final existe = await conn.query(
        'SELECT id FROM usuarios WHERE correo = ?',
        [correo],
      );

      if (existe.isNotEmpty) {
        return false;
      }

      await conn.query(
        'INSERT INTO usuarios (nombre, correo, contrasena) VALUES (?, ?, ?)',
        [nombre, correo, contrasena],
      );

      return true;
    } finally {
      await conn.close();
    }
  }
}
