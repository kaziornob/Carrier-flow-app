import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../models/job.dart';
import '../widgets/custom_button.dart';

class JobFiltersBottomSheet extends StatefulWidget {
  const JobFiltersBottomSheet({super.key});

  @override
  State<JobFiltersBottomSheet> createState() => _JobFiltersBottomSheetState();
}

class _JobFiltersBottomSheetState extends State<JobFiltersBottomSheet> {
  late JobFilters _filters;
  final TextEditingController _locationController = TextEditingController();
  RangeValues _salaryRange = const RangeValues(30000, 150000);

  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    _filters = JobFilters(
      jobType: jobProvider.currentFilters.jobType,
      locationType: jobProvider.currentFilters.locationType,
      experienceLevel: jobProvider.currentFilters.experienceLevel,
      location: jobProvider.currentFilters.location,
      minSalary: jobProvider.currentFilters.minSalary,
      maxSalary: jobProvider.currentFilters.maxSalary,
    );
    
    _locationController.text = _filters.location ?? '';
    if (_filters.minSalary != null && _filters.maxSalary != null) {
      _salaryRange = RangeValues(_filters.minSalary!, _filters.maxSalary!);
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final updatedFilters = _filters.copyWith(
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
      minSalary: _salaryRange.start,
      maxSalary: _salaryRange.end,
    );
    
    Provider.of<JobProvider>(context, listen: false).updateFilters(updatedFilters);
    Provider.of<JobProvider>(context, listen: false).searchJobs(
      filters: updatedFilters,
      refresh: true,
    );
    
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _filters = JobFilters();
      _locationController.clear();
      _salaryRange = const RangeValues(30000, 150000);
    });
  }

  String _getJobTypeText(JobType jobType) {
    switch (jobType) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
      case JobType.freelance:
        return 'Freelance';
    }
  }

  String _getLocationTypeText(LocationType locationType) {
    switch (locationType) {
      case LocationType.remote:
        return 'Remote';
      case LocationType.hybrid:
        return 'Hybrid';
      case LocationType.onSite:
        return 'On-site';
    }
  }

  String _getExperienceLevelText(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.mid:
        return 'Mid Level';
      case ExperienceLevel.senior:
        return 'Senior Level';
      case ExperienceLevel.executive:
        return 'Executive';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: Colors.grey.shade200),
          
          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Type
                  const Text(
                    'Job Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: JobType.values.map((type) {
                      final isSelected = _filters.jobType == type;
                      return FilterChip(
                        label: Text(_getJobTypeText(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters = _filters.copyWith(
                              jobType: selected ? type : null,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location Type
                  const Text(
                    'Work Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LocationType.values.map((type) {
                      final isSelected = _filters.locationType == type;
                      return FilterChip(
                        label: Text(_getLocationTypeText(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters = _filters.copyWith(
                              locationType: selected ? type : null,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Experience Level
                  const Text(
                    'Experience Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ExperienceLevel.values.map((level) {
                      final isSelected = _filters.experienceLevel == level;
                      return FilterChip(
                        label: Text(_getExperienceLevelText(level)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters = _filters.copyWith(
                              experienceLevel: selected ? level : null,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter city, state, or country',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Salary Range
                  const Text(
                    'Salary Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${_salaryRange.start.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} - \$${_salaryRange.end.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  RangeSlider(
                    values: _salaryRange,
                    min: 20000,
                    max: 200000,
                    divisions: 18,
                    onChanged: (values) {
                      setState(() {
                        _salaryRange = values;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: CustomButton(
              text: 'Apply Filters',
              onPressed: _applyFilters,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

