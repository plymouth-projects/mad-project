import 'dart:async';
import 'package:flutter/material.dart';
import '../carousel_indicator.dart';
import '../job_card.dart';
import '../../models/job_model.dart';
import '../../services/job_service.dart';
import '../../utils/date_utils.dart' as app_date_utils;

class JobCarousel extends StatefulWidget {
  const JobCarousel({super.key});

  @override
  State<JobCarousel> createState() => _JobCarouselState();
}

class _JobCarouselState extends State<JobCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _autoplayTimer;
  late List<Job> jobs;
  final JobService _jobService = JobService();

  @override
  void initState() {
    super.initState();
    jobs = _jobService.getAllJobObjects();
    
    _pageController = PageController(
      viewportFraction: 0.92,
      initialPage: jobs.length * 1000,
    );
    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'LATEST JOB OPPORTUNITIES',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 320,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page % jobs.length;
              });
            },
            itemBuilder: (context, index) {
              final jobIndex = index % jobs.length;
              return _buildJobCard(jobs[jobIndex], index);
            },
          ),
        ),
        const SizedBox(height: 15),
        CarouselIndicator(
          itemCount: jobs.length,
          currentPage: _currentPage,
        ),
      ],
    );
  }

  Widget _buildJobCard(Job job, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double scale = 1.0;
        if (_pageController.position.haveDimensions) {
          double pageOffset = (_pageController.page ?? 0) - index;
          scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.5, 1.0);
        }
        // Convert the dynamic map to a string map
        Map<String, String> stringJob = {};
        job.toMap().forEach((key, value) {
          stringJob[key] = value?.toString() ?? '';
        });
        
        return JobCard(
          job: stringJob,
          scale: scale,
          calculateDaysLeft: (String? deadline) => app_date_utils.DateUtils.calculateDaysLeft(deadline),
          onApplyPressed: () {
            // Handle the apply button press here
            Map<String, String> jobMap = {};
            job.toMap().forEach((key, value) {
              jobMap[key] = value?.toString() ?? '';
            });
            _jobService.applyForJob(jobMap, {});
          },
        );
      },
    );
  }
}
