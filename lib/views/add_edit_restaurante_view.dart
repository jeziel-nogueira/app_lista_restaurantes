import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant_model.dart'; // Importa o modelo do restaurante
import '../viewmodels/restaurant_view_model.dart'; // Importa o ViewModel para manipular dados
import '../widgets/snackbar_widget.dart'; // Importa um widget personalizado para exibir mensagens

// Página para adicionar ou editar informações de um restaurante
class AddEditRestaurantPage extends StatefulWidget {
  final RestaurantModel? restaurant; // Restaurante a ser editado (ou nulo, se for um novo restaurante)
  const AddEditRestaurantPage({Key? key, this.restaurant}) : super(key: key);

  @override
  _AddEditRestaurantPageState createState() => _AddEditRestaurantPageState();
}

class _AddEditRestaurantPageState extends State<AddEditRestaurantPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  late String title; // Nome do restaurante
  late String description; // Descrição do restaurante
  late String type; // Tipo de comida do restaurante

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel para manipular dados do restaurante
    final restaurantViewModel = Provider.of<RestaurantViewModel>(context, listen: false);

    // Obtendo o uid do usuário atual autenticado
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(widget.restaurant == null ? 'Adicionar Restaurante' : 'Editar Restaurante'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Cor de fundo da AppBar
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Sombra suave
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
                const BoxShadow(
                  color: Colors.white, // Sombra clara
                  offset: Offset(-5, -15),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Associa a chave ao formulário para validação
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Campo de texto para o nome do restaurante
                  _buildTextField(
                    initialValue: widget.restaurant?.title ?? '',
                    label: 'Nome do Restaurante',
                    onSaved: (value) => title = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome do restaurante não pode estar vazio'; // Valida se o campo está vazio
                      }
                      return null; // Retorna null se a validação passar
                    },
                  ),
                  // Campo de texto para a descrição do restaurante
                  _buildTextField(
                    initialValue: widget.restaurant?.description ?? '',
                    label: 'Descrição',
                    onSaved: (value) => description = value!,
                    isDescriptionField: true, // Campo maior para descrição
                  ),
                  // Campo de texto para o tipo de comida do restaurante
                  _buildTextField(
                    initialValue: widget.restaurant?.type ?? '',
                    label: 'Tipo de Comida',
                    onSaved: (value) => type = value!,
                  ),
                  const SizedBox(height: 20),
                  // Botão para adicionar ou atualizar o restaurante
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      // Valida o formulário antes de salvar
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save(); // Salva os valores do formulário
                        try {
                          if (widget.restaurant == null) {
                            // Se não existe restaurante, adiciona um novo
                            await restaurantViewModel.addRestaurant(
                              RestaurantModel(id: '', title: title, description: description, type: type, userId: userId!),
                            );
                          } else {
                            // Se existe restaurante, atualiza o existente
                            await restaurantViewModel.updateRestaurant(
                              RestaurantModel(id: widget.restaurant!.id, title: title, description: description, type: type, userId: userId!),
                            );
                          }
                          // Exibe uma mensagem de sucesso
                          ShowSnackBar(context: context, message: ((widget.restaurant != null) ? 'Atualizado com sucesso' : 'Cadastrado com sucesso'), isError: false);
                          Navigator.pop(context); // Fecha a tela após salvar
                        } catch (e) {
                          // Exibe uma mensagem de erro em caso de falha
                          ShowSnackBar(context: context, message: 'ERRO: ${e}');
                        }
                      }
                    },
                    child: Text(
                      widget.restaurant == null ? 'Adicionar' : 'Atualizar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Função auxiliar para construir campos de texto personalizados
  Widget _buildTextField({
    required String initialValue, // Valor inicial do campo
    required String label, // Rótulo do campo
    required FormFieldSetter<String> onSaved, // Função para salvar o valor do campo
    FormFieldValidator<String>? validator, // Validador opcional do campo
    bool isDescriptionField = false, // Define se o campo é de descrição (campo maior)
  }) {
    return Container(
      height: isDescriptionField ? 150 : 60, // Ajusta a altura para descrição
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onSaved: onSaved,
        validator: validator, // Usa o validador, se fornecido
      ),
    );
  }
}
