import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/application.dart';
import '../../providers/application_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final JobApplication application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  State<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  late JobApplication _application;
  final TextEditingController _notesController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _application = widget.application;
    _notesController.text = _application.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interviewScheduled:
        return 'Interview Scheduled';
      case ApplicationStatus.offerReceived:
        return 'Offer Received';
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

  void _saveNotes() async {
    final updatedApplication = _application.copyWith(
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    final success = await Provider.of<ApplicationProvider>(context, listen: false)
        .updateApplication(updatedApplication);

    if (success) {
      setState(() {
        _application = updatedApplication;
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update notes')),
      );
    }
  }

  void _updateStatus(ApplicationStatus status) async {
    final success = await Provider.of<ApplicationProvider>(context, listen: false)
        .updateApplicationStatus(_application.id, status);

    if (success) {
      setState(() {
        _application = _application.copyWith(status: status);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to ${_getStatusText(status)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ApplicationStatus.values.map((status) {
            return ListTile(
              title: Text(_getStatusText(status)),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(status),
                radius: 8,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _updateStatus(status);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _addInterview() {
    showDialog(
      context: context,
      builder: (context) => _AddInterviewDialog(
        onAdd: (interview) async {
          final success = await Provider.of<ApplicationProvider>(context, listen: false)
              .addInterview(_application.id, interview);

          if (success) {
            setState(() {
              _application = _application.copyWith(
                interviews: [..._application.interviews, interview],
                status: ApplicationStatus.interviewScheduled,
              );
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Interview added successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to add interview')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'status':
                  _showStatusUpdateDialog();
                  break;
                case 'interview':
                  _addInterview();
                  break;
                case 'delete':
                  _showDeleteDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'status',
                child: Row(
                  children: [
                    Icon(Icons.update),
                    SizedBox(width: 8),
                    Text('Update Status'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'interview',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Add Interview'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Application', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Application Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.business,
                            color: Colors.blue.shade600,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Job ID: ${_application.jobId}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Applied on ${DateFormat('MMM dd, yyyy').format(_application.dateApplied)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_application.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(_application.status),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(_application.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Interviews Section
            if (_application.interviews.isNotEmpty) ...[
              const Text(
                'Interviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._application.interviews.map((interview) => Card(
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.orange.shade600,
                  ),
                  title: Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(interview.scheduledDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (interview.location != null)
                        Text('Location: ${interview.location}'),
                      if (interview.interviewerName != null)
                        Text('Interviewer: ${interview.interviewerName}'),
                    ],
                  ),
                  trailing: interview.isCompleted
                      ? Icon(Icons.check_circle, color: Colors.green.shade600)
                      : null,
                ),
              )),
              const SizedBox(height: 16),
            ],
            
            // Notes Section
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Application Notes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                          child: Text(_isEditing ? 'Cancel' : 'Edit'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isEditing) ...[
                      CustomTextField(
                        controller: _notesController,
                        labelText: 'Notes',
                        hintText: 'Add your notes about this application...',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Save Notes',
                        onPressed: _saveNotes,
                      ),
                    ] else ...[
                      Text(
                        _application.notes?.isNotEmpty == true
                            ? _application.notes!
                            : 'No notes added yet.',
                        style: TextStyle(
                          fontSize: 14,
                          color: _application.notes?.isNotEmpty == true
                              ? Colors.grey.shade700
                              : Colors.grey.shade500,
                          fontStyle: _application.notes?.isNotEmpty == true
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text(
          'Are you sure you want to delete this application? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final success = await Provider.of<ApplicationProvider>(context, listen: false)
                  .deleteApplication(_application.id);

              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Application deleted successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete application')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddInterviewDialog extends StatefulWidget {
  final Function(Interview) onAdd;

  const _AddInterviewDialog({required this.onAdd});

  @override
  State<_AddInterviewDialog> createState() => _AddInterviewDialogState();
}

class _AddInterviewDialogState extends State<_AddInterviewDialog> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _interviewerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void dispose() {
    _locationController.dispose();
    _interviewerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _addInterview() {
    final scheduledDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final interview = Interview(
      id: 'int_${DateTime.now().millisecondsSinceEpoch}',
      scheduledDate: scheduledDate,
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      interviewerName: _interviewerController.text.isNotEmpty ? _interviewerController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    widget.onAdd(interview);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Interview'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Selection
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
              subtitle: const Text('Interview Date'),
              onTap: _selectDate,
            ),
            
            // Time Selection
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_selectedTime.format(context)),
              subtitle: const Text('Interview Time'),
              onTap: _selectTime,
            ),
            
            const SizedBox(height: 16),
            
            // Location
            CustomTextField(
              controller: _locationController,
              labelText: 'Location',
              hintText: 'e.g., Video call - Zoom, Office address',
            ),
            
            const SizedBox(height: 16),
            
            // Interviewer
            CustomTextField(
              controller: _interviewerController,
              labelText: 'Interviewer Name',
              hintText: 'e.g., John Smith',
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes',
              hintText: 'Additional notes about the interview',
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addInterview,
          child: const Text('Add Interview'),
        ),
      ],
    );
  }
}

