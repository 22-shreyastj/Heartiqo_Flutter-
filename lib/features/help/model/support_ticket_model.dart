class SupportTicketModel {
  final String id;
  final String subject;
  final String category;
  final String description;
  final String status;
  final String createdAt;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.category,
    required this.description,
    this.status = 'Open',
    required this.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'Open',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'category': category,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.category = 'General',
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
    };
  }
}
