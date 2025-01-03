import 'package:custom_input_formatter/custom_input_formatter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Input Formatter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Custom Input Formatter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // Pour un montant
    final amountFormatter = CustomNumberInputFormatter(
      formatType: FormatType.amount,
      separator: '.',
      groupBy: 3,
    );

    // Pour un numéro de téléphone
    final phoneFormatter = CustomNumberInputFormatter(
      formatType: FormatType.phoneNumber,
      separator: ':',
      groupBy: 2,
      maxLength: 10,
    );

    // Pour un nombre
    final numberFormatter = CustomNumberInputFormatter(
      formatType: FormatType.number,
      separator: ' ',
      groupBy: 3,
      maxLength: 10,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            inputFormatters: [amountFormatter],
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
  }
}
