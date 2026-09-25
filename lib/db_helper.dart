import 'package:mysql1/mysql1.dart';

class DBHelper {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '10.0.2.2', // Usa '10.0.2.2' para Emulador Android, o '127.0.0.1' para Chrome / Desktop
      port: 3307,        // Puerto mapeado en tu Docker
      user: 'root',
      password: 'mi_contraseña_secreta',
      db: 'signi_db',
    );
    return await MySqlConnection.connect(settings);
  }

  // --- 1. VALIDAR LOGIN ---
  static Future<bool> validarLogin(String correo, String contrasena) async {
    try {
      final conn = await getConnection();
      var results = await conn.query(
        'SELECT id, nombre, correo FROM usuarios WHERE correo = ? AND contrasena = ?',
        [correo, contrasena],
      );
      await conn.close();
      return results.isNotEmpty;
    } catch (e) {
      print('Error al conectar con MySQL: $e');
      return false;
    }
  }

  // --- 2. REGISTRAR NUEVO USUARIO ---
  static Future<bool> registrarUsuario(String nombre, String correo, String contrasena) async {
    try {
      final conn = await getConnection();

      // Verificar primero si el correo ya existe en la BD
      var existe = await conn.query(
        'SELECT id FROM usuarios WHERE correo = ?',
        [correo],
      );

      if (existe.isNotEmpty) {
        await conn.close();
        print('El correo ya está registrado');
        return false; // Retorna false si el correo ya pertenece a otro usuario
      }

      // Insertar el nuevo usuario en la tabla usuarios
      await conn.query(
        'INSERT INTO usuarios (nombre, correo, contrasena) VALUES (?, ?, ?)',
        [nombre, correo, contrasena],
      );

      await conn.close();
      return true; // Registro exitoso
    } catch (e) {
      print('Error al registrar usuario: $e');
      return false;
    }
  }
}