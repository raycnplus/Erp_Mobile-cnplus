import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class _SearchableItem<T> with CustomDropdownListFilter {
  final T value;
  final String label;

  _SearchableItem({
    required this.value,
    required this.label,
  });

  @override
  String toString() => label;

  @override
  bool filter(String query) => label.toLowerCase().contains(query.toLowerCase());

  @override
  bool operator ==(Object other) => other is _SearchableItem<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class CustomSearchableDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String label;
  final bool isRequired;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? hintText;

  final bool clearable;

  const CustomSearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.label,
    this.isRequired = false,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.clearable = true,
  });

  @override
  Widget build(BuildContext context) {
    final wrappedItems = items
        .map((e) => _SearchableItem<T>(value: e, label: itemLabel(e)))
        .toList();

    final currentValue = value;
    final wrappedValue = currentValue == null
        ? null
        : _SearchableItem<T>(value: currentValue, label: itemLabel(currentValue));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomDropdown<_SearchableItem<T>>.search(
                hintText: hintText ?? 'Select $label',
                items: wrappedItems,
                initialItem: wrappedValue,
                onChanged: enabled ? (w) => onChanged?.call(w?.value) : null,
                searchHintText: 'Search $label...',
                noResultFoundText: 'No result found',
                decoration: CustomDropdownDecoration(
                  closedFillColor: enabled ? Colors.white : Colors.grey[100],
                  expandedFillColor: Colors.white,
                  closedBorder: Border.all(color: Colors.grey[300]!),
                  expandedBorder:
                      Border.all(color: const Color(0xFF679436), width: 2),
                  closedBorderRadius: BorderRadius.circular(8),
                  expandedBorderRadius: BorderRadius.circular(8),
                  searchFieldDecoration: SearchFieldDecoration(
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Color(0xFF679436), width: 2),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  listItemDecoration: ListItemDecoration(
                    selectedColor:
                        const Color(0xFF679436).withOpacity(0.1),
                    highlightColor: Colors.grey[100],
                  ),
                  closedSuffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: enabled
                        ? Colors.grey[700]
                        : Colors.grey[400],
                  ),
                  expandedSuffixIcon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Color(0xFF679436),
                  ),
                ),
                headerBuilder: (context, selectedItem, enabled) {
                  return Text(
                    selectedItem != null
                        ? selectedItem.label
                        : (hintText ?? 'Select $label'),
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedItem != null
                          ? Colors.black87
                          : Colors.grey[400],
                    ),
                  );
                },
                listItemBuilder:
                    (context, item, isSelected, onItemSelect) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: Color(0xFF679436), size: 20)
                        else
                          Icon(Icons.radio_button_unchecked,
                              color: Colors.grey[400], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? const Color(0xFF679436)
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                validator: validator == null
                    ? null
                    : (w) => validator!(w?.value),
                excludeSelected: false,
              ),
            ),

            if (clearable && value != null && enabled) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: () => onChanged?.call(null),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}