import 'package:flutter/material.dart';

class CardReminderWidget extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const CardReminderWidget({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.blue,
            onPressed: onEdit,
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
