import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/league_format.dart';
import '../../domain/entities/league_participant_draft.dart';
import '../../domain/entities/user_search_result_entity.dart';

class CreateLeagueState extends Equatable {
  const CreateLeagueState({
    this.leagueName = '',
    this.sport = 'Football',
    this.format = LeagueFormat.knockout,
    this.automateFixtures = true,
    this.creatorJoinsAsParticipant = false,
    this.participantQuery = '',
    this.adminQuery = '',
    this.participants = const [],
    this.admins = const [],
    this.userSearchResults = const [],
    this.adminSearchResults = const [],
    this.userSearchLoading = false,
    this.adminSearchLoading = false,
    this.soloMatchCount = 3,
    this.publishing = false,
    this.publishError,
    this.publishSuccessLeagueId,
    this.logoPreviewBytes,
    this.bannerPreviewBytes,
    this.endDate,
    this.prizePool,
    this.logoUrl,
    this.bannerUrl,
    this.logoUploading = false,
    this.bannerUploading = false,
    this.logoUploadError,
    this.bannerUploadError,
  });

  static const Object _unset = Object();

  final String leagueName;
  final String sport;
  final LeagueFormat format;
  final bool automateFixtures;
  final bool creatorJoinsAsParticipant;
  final String participantQuery;
  final String adminQuery;
  final List<LeagueParticipantDraft> participants;
  final List<LeagueParticipantDraft> admins;
  final List<UserSearchResultEntity> userSearchResults;
  final List<UserSearchResultEntity> adminSearchResults;
  final bool userSearchLoading;
  final bool adminSearchLoading;
  final int soloMatchCount;
  final bool publishing;
  final String? publishError;
  final String? publishSuccessLeagueId;
  final Uint8List? logoPreviewBytes;
  final Uint8List? bannerPreviewBytes;

  final DateTime? endDate;
  final double? prizePool;

  final String? logoUrl;
  final String? bannerUrl;

  final bool logoUploading;
  final bool bannerUploading;
  final String? logoUploadError;
  final String? bannerUploadError;

  String get previewTitle =>
      leagueName.trim().isEmpty ? 'Your league name' : leagueName.trim();

  int get participantCap => format == LeagueFormat.solo ? 2 : 32;
  int get participantTarget => format == LeagueFormat.solo ? 2 : 16;

  /// Total players in fixtures/standings (invited + you if you opt in).
  int get playingParticipantCount =>
      participants.length + (creatorJoinsAsParticipant ? 1 : 0);

  /// Max invited players for 1v1 when you may also count as a player.
  int get maxInvitedPlayersSolo => creatorJoinsAsParticipant ? 1 : 2;

  CreateLeagueState copyWith({
    String? leagueName,
    String? sport,
    LeagueFormat? format,
    bool? automateFixtures,
    bool? creatorJoinsAsParticipant,
    String? participantQuery,
    String? adminQuery,
    List<LeagueParticipantDraft>? participants,
    List<LeagueParticipantDraft>? admins,
    List<UserSearchResultEntity>? userSearchResults,
    List<UserSearchResultEntity>? adminSearchResults,
    bool? userSearchLoading,
    bool? adminSearchLoading,
    int? soloMatchCount,
    bool? publishing,
    Object? publishError = _unset,
    Object? publishSuccessLeagueId = _unset,
    Object? logoPreviewBytes = _unset,
    Object? bannerPreviewBytes = _unset,
    Object? endDate = _unset,
    Object? prizePool = _unset,
    Object? logoUrl = _unset,
    Object? bannerUrl = _unset,
    bool? logoUploading,
    bool? bannerUploading,
    Object? logoUploadError = _unset,
    Object? bannerUploadError = _unset,
  }) {
    return CreateLeagueState(
      leagueName: leagueName ?? this.leagueName,
      sport: sport ?? this.sport,
      format: format ?? this.format,
      automateFixtures: automateFixtures ?? this.automateFixtures,
      creatorJoinsAsParticipant: creatorJoinsAsParticipant ?? this.creatorJoinsAsParticipant,
      participantQuery: participantQuery ?? this.participantQuery,
      adminQuery: adminQuery ?? this.adminQuery,
      participants: participants ?? this.participants,
      admins: admins ?? this.admins,
      userSearchResults: userSearchResults ?? this.userSearchResults,
      adminSearchResults: adminSearchResults ?? this.adminSearchResults,
      userSearchLoading: userSearchLoading ?? this.userSearchLoading,
      adminSearchLoading: adminSearchLoading ?? this.adminSearchLoading,
      soloMatchCount: soloMatchCount ?? this.soloMatchCount,
      publishing: publishing ?? this.publishing,
      publishError:
          identical(publishError, _unset) ? this.publishError : publishError as String?,
      publishSuccessLeagueId: identical(publishSuccessLeagueId, _unset)
          ? this.publishSuccessLeagueId
          : publishSuccessLeagueId as String?,
      logoPreviewBytes: identical(logoPreviewBytes, _unset)
          ? this.logoPreviewBytes
          : logoPreviewBytes as Uint8List?,
      bannerPreviewBytes: identical(bannerPreviewBytes, _unset)
          ? this.bannerPreviewBytes
          : bannerPreviewBytes as Uint8List?,
      endDate: identical(endDate, _unset) ? this.endDate : endDate as DateTime?,
      prizePool: identical(prizePool, _unset) ? this.prizePool : prizePool as double?,
      logoUrl: identical(logoUrl, _unset) ? this.logoUrl : logoUrl as String?,
      bannerUrl: identical(bannerUrl, _unset) ? this.bannerUrl : bannerUrl as String?,
      logoUploading: logoUploading ?? this.logoUploading,
      bannerUploading: bannerUploading ?? this.bannerUploading,
      logoUploadError:
          identical(logoUploadError, _unset) ? this.logoUploadError : logoUploadError as String?,
      bannerUploadError: identical(bannerUploadError, _unset)
          ? this.bannerUploadError
          : bannerUploadError as String?,
    );
  }

  @override
  List<Object?> get props => [
        leagueName,
        sport,
        format,
        automateFixtures,
        creatorJoinsAsParticipant,
        participantQuery,
        adminQuery,
        participants,
        admins,
        userSearchResults,
        adminSearchResults,
        userSearchLoading,
        adminSearchLoading,
        soloMatchCount,
        publishing,
        publishError,
        publishSuccessLeagueId,
        logoPreviewBytes,
        bannerPreviewBytes,
        endDate,
        prizePool,
        logoUrl,
        bannerUrl,
        logoUploading,
        bannerUploading,
        logoUploadError,
        bannerUploadError,
      ];
}
