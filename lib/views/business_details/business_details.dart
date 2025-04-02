import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';
import '../../config/app_colors.dart';

class BusinessDetails extends StatefulWidget {
  final Map<String, dynamic> company;

  const BusinessDetails({super.key, required this.company});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 180 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 180 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.businessHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.businessHub),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: SafeArea(
            child: Stack(
              children: [
                _buildContent(),
                _buildAppBar(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showApplyDialog(),
        backgroundColor: AppColors.tealDark,
        label: const Text('Apply to Jobs'),
        icon: const Icon(Icons.work),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: kToolbarHeight,
        color: AppColors.primaryBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8), // Space between icon and title
            Expanded(
              child: Text(
                widget.company['name'] ?? 'Company Details',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline, color: AppColors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Space for the app bar
                _buildCompanyCard(),
                const SizedBox(height: 24),
                _buildCompanyStats(),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 24),
                _buildOpenJobs(),
                const SizedBox(height: 24),
                _buildLocation(),
                const SizedBox(height: 24),
                _buildBenefits(),
                const SizedBox(height: 24),
                _buildCompanyPeople(),
                const SizedBox(height: 100), // Extra space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompanyCard() {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.company['logo'] ?? 'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.business, color: AppColors.primaryBlue[700], size: 40);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.company['name'] ?? 'Unknown Company',
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.primaryBlue.withOpacity(0.7),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.company['location'] ?? 'Location not specified',
                              style: TextStyle(
                                color: AppColors.primaryBlue.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              Icons.business,
                              widget.company['industry'] ?? 'Various',
                              AppColors.tealDark,
                            ),
                            _buildInfoChip(
                              Icons.people,
                              '${widget.company['employees'] ?? 'N/A'} Employees',
                              AppColors.tealDark,
                            ),
                            _buildInfoChip(
                              Icons.calendar_today,
                              'Since ${widget.company['founded'] ?? 'N/A'}',
                              AppColors.tealDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyStats() {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Stats',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              'Industry',
              widget.company['industry'] ?? 'Various',
              Icons.category,
            ),
            Divider(color: AppColors.primaryBlue.withOpacity(0.24)),
            _buildStatItem(
              'Founded',
              widget.company['founded'] ?? 'N/A',
              Icons.calendar_today,
            ),
            Divider(color: AppColors.primaryBlue.withOpacity(0.24)),
            _buildStatItem(
              'Size',
              '${widget.company['employees'] ?? 'N/A'} Employees',
              Icons.people,
            ),
            Divider(color: AppColors.primaryBlue.withOpacity(0.24)),
            _buildStatItem(
              'Website',
              widget.company['website'] ?? 'No website',
              Icons.language,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue.withOpacity(0.7), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primaryBlue.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Company',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.company['description'] ?? 'No description available',
              style: TextStyle(
                color: AppColors.primaryBlue.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenJobs() {
    List<dynamic> jobs = widget.company['jobs'] ?? [];
    
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Open Positions',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${jobs.length} Jobs',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...jobs.map((job) => _buildJobCard(job.toString())),
            if (jobs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'No open positions at this time',
                  style: TextStyle(color: AppColors.primaryBlue.withOpacity(0.7)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.primaryBlue.withOpacity(0.7),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.company['location'] ?? 'Location not specified',
                    style: TextStyle(
                      color: AppColors.primaryBlue.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 50,
                      color: AppColors.primaryBlue.withOpacity(0.5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.company['location'] ?? 'Location not specified',
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Tap to view map',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    List<Map<String, dynamic>> benefits = [
      {'icon': Icons.health_and_safety, 'title': 'Health Insurance'},
      {'icon': Icons.watch_later, 'title': 'Flexible Hours'},
      {'icon': Icons.card_giftcard, 'title': 'Bonuses'},
      {'icon': Icons.home, 'title': 'Remote Work'},
      {'icon': Icons.star, 'title': 'Career Growth'},
      {'icon': Icons.laptop_mac, 'title': 'Equipment'},
    ];

    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Benefits & Perks',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: benefits.length,
              itemBuilder: (context, index) {
                final benefit = benefits[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        benefit['icon'],
                        color: AppColors.primaryBlue,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        benefit['title'],
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyPeople() {
    return Card(
      color: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'People at Company',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                          backgroundImage: AssetImage(
                            'assets/images/avatar${index + 1}.png',
                          ),
                          onBackgroundImageError: (_, __) {},
                          child: Icon(
                            Icons.person,
                            color: AppColors.primaryBlue.withOpacity(0.7),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Team Member',
                          style: TextStyle(
                            color: AppColors.primaryBlue.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  void _showApplyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply at ${widget.company['name']}?'),
        content: const Text('Do you want to view all available positions at this company?'),
        backgroundColor: AppColors.primaryBlue[700],
        titleTextStyle: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: const TextStyle(color: AppColors.white, fontSize: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.white.withOpacity(0.7))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigating to company jobs...'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
              // Add navigation to job listings for this company
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
            ),
            child: const Text('View Jobs'),
          ),
        ],
      ),
    );
  }
}
