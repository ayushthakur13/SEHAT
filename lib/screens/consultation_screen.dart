import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultationScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const ConsultationScreen({super.key, this.patient});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _observationsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedPatient = '';
  List<String> _selectedTests = [];
  List<Map<String, dynamic>> _prescribedMedicines = [];
  
  final List<String> _availableTests = [
    'Blood Test',
    'X-Ray',
    'ECG',
    'Ultrasound',
    'CT Scan',
    'MRI',
    'Urine Test',
    'Stool Test',
  ];

  final List<Map<String, dynamic>> _availableMedicines = [
    {'name': 'Paracetamol', 'dosage': '500mg', 'stock': 100},
    {'name': 'Ibuprofen', 'dosage': '400mg', 'stock': 50},
    {'name': 'Amoxicillin', 'dosage': '250mg', 'stock': 75},
    {'name': 'Lisinopril', 'dosage': '10mg', 'stock': 30},
    {'name': 'Metformin', 'dosage': '500mg', 'stock': 60},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation & Case Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConsultation,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.patient != null)
                        _buildPatientInfo(widget.patient!)
                      else
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Patient',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          value: _selectedPatient.isEmpty ? null : _selectedPatient,
                          items: const [
                            DropdownMenuItem(value: 'P001', child: Text('John Doe (P001)')),
                            DropdownMenuItem(value: 'P002', child: Text('Jane Smith (P002)')),
                            DropdownMenuItem(value: 'P003', child: Text('Mike Johnson (P003)')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPatient = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a patient';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Symptoms
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Symptoms',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _symptomsController,
                        decoration: const InputDecoration(
                          labelText: 'Patient reported symptoms',
                          border: OutlineInputBorder(),
                          hintText: 'Describe the symptoms reported by the patient...',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter symptoms';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Observations
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Clinical Observations',
              //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         TextFormField(
              //           controller: _observationsController,
              //           decoration: const InputDecoration(
              //             labelText: 'Doctor observations',
              //             border: OutlineInputBorder(),
              //             hintText: 'Record your clinical observations...',
              //           ),
              //           maxLines: 3,
              //           validator: (value) {
              //             if (value == null || value.isEmpty) {
              //               return 'Please enter clinical observations';
              //             }
              //             return null;
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Diagnosis
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diagnosis',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _diagnosisController,
                        decoration: const InputDecoration(
                          labelText: 'Diagnosis',
                          border: OutlineInputBorder(),
                          hintText: 'Enter the diagnosis...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter diagnosis';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lab Test Requests
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Lab Test Requests',
              //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         Wrap(
              //           spacing: 8,
              //           runSpacing: 8,
              //           children: _availableTests.map((test) {
              //             final isSelected = _selectedTests.contains(test);
              //             return FilterChip(
              //               label: Text(test),
              //               selected: isSelected,
              //               onSelected: (selected) {
              //                 setState(() {
              //                   if (selected) {
              //                     _selectedTests.add(test);
              //                   } else {
              //                     _selectedTests.remove(test);
              //                   }
              //                 });
              //               },
              //               selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
              //               checkmarkColor: const Color(0xFF1976D2),
              //             );
              //           }).toList(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Prescribe Medicines
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Prescribe Medicines',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _showMedicineDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Empty state
                      if (_prescribedMedicines.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('No medicines prescribed yet'),
                          ),
                        )
                      else
                        Column(
                          children: _prescribedMedicines
                              .map((medicine) => _buildMedicineCard(medicine))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),


              // Additional Notes
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Notes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Additional notes',
                          border: OutlineInputBorder(),
                          hintText: 'Any additional notes or recommendations...',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _generatePrescription,
                      icon: const Icon(Icons.description),
                      label: const Text('Generate and save Prescription'),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   child: ElevatedButton.icon(
                  //     onPressed: _saveConsultation,
                  //     icon: const Icon(Icons.save),
                  //     label: const Text('Save Consultation'),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(Map<String, dynamic> patient) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1976D2),
            child: Text(
              patient['name'][0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'ID: ${patient['id']} • ${patient['age']} years • ${patient['gender']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> medicine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.medication, color: Color(0xFF1976D2)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${medicine['dosage']} • ${medicine['frequency']} • ${medicine['duration']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _prescribedMedicines.remove(medicine);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicineDialog() {
    showDialog(
      context: context,
      builder: (context) => MedicineDialog(
        availableMedicines: _availableMedicines,
        onMedicineAdded: (medicine) {
          setState(() {
            _prescribedMedicines.add(medicine);
          });
        },
      ),
    );
  }

  void _generatePrescription() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Prescription Generated'),
          content: const Text('Digital prescription PDF has been generated and can be sent to patient via SMS/WhatsApp.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _saveConsultation() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Consultation Saved'),
          content: const Text('Consultation notes have been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _observationsController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class MedicineDialog extends StatefulWidget {
  final List<Map<String, dynamic>> availableMedicines;
  final Function(Map<String, dynamic>) onMedicineAdded;

  const MedicineDialog({
    super.key,
    required this.availableMedicines,
    required this.onMedicineAdded,
  });

  @override
  State<MedicineDialog> createState() => _MedicineDialogState();
}

class _MedicineDialogState extends State<MedicineDialog> {
  String _selectedMedicine = '';
  String _frequency = 'Once daily';
  String _duration = '7 days';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'As needed',
  ];

  final List<String> _durations = [
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
    '30 days',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Medicine'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Medicine',
                border: OutlineInputBorder(),
              ),
              value: _selectedMedicine.isEmpty ? null : _selectedMedicine,
              items: widget.availableMedicines.map((medicine) {
                return DropdownMenuItem<String>(
                  value: medicine['name'],
                  child: Text('${medicine['name']} (${medicine['dosage']}) - Stock: ${medicine['stock']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMedicine = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              value: _frequency,
              items: _frequencies.map((freq) {
                return DropdownMenuItem<String>(
                  value: freq,
                  child: Text(freq),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value ?? 'Once daily';
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(),
              ),
              value: _duration,
              items: _durations.map((dur) {
                return DropdownMenuItem<String>(
                  value: dur,
                  child: Text(dur),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _duration = value ?? '7 days';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedMedicine.isNotEmpty ? _addMedicine : null,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addMedicine() {
    final selectedMed = widget.availableMedicines.firstWhere(
      (med) => med['name'] == _selectedMedicine,
    );

    final medicine = {
      'name': _selectedMedicine,
      'dosage': selectedMed['dosage'],
      'frequency': _frequency,
      'duration': _duration,
      'notes': _notesController.text,
    };

    widget.onMedicineAdded(medicine);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
