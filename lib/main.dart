import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SigniApp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ==========================================
// PANTALLA 1: BIENVENIDA
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFA88CE0);
    const buttonColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Image.asset('assets/bienvenida.png', width:400,height:400,fit:BoxFit.contain,),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PANTALLA 2: INICIO DE SESIÓN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAccederPressed() {
    final email = _emailController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ingresando con: $email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFA88CE0);
    const fieldFillColor = Color(0xFFE8E0F0);
    const buttonColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Image.asset('assets/bienvenida.png', width:400,height:400,fit:BoxFit.contain,),
              const Spacer(),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Correo',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _emailController.clear(),
                  ),
                  filled: true,
                  fillColor: fieldFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _passwordController.clear(),
                  ),
                  filled: true,
                  fillColor: fieldFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onAccederPressed,
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Acceder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// Register screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onAccederPressed() async {
    final email = _emailController.text.trim();
    final username = _name.text.trim();
    final password = _passwordController.text.trim();

    // 1. Validar que los campos no estén vacíos
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    try {
      // 2. Mostrar mensaje de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrando a $email...')),
      );

      // 3. AQUÍ LLAMAS A TU BASE DE DATOS
      bool exito = true; // Cambiar por tu llamada real a la BD

      if (exito && mounted) {
        // 4. Cambiar a la pantalla principal tras registro exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con la base de datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customLabelStyle = TextStyle(
      color: Colors.grey.withOpacity(0.7),
      fontSize: 14,
    );
    const backgroundColor = Color(0xFFA88CE0);
    const fieldFillColor = Color(0xFFE8E0F0);
    const buttonColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/bienvenida.png',
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  labelStyle: customLabelStyle,
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _emailController.clear(),
                  ),
                  filled: true,
                  fillColor: fieldFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  labelStyle: customLabelStyle,
                  hintText: 'Ej. JuanPerez123',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _name.clear(),
                  ),
                  filled: true,
                  fillColor: fieldFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Ingrese la contraseña',
                  labelStyle: customLabelStyle,
                  hintText: 'Ej. 123456',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: () => _passwordController.clear(),
                  ),
                  filled: true,
                  fillColor: fieldFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onAccederPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Acceder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}