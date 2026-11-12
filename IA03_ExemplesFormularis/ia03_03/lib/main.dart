import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M0489 - Apps - Form (C)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String title = 'Albert Martínez Solsona';

  // Clau per poder accedir al formulari des del botó d'enviar
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        // Deixo espai a baix perquè el botó flotant no tapi l'últim camp
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              //-------------------------------------------------
              // 1. Choice Chips: només se'n pot triar un
              FormBuilderChoiceChips<String>(
                name: 'choice_chips',
                decoration: fieldDecoration('Choice Chips'),
                alignment: WrapAlignment.center,
                spacing: 10,
                options: const [
                  FormBuilderChipOption(
                    value: 'Flutter',
                    avatar: FlutterLogo(),
                  ),
                  FormBuilderChipOption(
                    value: 'Android',
                    avatar: Icon(Icons.android),
                  ),
                  FormBuilderChipOption(value: 'Chrome OS'),
                ],
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),
              //-------------------------------------------------
              // 2. Switch: valor true o false
              FormBuilderSwitch(
                name: 'switch',
                decoration: fieldDecoration('Switch'),
                title: const Text('This is a switch'),
                initialValue: false,
                onChanged: (bool? value) {
                  debugPrint(value.toString());
                },
              ),
              //-------------------------------------------------
              // 3. Text Field: obligatori i amb un màxim de 15 caràcters
              FormBuilderTextField(
                name: 'text_field',
                decoration: fieldDecoration(
                  'Text Field',
                  icon: Icons.text_format,
                ),
                maxLength: 15,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Aquest camp no pot estar buit';
                  }
                  return null;
                },
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),
              //-------------------------------------------------
              // 4. Dropdown: desplegable amb tres opcions
              FormBuilderDropdown<String>(
                name: 'dropdown',
                decoration: fieldDecoration('Dropdown Field'),
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),
              //-------------------------------------------------
              // 5. Radio Group: quatre opcions en vertical
              FormBuilderRadioGroup<String>(
                name: 'radio_group',
                decoration: fieldDecoration('Radio Group Model'),
                orientation: OptionsOrientation.vertical,
                options: const [
                  FormBuilderFieldOption(value: 'Option 1'),
                  FormBuilderFieldOption(value: 'Option 2'),
                  FormBuilderFieldOption(value: 'Option 3'),
                  FormBuilderFieldOption(value: 'Option 4'),
                ],
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Enviar',
        child: const Icon(Icons.upload),
        onPressed: () {
          // saveAndValidate guarda els valors i comprova els validadors
          if (_formKey.currentState!.saveAndValidate()) {
            alertDialog(context, _formKey.currentState!.value);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Revisa el camp de text')),
            );
          }
        },
      ),
    );
  }
}

// Decoració que comparteixen tots els camps: vora arrodonida i el nom
// del camp a sobre. La icona és opcional.
InputDecoration fieldDecoration(String label, {IconData? icon}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: icon != null ? Icon(icon) : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}

// Mostra els valors del formulari, un per línia, en un AlertDialog
void alertDialog(BuildContext context, Map<String, dynamic> values) {
  String contentText = '';
  values.forEach((name, value) {
    contentText += '$name: $value\n';
  });

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Submission Completed'),
      icon: const Icon(Icons.check_circle),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Tancar'),
          child: const Text('Tancar'),
        ),
      ],
    ),
  );
}
