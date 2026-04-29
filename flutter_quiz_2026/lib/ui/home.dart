import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_2026/root/pallet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> produtos = [];
  int indice = 0;

  ValueChanged<dynamic>? get onChanged => null;

  @override
  void initState() {
    super.initState();
    carrearMockupJSON();
  }

  Future<void> carrearMockupJSON() async {
    String dados = await rootBundle.loadString('assets/mockup/produtos.json');
    setState(() {
      produtos = json.decode(dados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Papelaria produtos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.p1,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.p2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<dynamic>(
                borderRadius: BorderRadius.circular(8),
                isExpanded: true,
                underline: const SizedBox.shrink(),
                value: produtos.isNotEmpty ? produtos[indice] : null,
                items: produtos
                    .map(
                      (produto) => DropdownMenuItem<dynamic>(
                        value: produto,
                        child: Text(produto['nome']),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    indice = produtos.indexOf(value);
                  });
                },
              ),
            ),
            Text(
              produtos.isNotEmpty
                  ? produtos[indice]['nome']
                  : "Nome do produto",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.p2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  spacing: 10,
                  children: [
                    produtos.isNotEmpty
                        ? Image.network(
                            produtos[indice]['img'],
                            width: 200,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object exception,
                                  StackTrace? stackTrace,
                                ) =>
                                    Image.asset('assets/icone.png', width: 200),
                          )
                        : Image.asset(
                            'assets/icone.png',
                            height: 200,
                            width: 200,
                          ),
                    Text(
                      produtos.isNotEmpty
                          ? produtos[indice]['descricao']
                          : "Descrição do produto",
                    ),
                    Text(
                      produtos.isNotEmpty
                          ? "R\$ ${produtos[indice]['preco'].toStringAsFixed(2).replaceAll('.', ',')}"
                          : "R\$ 0.00",
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: indice > 0
                      ? () => setState(() {
                          indice--;
                        })
                      : null,
                  child: Text("Anterior"),
                ),
                ElevatedButton(
                  onPressed: indice < produtos.length - 1
                      ? () => setState(() {
                          indice++;
                        })
                      : null,
                  child: Text("Proximo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
