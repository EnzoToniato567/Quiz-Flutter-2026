import 'package:flutter/material.dart';
import '../root/pallet.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _iniciar() {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite seu nome para continuar!")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Home(nomeParticipante: nome)),
    ).then((_) => _nomeController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Dev")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 24,
            children: [
              const Icon(Icons.quiz, size: 80, color: AppColors.p3),
              const Text(
                "Bem-vindo ao Quiz!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.p4,
                ),
              ),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  hintText: "Digite seu nome",
                  prefixIcon: Icon(Icons.person, color: AppColors.p3),
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _iniciar,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Iniciar Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}