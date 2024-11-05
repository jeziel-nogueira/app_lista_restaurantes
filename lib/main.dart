import 'package:app_n2/viewmodels/restaurant_view_model.dart';
import 'package:app_n2/views/home_view.dart';
import 'package:app_n2/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  // Garantindo que os widgets estejam prontos para inicialização antes de chamar Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando o Firebase com as configurações específicas da plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Executando o aplicativo com MultiProvider para fornecer dependências necessárias
  runApp(
    MultiProvider(
      providers: [
        // Configurando RestaurantViewModel como um ChangeNotifierProvider para ser acessado no aplicativo
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
      ],
      child: const MyApp(), // Iniciando o aplicativo principal
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget é a raiz do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ocultando a faixa de debug
      title: 'Flutter Demo',
      theme: ThemeData(
        // Definindo o esquema de cores com uma cor semente
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Usando o Material Design 3
      ),
      home: const ScreenRouter(), // Definindo a tela inicial do aplicativo
    );
  }
}

// Widget ScreenRouter verifica o status de autenticação do usuário
class ScreenRouter extends StatelessWidget {
  const ScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Ouvindo mudanças de status do usuário autenticado via FirebaseAuth
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Se há um usuário autenticado, redireciona para a página de lista de restaurantes
          return RestaurantListPage();
        } else {
          // Caso contrário, redireciona para a tela de login
          return const LoginView(title: 'Restaurantes');
        }
      },
    );
  }
}
