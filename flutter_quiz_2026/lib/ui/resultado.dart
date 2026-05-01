import 'package:flutter/material.dart';
import '../root/pallet.dart';

class Resultado extends StatelessWidget {
  final String nomeParticipante;
  final int acertos;
  final int total;

  const Resultado({
    super.key,
    required this.nomeParticipante,
    required this.acertos,
    required this.total,
  });

  String get _mensagem {
    final percent = acertos / total;
    if (percent == 1.0) return "Perfeito! 🏆";
    if (percent >= 0.7) return "Muito bem! 🎉";
    if (percent >= 0.5) return "Quase lá! 💪";
    return "Não desista! Revise o conteúdo e tente de novo!";
  }

  Color get _corResultado {
    final percent = acertos / total;
    if (percent >= 0.7) return AppColors.acerto;
    if (percent >= 0.5) return Colors.orange;
    return AppColors.erro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 24,
            children: [
              Icon(
                acertos / total >= 0.7 ? Icons.emoji_events : Icons.school,
                size: 100,
                color: _corResultado,
              ),
              Text(
                "Parabéns, $nomeParticipante!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.p4,
                ),
                textAlign: TextAlign.center,
              ),
              Column(
                spacing: 8,
                children: [
                  Text(
                    "$acertos / $total",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _corResultado,
                    ),
                  ),
                  const Text(
                    "acertos",
                    style: TextStyle(fontSize: 16, color: AppColors.p4),
                  ),
                ],
              ),
              Text(
                _mensagem,
                style: const TextStyle(fontSize: 16, color: AppColors.p3),
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.replay),
                label: const Text("Jogar novamente"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}