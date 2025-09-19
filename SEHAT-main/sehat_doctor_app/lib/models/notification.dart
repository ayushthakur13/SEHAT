class AppNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final Map<String, String>? titleTranslations;
  final String priority;
  final String language;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? actionData;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.titleTranslations,
    required this.priority,
    required this.language,
    required this.isRead,
    this.actionUrl,
    this.actionData,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      titleTranslations: json['titleTranslations'] != null
          ? Map<String, String>.from(json['titleTranslations'])
          : null,
      priority: json['priority'] ?? 'low',
      language: json['language'] ?? 'english',
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
      actionData: json['actionData'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'titleTranslations': titleTranslations,
      'priority': priority,
      'language': language,
      'isRead': isRead,
      'actionUrl': actionUrl,
      'actionData': actionData,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  AppNotification copyWith({
    int? id,
    String? type,
    String? title,
    String? message,
    Map<String, String>? titleTranslations,
    String? priority,
    String? language,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? actionData,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      titleTranslations: titleTranslations ?? this.titleTranslations,
      priority: priority ?? this.priority,
      language: language ?? this.language,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      actionData: actionData ?? this.actionData,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}

class HealthRecord {
  final int id;
  final int patientId;
  final int? doctorId;
  final String recordType;
  final String title;
  final String? description;
  final DateTime recordDate;
  final Map<String, dynamic>? data;
  final String? notes;
  final String severity;
  final DateTime createdAt;
  final DateTime? updatedAt;

  HealthRecord({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.recordType,
    required this.title,
    this.description,
    required this.recordDate,
    this.data,
    this.notes,
    required this.severity,
    required this.createdAt,
    this.updatedAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'] ?? 0,
      patientId: json['patientId'] ?? 0,
      doctorId: json['doctorId'],
      recordType: json['recordType'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      recordDate: DateTime.parse(json['recordDate'] ?? DateTime.now().toIso8601String()),
      data: json['data'],
      notes: json['notes'],
      severity: json['severity'] ?? 'low',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'recordType': recordType,
      'title': title,
      'description': description,
      'recordDate': recordDate.toIso8601String(),
      'data': data,
      'notes': notes,
      'severity': severity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
