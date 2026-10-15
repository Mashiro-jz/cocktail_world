import 'package:flutter/material.dart';

class CoctailScreen extends StatefulWidget {
  final String coctailId;

  const CoctailScreen({super.key, required this.coctailId});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {

  void Future<void> 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cocktail Details')),
      body: Center(child: Text('Details for cocktail ID: ${widget.coctailId}')),
    );
  }
}
