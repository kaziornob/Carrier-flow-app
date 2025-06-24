import 'package:flutter/material.dart';
import '../models/application.dart';

class ApplicationStatusFilter extends StatelessWidget {
  final ApplicationStatus? selectedStatus;
  final Function(ApplicationStatus?) onStatusChanged;

  const ApplicationStatusFilter({
    super.key,
    this.selectedStatus,
    required this.onStatusChanged,
  });

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interviewScheduled:
        return 'Interview';
      case ApplicationStatus.offerReceived:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.interviewScheduled:
        return Colors.orange;
      case ApplicationStatus.offerReceived:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // All filter
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedStatus == null,
              onSelected: (selected) {
                onStatusChanged(null);
              },
            ),
          ),
          
          // Status filters
          ...ApplicationStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getStatusText(status)),
                selected: selectedStatus == status,
                selectedColor: _getStatusColor(status).withOpacity(0.2),
                onSelected: (selected) {
                  onStatusChanged(selected ? status : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

