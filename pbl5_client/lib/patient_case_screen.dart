import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientCaseScreen extends StatefulWidget {
  @override
  _PatientCaseScreenState createState() => _PatientCaseScreenState();
}

class _PatientCaseScreenState extends State<PatientCaseScreen> {
  // Controladores de texto para os campos do formulário
  final _dniController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _identificationController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedSex;
  String _message = '';

  final List<String> _sexOptions = ['MALE', 'FEMALE'];

  Future<void> createCase() async {
    final url = Uri.parse('http://10.0.2.2:8080/case/createCase');

    // Preparando o corpo da requisição
    final body = jsonEncode({
      'dni': _dniController.text,
      'sex': _selectedSex,
      'age': int.tryParse(_ageController.text),
      'symptoms': _symptomsController.text,
      'identification': _identificationController.text,
      'email': _emailController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Caso criado com sucesso: ${response.body}';
        });
      } else {
        setState(() {
          _message = 'Erro ao criar caso: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Erro de conexão com o servidor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Casos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _dniController,
                decoration: InputDecoration(labelText: 'DNI'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedSex,
                items: _sexOptions
                    .map((sex) => DropdownMenuItem(
                          value: sex,
                          child: Text(sex),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSex = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _symptomsController,
                decoration: InputDecoration(labelText: 'Sintomas'),
              ),
              TextField(
                controller: _identificationController,
                decoration: InputDecoration(labelText: 'Identificação'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_dniController.text.isNotEmpty &&
                      _selectedSex != null &&
                      _ageController.text.isNotEmpty &&
                      _symptomsController.text.isNotEmpty &&
                      _identificationController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty) {
                    createCase();
                  } else {
                    setState(() {
                      _message = 'Por favor, preencha todos os campos.';
                    });
                  }
                },
                child: Text('Criar Caso'),
              ),
              SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
