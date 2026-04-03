import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeagueBasicSection extends StatefulWidget {
  const CreateLeagueBasicSection({
    required this.leagueName,
    required this.sport,
    required this.onName,
    required this.onSport,
    super.key,
  });

  final String leagueName;
  final String sport;
  final ValueChanged<String> onName;
  final ValueChanged<String> onSport;

  @override
  State<CreateLeagueBasicSection> createState() => _CreateLeagueBasicSectionState();
}

class _CreateLeagueBasicSectionState extends State<CreateLeagueBasicSection> {
  late final TextEditingController _nameController;

  static const _sports = ['Football', 'Basketball', 'Tennis'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.leagueName);
    _nameController.addListener(() => widget.onName(_nameController.text));
  }

  @override
  void didUpdateWidget(covariant CreateLeagueBasicSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.leagueName != oldWidget.leagueName &&
        widget.leagueName != _nameController.text) {
      _nameController.text = widget.leagueName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'League Fundamentals',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, c) {
            final twoCol = c.maxWidth >= 520;
            final nameField = _field(
              context,
              label: 'League Name',
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: DashboardColors.textPrimary),
                decoration: _inputDec(hint: 'e.g. Champions Arena 2024'),
              ),
            );
            final sportField = _field(
              context,
              label: 'Sport',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: DashboardColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: DashboardColors.borderSubtle),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sports.contains(widget.sport) ? widget.sport : _sports.first,
                    isExpanded: true,
                    dropdownColor: DashboardColors.bgSurface,
                    style: const TextStyle(color: DashboardColors.textPrimary),
                    iconEnabledColor: DashboardColors.textSecondary,
                    items: _sports
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) widget.onSport(v);
                    },
                  ),
                ),
              ),
            );
            if (!twoCol) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nameField,
                  const SizedBox(height: AppSpacing.md),
                  sportField,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: nameField),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: sportField),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _field(BuildContext context, {required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DashboardColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  InputDecoration _inputDec({required String hint}) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      hintStyle: const TextStyle(color: DashboardColors.textSecondary),
      filled: true,
      fillColor: DashboardColors.bgSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(color: DashboardColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(color: DashboardColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(color: DashboardColors.accentGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    );
  }
}
