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
      theme: ThemeData(useMaterial3: true),
      home: const WelcomeScreen(),
    );
  }
}

// ==========================================
// PANTALLA 1: BIENVENIDA
// ==========================================
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..forward();

  // Fase 1: la mano saluda y luego se desvanece.
  late final Animation<double> _handOpacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
  ]).animate(_controller);

  // Vaivén de la mano imitando el saludo en LSM.
  late final Animation<double> _handWave = TweenSequence<double>([
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 15),
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.3), weight: 10),
    TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3), weight: 15),
    TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 15),
    TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.0), weight: 15),
    TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
  ]).animate(_controller);

  // Fase 2: aparece la imagen de bienvenida.
  late final Animation<double> _imageFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
  );

  late final Animation<double> _imageScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.45, 1.0, curve: Curves.elasticOut),
  );

  // Fase 3: aparecen los botones al final.
  late final Animation<double> _buttonsFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

              SizedBox(
                width: 400,
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FadeTransition(
                      opacity: _handOpacity,
                      child: AnimatedBuilder(
                        animation: _handWave,
                        builder: (context, child) => Transform.rotate(
                          angle: _handWave.value,
                          child: child,
                        ),
                        child: const Icon(
                          Icons.front_hand,
                          size: 140,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _imageFade,
                      child: ScaleTransition(
                        scale: _imageScale,
                        child: Image.asset(
                          'assets/bienvenida.png',
                          width: 400,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              FadeTransition(
                opacity: _buttonsFade,
                child: Column(
                  children: [
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onAccederPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo y contraseña.')),
      );
      return;
    }

    try {
      final valido = await DBHelper.validarLogin(email, password);
      if (!mounted) return;
      if (valido) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(correo: email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar con la base de datos: $e')),
      );
    }
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
                  hintText: 'Correo',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
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
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
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
  bool _obscurePassword = true;

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
      final exito = await DBHelper.registrarUsuario(username, email, password);

      if (!mounted) return;
      if (exito) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ese correo ya está registrado.')),
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
      color: Colors.grey.withValues(alpha: 0.7),
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
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
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
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Ingrese la contraseña',
                  labelStyle: customLabelStyle,
                  hintText: 'Ej. 123456',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
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

// ==========================================
// PANTALLA 4: INICIO (bienvenida + mapa de lecciones)
// ==========================================
class _Leccion {
  const _Leccion(this.titulo, this.icono, this.desbloqueada);

  final String titulo;
  final IconData icono;
  final bool desbloqueada;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.correo});

  final String correo;

  static const _lecciones = [
    _Leccion('Saludos', Icons.waving_hand, true),
    _Leccion('Alfabeto', Icons.abc, false),
    _Leccion('Números', Icons.pin, false),
    _Leccion('Familia', Icons.family_restroom, false),
    _Leccion('Colores', Icons.palette, false),
  ];

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFA88CE0);
    const nodeColor = Color(0xFFFF69B4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  const Icon(Icons.front_hand, color: Colors.white, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '¡Hola de nuevo, ${correo.split('@').first}! 👋\n'
                      'Sigamos aprendiendo LSM.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: _lecciones.length,
                itemBuilder: (context, index) {
                  final leccion = _lecciones[index];
                  final alineadoIzquierda = index.isEven;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: alineadoIzquierda
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        SizedBox(width: alineadoIzquierda ? 40 : 0),
                        GestureDetector(
                          onTap: () {
                            final mensaje = leccion.desbloqueada
                                ? 'Abriendo "${leccion.titulo}"... ¡pronto!'
                                : 'Completa la lección anterior para desbloquear "${leccion.titulo}".';
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(mensaje)));
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: leccion.desbloqueada
                                    ? nodeColor
                                    : Colors.white.withValues(alpha: 0.4),
                                child: Icon(
                                  leccion.desbloqueada
                                      ? leccion.icono
                                      : Icons.lock,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                leccion.titulo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: alineadoIzquierda ? 0 : 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
