/// Utility functions for handling list conversions
class ListUtils {
  /// Safely convert a List<dynamic> to List<String>
  static List<String> toStringList(dynamic list) {
    if (list == null) return [];
    
    if (list is List) {
      return list.map((item) => item.toString()).toList();
    }
    
    return [];
  }
  
  /// Check if a dynamic list contains a string value (case insensitive)
  static bool listContainsString(dynamic list, String value) {
    final stringList = toStringList(list);
    return stringList.any((item) => 
      item.toLowerCase() == value.toLowerCase());
  }
}
