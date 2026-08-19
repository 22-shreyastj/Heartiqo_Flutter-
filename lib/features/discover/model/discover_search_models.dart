import 'package:flutter/material.dart';

enum SearchSuggestionType { name, interest }

class SearchSuggestion {
  final String text;
  final SearchSuggestionType type;

  const SearchSuggestion({required this.text, required this.type});
}

class RecentSearchItem {
  final String id;
  final String query;
  final int count;
  final DateTime lastSearchedAt;
  final String? profileName;
  final int? age;
  final String? imageUrl;

  const RecentSearchItem({
    required this.id,
    required this.query,
    this.count = 1,
    required this.lastSearchedAt,
    this.profileName,
    this.age,
    this.imageUrl,
  });

  String get displayName {
    if (age != null && profileName != null) {
      return '$profileName, $age';
    }
    return query;
  }

  RecentSearchItem copyWith({int? count, DateTime? lastSearchedAt}) {
    return RecentSearchItem(
      id: id,
      query: query,
      count: count ?? this.count,
      lastSearchedAt: lastSearchedAt ?? this.lastSearchedAt,
      profileName: profileName,
      age: age,
      imageUrl: imageUrl,
    );
  }
}

class TrendingInterestItem {
  final String label;
  final IconData icon;

  const TrendingInterestItem({required this.label, required this.icon});
}
