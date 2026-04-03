import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../controllers/create_league_bloc.dart';
import '../controllers/create_league_event.dart';
import 'create_league_end_date_row.dart';
import 'create_league_field_decoration.dart';
import 'create_league_image_url_field.dart';

class CreateLeagueMetadataSection extends StatefulWidget {
  const CreateLeagueMetadataSection({
    required this.endDate,
    required this.prizePool,
    required this.logoUrl,
    required this.bannerUrl,
    required this.logoUploading,
    required this.bannerUploading,
    required this.logoUploadError,
    required this.bannerUploadError,
    required this.onEndDate,
    required this.onPrizePool,
    required this.onLogoUrl,
    required this.onBannerUrl,
    this.logoPreviewBytes,
    this.bannerPreviewBytes,
    super.key,
  });

  final DateTime? endDate;
  final double? prizePool;
  final String? logoUrl;
  final String? bannerUrl;
  final Uint8List? logoPreviewBytes;
  final Uint8List? bannerPreviewBytes;
  final bool logoUploading;
  final bool bannerUploading;
  final String? logoUploadError;
  final String? bannerUploadError;
  final ValueChanged<DateTime?> onEndDate;
  final ValueChanged<double?> onPrizePool;
  final ValueChanged<String> onLogoUrl;
  final ValueChanged<String> onBannerUrl;

  @override
  State<CreateLeagueMetadataSection> createState() => _CreateLeagueMetadataSectionState();
}

class _CreateLeagueMetadataSectionState extends State<CreateLeagueMetadataSection> {
  late final TextEditingController _prizeController;
  late final TextEditingController _logoController;
  late final TextEditingController _bannerController;

  @override
  void initState() {
    super.initState();
    _prizeController = TextEditingController(
      text: widget.prizePool == null ? '' : _formatPrize(widget.prizePool!),
    );
    _logoController = TextEditingController(text: widget.logoUrl ?? '');
    _bannerController = TextEditingController(text: widget.bannerUrl ?? '');
    _prizeController.addListener(_emitPrize);
    _logoController.addListener(() => widget.onLogoUrl(_logoController.text));
    _bannerController.addListener(() => widget.onBannerUrl(_bannerController.text));
  }

  String _formatPrize(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toString();
  }

  void _emitPrize() {
    final t = _prizeController.text.trim();
    if (t.isEmpty) {
      widget.onPrizePool(null);
      return;
    }
    widget.onPrizePool(double.tryParse(t.replaceAll(',', '')));
  }

  @override
  void didUpdateWidget(covariant CreateLeagueMetadataSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prizePool != oldWidget.prizePool) {
      final next = widget.prizePool == null ? '' : _formatPrize(widget.prizePool!);
      if (_prizeController.text != next) _prizeController.text = next;
    }
    if (widget.logoUrl != oldWidget.logoUrl && (widget.logoUrl ?? '') != _logoController.text) {
      _logoController.text = widget.logoUrl ?? '';
    }
    if (widget.bannerUrl != oldWidget.bannerUrl && (widget.bannerUrl ?? '') != _bannerController.text) {
      _bannerController.text = widget.bannerUrl ?? '';
    }
  }

  @override
  void dispose() {
    _prizeController.dispose();
    _logoController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final initial = widget.endDate ?? now.add(const Duration(days: 30));
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 6),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (t == null || !mounted) return;
    widget.onEndDate(DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  String _endDateLabel() {
    final e = widget.endDate;
    if (e == null) return 'Not set';
    final y = e.year.toString().padLeft(4, '0');
    final m = e.month.toString().padLeft(2, '0');
    final day = e.day.toString().padLeft(2, '0');
    final h = e.hour.toString().padLeft(2, '0');
    final min = e.minute.toString().padLeft(2, '0');
    return '$y-$m-$day $h:$min';
  }

  Future<void> _uploadLogo() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 92,
    );
    if (x == null || !mounted) return;
    final bytes = await x.readAsBytes();
    if (!mounted) return;
    context.read<CreateLeagueBloc>().add(
          CreateLeagueLogoUploadRequested(
            bytes: bytes,
            contentType: x.mimeType ?? 'image/jpeg',
          ),
        );
  }

  Future<void> _uploadBanner() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2560,
      maxHeight: 1440,
      imageQuality: 88,
    );
    if (x == null || !mounted) return;
    final bytes = await x.readAsBytes();
    if (!mounted) return;
    context.read<CreateLeagueBloc>().add(
          CreateLeagueBannerUploadRequested(
            bytes: bytes,
            contentType: x.mimeType ?? 'image/jpeg',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule & media',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'End date',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DashboardColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CreateLeagueEndDateRow(
          displayText: _endDateLabel(),
          onSetPressed: _pickEndDate,
          showClear: widget.endDate != null,
          onClearPressed: () => widget.onEndDate(null),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Prize pool (optional)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DashboardColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _prizeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: DashboardColors.textPrimary),
          decoration: createLeagueFilledInputDecoration(hint: 'e.g. ₦5000'),
        ),
        const SizedBox(height: AppSpacing.md),
        CreateLeagueImageUrlField(
          label: 'Logo (optional)',
          controller: _logoController,
          uploading: widget.logoUploading,
          errorText: widget.logoUploadError,
          onUploadTap: _uploadLogo,
        ),
        if (widget.logoPreviewBytes != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Image.memory(
              widget.logoPreviewBytes!,
              height: 96,
              width: 96,
              fit: BoxFit.cover,
            ),
          ),
        ] else if (widget.logoUrl != null && widget.logoUrl!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Image.network(
              widget.logoUrl!,
              height: 96,
              width: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        CreateLeagueImageUrlField(
          label: 'Banner (optional)',
          controller: _bannerController,
          uploading: widget.bannerUploading,
          errorText: widget.bannerUploadError,
          onUploadTap: _uploadBanner,
        ),
        if (widget.bannerPreviewBytes != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.memory(
                widget.bannerPreviewBytes!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ] else if (widget.bannerUrl != null && widget.bannerUrl!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Image.network(
                widget.bannerUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
