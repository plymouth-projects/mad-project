import 'package:flutter/material.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/home/footer.dart';

class HubLayout extends StatelessWidget {
  final String title;
  final String currentRoute;
  final int resultCount;
  final Widget itemList;
  final VoidCallback onFilterPressed;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const HubLayout({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.resultCount,
    required this.itemList,
    required this.onFilterPressed,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: currentRoute),
      drawer: AppNavDrawer(currentRoute: currentRoute),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: _buildContentArea(),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildResultCount(),
          const SizedBox(height: 16),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold
            ),
          ),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildResultCount() {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: const Text(
          'Loading results...',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    
    if (errorMessage != null) {
      return Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: Text(
          'Error: $errorMessage',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Text(
        '$resultCount results',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (errorMessage != null && onRetry != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return itemList;
  }

  Widget _buildFilterButton() {
    return ElevatedButton.icon(
      onPressed: onFilterPressed,
      icon: const Icon(Icons.filter_list, color: Colors.white),
      label: const Text('Filter'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A5C83),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
