import 'package:flutter/material.dart';
import 'package:mad_project/widgets/hub_layout.dart';
import 'package:mad_project/widgets/filter_bottom_sheet.dart';

abstract class BaseHubScreen<T> extends StatefulWidget {
  const BaseHubScreen({super.key});
}

abstract class BaseHubScreenState<T extends BaseHubScreen, D> extends State<T> {
  // Loading and error states
  bool isLoading = true;
  String? errorMessage;
  
  // Data
  List<D> items = [];
  
  // Required methods to be implemented by subclasses
  String get hubTitle;
  String get currentRoute;
  String get filterTitle;
  
  // Methods that should be implemented by subclasses
  Future<void> loadData();
  Future<void> applyFilters();
  void resetFilters();
  List<FilterOption> buildFilterOptions();
  Widget buildItemList();
  
  @override
  void initState() {
    super.initState();
    loadData();
  }
  
  void showFilterOptions() {
    showFilterBottomSheet(
      context: context,
      title: filterTitle,
      filterOptions: buildFilterOptions(),
      onApply: applyFilters,
      onReset: () {
        resetFilters();
        loadData();
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return HubLayout(
      title: hubTitle,
      currentRoute: currentRoute,
      resultCount: items.length,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRetry: loadData,
      onFilterPressed: showFilterOptions,
      itemList: buildItemList(),
    );
  }
  
  // Helper method to handle loading state
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        isLoading = loading;
      });
    }
  }
  
  // Helper method to set error state
  void setError(String? message) {
    if (mounted) {
      setState(() {
        errorMessage = message;
        isLoading = false;
      });
    }
  }
  
  // Helper method to update items
  void updateItems(List<D> newItems) {
    if (mounted) {
      setState(() {
        items = newItems;
        isLoading = false;
        errorMessage = null;
      });
    }
  }
}
