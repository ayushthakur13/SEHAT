class Medicine {
  final int id;
  final String name;
  final String? brand;
  final String? category;
  final String? composition;
  final String? strength;
  final String? form;
  final String? description;
  final bool? requiresPrescription;
  final String? dosage;
  final String? frequency;
  final String? duration;
  final String? instructions;

  Medicine({
    required this.id,
    required this.name,
    this.brand,
    this.category,
    this.composition,
    this.strength,
    this.form,
    this.description,
    this.requiresPrescription,
    this.dosage,
    this.frequency,
    this.duration,
    this.instructions,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] ?? json['medicineId'] ?? 0,
      name: json['name'] ?? '',
      brand: json['brand'],
      category: json['category'],
      composition: json['composition'],
      strength: json['strength'],
      form: json['form'],
      description: json['description'],
      requiresPrescription: json['requiresPrescription'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'composition': composition,
      'strength': strength,
      'form': form,
      'description': description,
      'requiresPrescription': requiresPrescription,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? brand,
    String? category,
    String? composition,
    String? strength,
    String? form,
    String? description,
    bool? requiresPrescription,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      composition: composition ?? this.composition,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      description: description ?? this.description,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }
}
