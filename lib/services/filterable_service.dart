import 'package:flutter/foundation.dart';

abstract class FilterableService<T> {
  // Load all data
  Future<List<T>> getAllItems();
  
  // Filter data based on criteria
  Future<List<T>> getFilteredItems({
    Map<String, dynamic>? filters,
  });
  
  // Apply filter to an in-memory list of items
  @protected
  List<T> applyFiltersLocally(List<T> items, Map<String, dynamic> filters) {
    // Default implementation that should be overridden by child classes
    return items;
  }
}
