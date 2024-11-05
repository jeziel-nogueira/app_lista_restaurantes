import 'package:flutter/material.dart';

void ShowSnackBar({
  required BuildContext context, // Contexto do widget, necessário para exibir o SnackBar
  required String message,       // Mensagem que será exibida no SnackBar
  bool isError = true,           // Indica se é uma mensagem de erro; padrão é true
}) {
  // Verifica se o contexto ainda está montado (ativo) antes de exibir o SnackBar
  if (!context.mounted) return;

  // Define o SnackBar com as configurações de estilo e conteúdo
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: isError ? Colors.red : Colors.green), // Define a cor do texto com base no tipo de mensagem
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Bordas arredondadas na parte superior
    ),
    duration: const Duration(seconds: 3), // Duração do SnackBar (3 segundos)
  );

  // Exibe o SnackBar usando o ScaffoldMessenger
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
