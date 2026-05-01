import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../root/pallet.dart';
import 'resultado.dart';

class Home extends StatefulWidget {
  final String nomeParticipante;
  const Home({super.key, required this.nomeParticipante});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> perguntas = [];
  int indicePergunta = 0;
  int? respostaSelecionada;
  bool respondido = false;
  int acertos = 0;

  @override
  void initState() {
    super.initState();
    _carregarPerguntas();
  }

  Future<void> _carregarPerguntas() async {
    final dados = await rootBundle.loadString('assets/mockup/questionario.json');
    setState(() => perguntas = json.decode(dados));
  }

  void _responder() {
    if (respostaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma alternativa!")),
      );
      return;
    }
    final correta = perguntas[indicePergunta]['correta'] as int;
    setState(() {
      respondido = true;
      if (respostaSelecionada == correta) acertos++;
    });
  }

  void _proximaPergunta() {
    if (indicePergunta < perguntas.length - 1) {
      setState(() {
        indicePergunta++;
        respostaSelecionada = null;
        respondido = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Resultado(
            nomeParticipante: widget.nomeParticipante,
            acertos: acertos,
            total: perguntas.length,
          ),
        ),
      );
    }
  }

  Color _corAlternativa(int index) {
    if (!respondido) return Colors.transparent;
    final correta = perguntas[indicePergunta]['correta'] as int;
    if (index == correta) return AppColors.acerto.withOpacity(0.2);
    if (index == respostaSelecionada) return AppColors.erro.withOpacity(0.2);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (perguntas.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pergunta = perguntas[indicePergunta];
    final respostas = pergunta['respostas'] as List<dynamic>;
    final correta = pergunta['correta'] as int;
    final total = perguntas.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(pergunta['tema'] ?? "Quiz Flutter Dev"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              "Questão nº ${indicePergunta + 1}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.p4,
              ),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                pergunta['ilustracao'],
                height: 90,
                width: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 60, color: AppColors.p2),
              ),
            ),

            Text(
              pergunta['pergunta'],
              style: const TextStyle(fontSize: 15, color: AppColors.p4),
              textAlign: TextAlign.center,
            ),

            Column(
              children: List.generate(respostas.length, (i) {
                final numero = i + 1;
                return Container(
                  color: _corAlternativa(numero),
                  child: RadioListTile<int>(
                    value: numero,
                    groupValue: respostaSelecionada,
                    onChanged: respondido
                        ? null
                        : (val) => setState(() => respostaSelecionada = val),
                    title: Text(
                      respostas[i].toString(),
                      style: const TextStyle(color: AppColors.p4),
                    ),
                    activeColor: AppColors.p3,
                    secondary: respondido
                        ? (numero == correta
                            ? const Icon(Icons.check_circle, color: AppColors.acerto)
                            : (numero == respostaSelecionada
                                ? const Icon(Icons.cancel, color: AppColors.erro)
                                : null))
                        : null,
                  ),
                );
              }),
            ),

            const Spacer(),

            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: respondido ? null : _responder,
                  child: const Text("Responder"),
                ),
                ElevatedButton(
                  onPressed: respondido ? _proximaPergunta : null,
                  child: Text(
                    indicePergunta < total - 1 ? "Próxima questão" : "Ver resultado",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}