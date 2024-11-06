import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../viewmodels/restaurant_view_model.dart';
import '../widgets/snackbar_widget.dart';
import 'add_edit_restaurante_view.dart';
import '../services/auth_service.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final RestaurantViewModel restaurantViewModel = RestaurantViewModel(); // ViewModel para gerenciar a lista de restaurantes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Define a cor de fundo da tela
      appBar: AppBar(
        title: const Text('Restaurantes'), // Título da AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Cor de fundo da AppBar
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [ // Adiciona sombras para um efeito de elevação
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
      drawer: Drawer(
        child: Container(
          color: Colors.grey[200], // Cor de fundo do Drawer
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(), // Monitora o estado de autenticação
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Exibe um indicador de carregamento
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}')); // Exibe uma mensagem de erro
                }

                // Dados do usuário autenticado
                User? user = snapshot.data;
                String username = user?.displayName ?? 'Nome não disponível';
                String email = user?.email ?? 'Email não disponível';

                return ListView(
                  children: [
                    // Exibe informações do usuário no Drawer
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [ /* Sombras */
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                      child: ListTile(
                        leading: const Icon(Icons.person_2_rounded), // Ícone do usuário
                        title: Text(username),
                        subtitle: Text(email),
                      ),
                    ),
                    // Botão de logout
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [ /* Sombras */
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                      child: ListTile(
                        leading: const Icon(Icons.login_rounded), // Ícone de logout
                        title: const Text('Deslogar'),
                        onTap: () async {
                          UserAuthService().Logout(); // Chama o serviço de logout
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(height: 20,),
        Expanded(child: StreamBuilder<List<RestaurantModel>>(
          stream: restaurantViewModel.getUserRestaurants(), // Obtém a lista de restaurantes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Indicador de carregamento
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum restaurante encontrado')); // Mensagem caso não haja dados
            }
            final restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [ /* Sombras */
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                  child: ListTile(
                    title: Text(
                      restaurant.title, // Título do restaurante
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      restaurant.description, // Descrição do restaurante
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Limita a 2 linhas
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [ /* Sombras do botão */
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(5, 5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete), // Ícone de deletar
                        onPressed: () async {
                          final response = await restaurantViewModel.deleteRestaurant(restaurant.id); // Deleta o restaurante
                          if (response != null) {
                            if (mounted) {
                              ShowSnackBar(context: context, message: 'ERRO: $response'); // Mensagem de erro
                            }
                          } else {
                            if (mounted) {
                              ShowSnackBar(context: context, message: 'Removido com sucesso', isError: false); // Confirmação de sucesso
                            }
                          }
                        },
                      ),
                    ),
                    onTap: () {
                      // Navega para a página de edição
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditRestaurantPage(restaurant: restaurant),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),)
      ],),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: [ /* Sombras do botão flutuante */
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 15,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Navega para a página de adicionar restaurante
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditRestaurantPage(),
              ),
            );
          },
          backgroundColor: Colors.transparent, // Fundo transparente para efeito visual
          elevation: 0,
          child: const Icon(Icons.add), // Remove elevação padrão
        ),
      ),
    );
  }
}
