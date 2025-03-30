import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';

class TDropdown extends StatelessWidget {
  const TDropdown({
    super.key,
    this.width = 500,
    this.height = 40,
    this.value,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.showLeadingIcon = false,
    this.labelColor = TColors.black,
    this.enabled = true,
    this.inputFormatters,
  });

  final double width;
  final double height;
  final String? value;
  final List<String> items;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final bool showLeadingIcon;
  final Color? labelColor;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return DropdownSearch<String>(
      autoValidateMode: AutovalidateMode.always,
      filterFn: (item, filter) {
        return item.toLowerCase().startsWith(filter.toLowerCase());
      },
      selectedItem: value,
      dropdownButtonProps: DropdownButtonProps(
        icon: const Icon(Iconsax.arrow_circle_down4),
        color: labelColor,
      ),
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        showSelectedItems: true,
        searchDelay: const Duration(milliseconds: 100),
        searchFieldProps: TextFieldProps(
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: dark ? TColors.grey : TColors.darkGrey),
            prefixIcon: Icon(
              Icons.search,
              size: TSizes.md,
              color: dark ? TColors.grey : TColors.darkGrey,
            ),
          ),
        ),
        containerBuilder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(TSizes.sm),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(TSizes.sm),
                color: TColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: dark
                        ? TColors.light.withOpacity(0.3)
                        : TColors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.defaultSpace / 2,
              horizontal: TSizes.defaultSpace,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: dark
                      ? TColors.darkContainer
                      : TColors.dark.withOpacity(.1),
                ),
              ),
            ),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        dropdownSearchDecoration:
            TDeviceUtils.getScreenWidth(context) > TSizes.smallSceenSize
                ? InputDecoration(hintText: labelText)
                : InputDecoration.collapsed(
                    hintText: labelText,
                  ),
      ),
      dropdownBuilder: (context, selectedItem) => Row(
        children: [
          const SizedBox(
            width: TSizes.defaultSpace / 2,
          ),
          if (showLeadingIcon)
            const Icon(
              Iconsax.location,
              size: TSizes.md,
            ),
          if (showLeadingIcon)
            const SizedBox(
              width: TSizes.xs,
            ),
          SizedBox(
            width: screenWidth * .2,
            child: Text(
              selectedItem = selectedItem != ''
                  ? selectedItem ?? ''
                  : labelText, //Station Facilities Issue Fixed Here

              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: labelColor),
            ),
          ),
        ],
      ),
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}
