import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/application_provider.dart';
import '../../models/application.dart';
import '../../widgets/application_card.dart';
import '../../widgets/application_status_filter.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load applications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationProvider>(context, listen: false).loadApplications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  List<JobApplication> _getApplicationsByStatus(
    List<JobApplication> applications,
    ApplicationStatus status,
  ) {
    return applications.where((app) => app.status == status).toList()
      ..sort((a, b) => b.dateApplied.compareTo(a.dateApplied));
  }

  Widget _buildApplicationsList(List<JobApplication> applications) {
    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start applying to jobs to track your progress',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ApplicationCard(
            application: application,
            onTap: () {
              Navigator.of(context).pushNamed(
                '/application-detail',
                arguments: application,
              );
            },
            onStatusUpdate: (status) {
              Provider.of<ApplicationProvider>(context, listen: false)
                  .updateApplicationStatus(application.id, status);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Applied'),
            Tab(text: 'Interview'),
            Tab(text: 'Offer'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Consumer<ApplicationProvider>(
        builder: (context, applicationProvider, child) {
          if (applicationProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (applicationProvider.errorMessage != null) {
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
                    applicationProvider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      applicationProvider.loadApplications();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Applied
              RefreshIndicator(
                onRefresh: () => applicationProvider.loadApplications(),
                child: _buildApplicationsList(
                  _getApplicationsByStatus(
                    applicationProvider.applications,
                    ApplicationStatus.applied,
                  ),
                ),
              ),
              
              // Interview
              RefreshIndicator(
                onRefresh: () => applicationProvider.loadApplications(),
                child: _buildApplicationsList(
                  _getApplicationsByStatus(
                    applicationProvider.applications,
                    ApplicationStatus.interviewScheduled,
                  ),
                ),
              ),
              
              // Offer
              RefreshIndicator(
                onRefresh: () => applicationProvider.loadApplications(),
                child: _buildApplicationsList(
                  _getApplicationsByStatus(
                    applicationProvider.applications,
                    ApplicationStatus.offerReceived,
                  ),
                ),
              ),
              
              // Rejected
              RefreshIndicator(
                onRefresh: () => applicationProvider.loadApplications(),
                child: _buildApplicationsList(
                  _getApplicationsByStatus(
                    applicationProvider.applications,
                    ApplicationStatus.rejected,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/job-search');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

