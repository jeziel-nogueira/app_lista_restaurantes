import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/snackbar_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.title});

  final String title;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserAuthService _userAuth = UserAuthService();
  bool login = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Restaurantes'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, -15),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(5, 5),
                          blurRadius: 15,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Set your text to save:',
                            style: TextStyle(fontSize: 18),
                          ),
                          _buildTextField(
                            controller: _userController,
                            label: 'User',
                            validator: validateUser,
                            isVisible: !login,
                          ),
                          _buildTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            validator: validateEmail,
                            isVisible: true,
                          ),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            validator: (value) => validatePassword(
                              value,
                              isLogin: login,
                              confirmPassword: _confirmPasswordController.text,
                            ),
                            isVisible: true,
                            obscureText: true,
                          ),
                          Visibility(
                            visible: !login,
                            child: _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              validator: (value) => validateConfirmPassword(
                                  value, _passwordController.text),
                              isVisible: true,
                              obscureText: true,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300], // Cor do texto
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              formValidator();
                            },
                            child: Text((login) ? 'Entrar' : 'Cadastrar'),
                          ),
                          _buildToggleButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    required bool isVisible,
    bool obscureText = false,
  }) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(5, 5),
              blurRadius: 10,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            label: Text(label),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          validator: validator,
          obscureText: obscureText,
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(login ? 'Não tem uma conta?' : 'Já tem uma conta?'),
        TextButton(
          onPressed: () {
            setState(() {
              login = !login;
            });
          },
          child: Text(login ? 'CADASTRAR' : 'ENTRAR'),
        ),
      ],
    );
  }


  // Função para login ou criação de conta apos validção do formulario
  formValidator() async {
    if (_formKey.currentState!.validate()) {
      if (login) {
        // Logar conta de usuario
        _userAuth.UserLogin(
          user: _userController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ).then(
          (String? error) {
            // Alerta erro ao logar conta
            if (error != null) {
              ShowSnackBar(context: context, message: error);
            }
          },
        );
      } else {
        // Criar conta de usuario
        _userAuth.UserRegister(
          user: _userController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ).then((String? error) {
          // Alerta erro ao registra conta
          if (error != null) {
            print('ERRO: ${error}');
            ShowSnackBar(context: context, message: error);
          } else {
            setState(() {
              login = !login;
            });
            ShowSnackBar(
                context: context,
                message: 'Conta Criada com sucesso!',
                isError: false);
          }
        });
      }
    } else {
      if (login) {
        print('Erro nos dados de login');
      } else {
        print('Erro ao criar conta');
      }
    }
  }

  // Função de validação para o campo de nome de usuário
  String? validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo não pode ser vazio';
    }
    if (value.length < 5) {
      return 'Nome de usuário muito curto';
    }
    return null;
  }

  // Função de validação para o campo de senha
  String? validatePassword(String? value,
      {bool isLogin = true, String? confirmPassword}) {
    if (value == null || value.isEmpty) {
      return 'O campo não pode ser vazio';
    }
    if (value.length < 5) {
      return 'Senha muito curta';
    }
    if (!isLogin && value != confirmPassword) {
      return 'Senha não confere';
    }
    return null;
  }

  // Função de validação para o campo de confirmação de senha
  String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'O campo não pode ser vazio';
    }
    if (value != password) {
      return 'Senha não confere';
    }
    return null;
  }

  // Função de validação para o campo de e-mail
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail não pode ser vazio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }
}
