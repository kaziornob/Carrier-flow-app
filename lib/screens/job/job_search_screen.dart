import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../models/job.dart';
import '../../widgets/job_card.dart';
import '../../widgets/job_search_bar.dart';
import '../../widgets/job_filters_bottom_sheet.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial jobs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).searchJobs(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<JobProvider>(context, listen: false).loadMoreJobs();
    }
  }

  void _onSearch(String keyword) {
    Provider.of<JobProvider>(context, listen: false).searchJobs(
      keyword: keyword.isNotEmpty ? keyword : null,
      refresh: true,
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const JobFiltersBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: JobSearchBar(
                    controller: _searchController,
                    onSearch: _onSearch,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.tune),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          
          // Job List
          Expanded(
            child: Consumer<JobProvider>(
              builder: (context, jobProvider, child) {
                if (jobProvider.isLoading && jobProvider.jobs.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (jobProvider.errorMessage != null && jobProvider.jobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          jobProvider.errorMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            jobProvider.searchJobs(refresh: true);
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (jobProvider.jobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No jobs found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => jobProvider.searchJobs(
                    keyword: jobProvider.currentKeyword.isNotEmpty 
                        ? jobProvider.currentKeyword 
                        : null,
                    refresh: true,
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: jobProvider.jobs.length + 
                        (jobProvider.hasMoreJobs ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == jobProvider.jobs.length) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: jobProvider.isLoadingMore
                              ? const CircularProgressIndicator()
                              : const SizedBox.shrink(),
                        );
                      }

                      final job = jobProvider.jobs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: JobCard(
                          job: job,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/job-detail',
                              arguments: job,
                            );
                          },
                          onSave: () {
                            jobProvider.toggleSaveJob(job);
                          },
                          isSaved: jobProvider.isJobSaved(job.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

