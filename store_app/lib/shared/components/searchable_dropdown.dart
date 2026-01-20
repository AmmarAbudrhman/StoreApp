import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdown extends StatelessWidget {
  final String labelText;
  final String? selectedItem;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String searchHintText;

  const SearchableDropdown({
    super.key,
    required this.labelText,
    this.selectedItem,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.searchHintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHintText,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        menuProps: MenuProps(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
          title: Text(item),
          leading: isSelected
              ? const Icon(Icons.check, color: Colors.green)
              : null,
        ),
        emptyBuilder: (context, searchEntry) => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No items found'),
          ),
        ),
      ),
      items: (filter, loadProps) {
        if (filter.isEmpty) {
          return items;
        }
        return items
            .where((item) => item.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      onChanged: onChanged,
      selectedItem: selectedItem,
      validator: validator,
    );
  }
}
