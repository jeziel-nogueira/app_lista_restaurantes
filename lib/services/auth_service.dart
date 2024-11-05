import 'package:firebase_auth/firebase_auth.dart';

class UserAuthService {
  final  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Cadastrar usuario com email e senha usando FirebaseAuth
  Future<String?> UserRegister({
    required String user,
    required String email,
    required String password,
  })  async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Atualiza o perfil do usuário com o nome
      await userCredential.user?.updateProfile(displayName: user);
      return null;
    } on FirebaseAuthException catch (e) {
      // Retorna o erro para tratamento posterior
      if(e.code == 'email-already-in-use'){
        return 'Usuario ja cadastrado';
      }
      else{
        return 'Erro ao criar conta';
      }
    }
  }

  // Autenticar usuario usando email e senha
  Future<String?> UserLogin({
    required String user,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      print('Code: ${e.code}');
      if(e.code == 'invalid-credential'){
        return 'E-mail ou senha invalido';
      }else{
        return 'Erro na autenticação';
      }
    }
  }

  Future<void> Logout() async{
    print('Logout again ............');
    return _firebaseAuth.signOut();
  }
}
