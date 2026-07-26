import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _initialWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  
  String _gender = 'M';
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _initialWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      age: int.parse(_ageController.text),
      height: double.parse(_heightController.text),
      initialWeight: double.parse(_initialWeightController.text),
      currentWeight: double.parse(_initialWeightController.text),
      goalWeight: double.parse(_goalWeightController.text),
      gender: _gender,
      startDate: DateTime.now(),
      dailyCalorieGoal: _calculateCalories(),
    );

    await context.read<AppProvider>().initializeUserProfile(profile);

    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  double _calculateCalories() {
    final weight = double.parse(_initialWeightController.text);
    final height = double.parse(_heightController.text);
    final age = int.parse(_ageController.text);
    
    // Fórmula de Harris-Benedict para TMB
    double bmr;
    if (_gender == 'M') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
    
    // Déficit calórico del 20% para perder peso
    return (bmr * 1.55 * 0.8).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _buildStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildBodyMetricsStep();
      case 2:
        return _buildGoalStep();
      case 3:
        return _buildSummaryStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Información Personal',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Edad',
            prefixIcon: Icon(Icons.cake),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu edad';
            }
            if (int.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        const Text('Género', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Masculino'),
                value: 'M',
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value!),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Femenino'),
                value: 'F',
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value!),
              ),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _nextStep,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Continuar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyMetricsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Medidas Corporales',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Altura (cm)',
            prefixIcon: Icon(Icons.height),
            border: OutlineInputBorder(),
            suffixText: 'cm',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu altura';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _initialWeightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Peso Actual (kg)',
            prefixIcon: Icon(Icons.monitor_weight),
            border: OutlineInputBorder(),
            suffixText: 'kg',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu peso actual';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tu Objetivo',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _goalWeightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Peso Objetivo (kg)',
            prefixIcon: Icon(Icons.flag),
            border: OutlineInputBorder(),
            suffixText: 'kg',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu peso objetivo';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un número válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Colors.teal),
              const SizedBox(height: 8),
              Text(
                'Tu meta es perder ${double.tryParse(_initialWeightController.text) != null && double.tryParse(_goalWeightController.text) != null ? (double.parse(_initialWeightController.text) - double.parse(_goalWeightController.text)).toStringAsFixed(1) : '0'} kg',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextStep,
                icon: const Icon(Icons.check),
                label: const Text('Ver Resumen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    final calorieGoal = _calculateCalories();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Resumen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Nombre', _nameController.text),
              const Divider(),
              _buildSummaryRow('Edad', '${_ageController.text} años'),
              const Divider(),
              _buildSummaryRow('Altura', '${_heightController.text} cm'),
              const Divider(),
              _buildSummaryRow('Peso Inicial', '${_initialWeightController.text} kg'),
              const Divider(),
              _buildSummaryRow('Peso Objetivo', '${_goalWeightController.text} kg'),
              const Divider(),
              _buildSummaryRow('Calorías Diarias', '${calorieGoal.round()} kcal'),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.fitness_center),
                label: const Text('Comenzar Mi Viaje'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
