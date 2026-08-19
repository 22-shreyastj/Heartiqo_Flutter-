import 'package:flutter/material.dart';
import '../model/discover_search_models.dart';

class DiscoverSearchSuggestions extends StatelessWidget {
  final List<SearchSuggestion> suggestions;
  final ValueChanged<String> onSelect;

  const DiscoverSearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2C4CE), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestions.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == suggestions.length - 1;

              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(item.text),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.type == SearchSuggestionType.name
                                  ? Icons.person_outline_rounded
                                  : Icons.tag_rounded,
                              size: 18,
                              color: item.type == SearchSuggestionType.name
                                  ? const Color(0xFF8A0B3B)
                                  : const Color(0xFFC41C70),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.text,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2E0F1A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF0F3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.type == SearchSuggestionType.name
                                    ? 'Name'
                                    : 'Interest',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8A0B3B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Color(0xFFF3DDE4),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
