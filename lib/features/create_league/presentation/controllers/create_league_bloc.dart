import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../domain/entities/league_format.dart';
import '../../domain/utils/league_create_playing_count_policy.dart';
import '../../domain/entities/league_image_kind.dart';
import '../../domain/entities/league_participant_draft.dart';
import '../../domain/repositories/league_publish_repository.dart';
import '../../domain/usecases/publish_league_usecase.dart';
import '../../domain/usecases/search_users_for_league_usecase.dart'
    show SearchUsersForLeagueParams, SearchUsersForLeagueUseCase;
import '../../domain/usecases/upload_league_draft_image_usecase.dart';
import 'create_league_event.dart';
import 'create_league_state.dart';

class CreateLeagueBloc extends Bloc<CreateLeagueEvent, CreateLeagueState> {
  CreateLeagueBloc(
    this._uploadLeagueDraftImageUseCase,
    this._publishLeagueUseCase,
    this._searchUsersForLeagueUseCase,
    this._getCurrentUser,
  ) : super(const CreateLeagueState()) {
    on<CreateLeagueNameChanged>(_onName);
    on<CreateLeagueSportChanged>(_onSport);
    on<CreateLeagueFormatSelected>(_onFormat);
    on<CreateLeagueAutomateToggled>(_onAutomate);
    on<CreateLeagueCreatorJoinToggled>(_onCreatorJoin);
    on<CreateLeagueParticipantQueryChanged>(_onQuery);
    on<CreateLeagueAdminQueryChanged>(_onAdminQuery);
    on<CreateLeagueSearchDebounced>(_onSearchDebounced);
    on<CreateLeagueAdminSearchDebounced>(_onAdminSearchDebounced);
    on<CreateLeagueParticipantAdded>(_onParticipantAdded);
    on<CreateLeagueAdminAdded>(_onAdminAdded);
    on<CreateLeagueAdminRemoved>(_onAdminRemoved);
    on<CreateLeagueParticipantRemoved>(_onRemove);
    on<CreateLeagueSoloMatchCountChanged>(_onSoloMatchCount);
    on<CreateLeaguePublishPressed>(_onPublish);
    on<CreateLeagueEndDateChanged>(_onEndDate);
    on<CreateLeaguePrizePoolChanged>(_onPrizePool);
    on<CreateLeagueLogoUrlChanged>(_onLogoUrl);
    on<CreateLeagueBannerUrlChanged>(_onBannerUrl);
    on<CreateLeagueLogoUploadRequested>(_onLogoUpload);
    on<CreateLeagueBannerUploadRequested>(_onBannerUpload);
  }

  final UploadLeagueDraftImageUseCase _uploadLeagueDraftImageUseCase;
  final PublishLeagueUseCase _publishLeagueUseCase;
  final SearchUsersForLeagueUseCase _searchUsersForLeagueUseCase;
  final GetCurrentUserUseCase _getCurrentUser;

  Timer? _searchDebounce;
  Timer? _adminSearchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _adminSearchDebounce?.cancel();
    return super.close();
  }

  void _onName(CreateLeagueNameChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(leagueName: e.name));
  }

  void _onSport(CreateLeagueSportChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(sport: e.sport));
  }

  void _onFormat(CreateLeagueFormatSelected e, Emitter<CreateLeagueState> emit) {
    var next = state.copyWith(format: e.format);
    if (e.format == LeagueFormat.solo && next.participants.length > next.maxInvitedPlayersSolo) {
      next = next.copyWith(
        participants: next.participants.take(next.maxInvitedPlayersSolo).toList(),
      );
    }
    emit(next);
  }

  void _onAutomate(CreateLeagueAutomateToggled e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(automateFixtures: e.value));
  }

  void _onCreatorJoin(CreateLeagueCreatorJoinToggled e, Emitter<CreateLeagueState> emit) {
    var next = state.copyWith(creatorJoinsAsParticipant: e.value);
    if (next.format == LeagueFormat.solo &&
        e.value &&
        next.participants.length > next.maxInvitedPlayersSolo) {
      next = next.copyWith(
        participants: next.participants.take(next.maxInvitedPlayersSolo).toList(),
      );
    }
    emit(next);
  }

  void _onQuery(CreateLeagueParticipantQueryChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(participantQuery: e.query));
    _searchDebounce?.cancel();
    final q = e.query.trim();
    if (q.length < 2) {
      emit(state.copyWith(userSearchResults: [], userSearchLoading: false));
      return;
    }
    emit(state.copyWith(userSearchLoading: true));
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      add(CreateLeagueSearchDebounced(e.query));
    });
  }

  void _onAdminQuery(CreateLeagueAdminQueryChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(adminQuery: e.query));
    _adminSearchDebounce?.cancel();
    final q = e.query.trim();
    if (q.length < 2) {
      emit(state.copyWith(adminSearchResults: [], adminSearchLoading: false));
      return;
    }
    emit(state.copyWith(adminSearchLoading: true));
    _adminSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      add(CreateLeagueAdminSearchDebounced(e.query));
    });
  }

  Future<void> _onSearchDebounced(
    CreateLeagueSearchDebounced e,
    Emitter<CreateLeagueState> emit,
  ) async {
    final auth = await _getCurrentUser(const GetCurrentUserParams());
    final uid = auth.fold<String?>((_) => null, (u) => u.id);
    final result = await _searchUsersForLeagueUseCase(
      SearchUsersForLeagueParams(
        query: e.query.trim(),
        excludeUserId: uid,
      ),
    );
    result.fold(
      (_) => emit(state.copyWith(userSearchLoading: false, userSearchResults: [])),
      (list) => emit(state.copyWith(userSearchLoading: false, userSearchResults: list)),
    );
  }

  Future<void> _onAdminSearchDebounced(
    CreateLeagueAdminSearchDebounced e,
    Emitter<CreateLeagueState> emit,
  ) async {
    final auth = await _getCurrentUser(const GetCurrentUserParams());
    final uid = auth.fold<String?>((_) => null, (u) => u.id);
    final result = await _searchUsersForLeagueUseCase(
      SearchUsersForLeagueParams(
        query: e.query.trim(),
        excludeUserId: uid,
      ),
    );
    result.fold(
      (_) => emit(state.copyWith(adminSearchLoading: false, adminSearchResults: [])),
      (list) => emit(state.copyWith(adminSearchLoading: false, adminSearchResults: list)),
    );
  }

  void _onParticipantAdded(CreateLeagueParticipantAdded e, Emitter<CreateLeagueState> emit) {
    if (state.participants.any((p) => p.id == e.user.id)) {
      emit(state.copyWith(userSearchResults: []));
      return;
    }
    if (state.format == LeagueFormat.solo &&
        state.participants.length >= state.maxInvitedPlayersSolo) {
      emit(state.copyWith(userSearchResults: []));
      return;
    }
    final draft = LeagueParticipantDraft(
      id: e.user.id,
      name: e.user.displayName,
      subtitle: e.user.subtitle,
      isTeam: false,
      isAdmin: false,
    );
    emit(
      state.copyWith(
        participants: [...state.participants, draft],
        participantQuery: '',
        userSearchResults: [],
      ),
    );
  }

  void _onAdminAdded(CreateLeagueAdminAdded e, Emitter<CreateLeagueState> emit) {
    final exists = state.admins.any((a) => a.id == e.user.id);
    if (exists) {
      emit(state.copyWith(adminSearchResults: []));
      return;
    }
    final draft = LeagueParticipantDraft(
      id: e.user.id,
      name: e.user.displayName,
      subtitle: e.user.subtitle,
      isTeam: false,
      isAdmin: true,
    );
    emit(
      state.copyWith(
        admins: [...state.admins, draft],
        adminQuery: '',
        adminSearchResults: [],
      ),
    );
  }

  void _onAdminRemoved(CreateLeagueAdminRemoved e, Emitter<CreateLeagueState> emit) {
    emit(
      state.copyWith(
        admins: state.admins.where((a) => a.id != e.id).toList(),
      ),
    );
  }

  void _onRemove(CreateLeagueParticipantRemoved e, Emitter<CreateLeagueState> emit) {
    emit(
      state.copyWith(
        participants: state.participants.where((p) => p.id != e.id).toList(),
      ),
    );
  }

  void _onSoloMatchCount(CreateLeagueSoloMatchCountChanged e, Emitter<CreateLeagueState> emit) =>
      emit(state.copyWith(soloMatchCount: e.count.clamp(1, 20)));

  Future<void> _onPublish(
    CreateLeaguePublishPressed e,
    Emitter<CreateLeagueState> emit,
  ) async {
    if (state.leagueName.trim().isEmpty) {
      emit(state.copyWith(publishError: 'Enter a league name'));
      return;
    }
    final formatError = LeagueCreatePlayingCountPolicy.publishError(
      format: state.format,
      playingParticipantCount: state.playingParticipantCount,
      automateFixtures: state.automateFixtures,
    );
    if (formatError != null) {
      emit(state.copyWith(publishError: formatError));
      return;
    }
    if (state.format == LeagueFormat.solo && state.soloMatchCount < 1) {
      emit(state.copyWith(publishError: 'Choose at least one match for 1v1 format.'));
      return;
    }
    final overlap = state.participants.any((p) => state.admins.any((a) => a.id == p.id));
    if (overlap) {
      emit(state.copyWith(publishError: 'A user cannot be both player and admin.'));
      return;
    }
    emit(state.copyWith(publishing: true, publishError: null, publishSuccessLeagueId: null));
    final authResult = await _getCurrentUser(const GetCurrentUserParams());
    final user = authResult.fold((_) => null, (u) => u);
    if (user == null || !user.isAuthenticated || user.id.isEmpty) {
      emit(
        state.copyWith(
          publishing: false,
          publishError: 'Sign in to publish a league.',
        ),
      );
      return;
    }
    final displayName = FirebaseAuth.instance.currentUser?.displayName ??
        (user.email.isNotEmpty ? user.email.split('@').first : 'Player');

    final result = await _publishLeagueUseCase(
      PublishLeagueParams(
        leagueName: state.leagueName,
        sport: state.sport,
        format: state.format,
        automateFixtures: state.automateFixtures,
        creatorId: user.id,
        creatorDisplayName: displayName,
        invitedParticipants: state.participants,
        invitedAdmins: state.admins,
        soloMatchCount: state.soloMatchCount,
        creatorJoinsAsParticipant: state.creatorJoinsAsParticipant,
        endDate: state.endDate,
        prizePool: state.prizePool,
        logoUrl: state.logoUrl,
        bannerUrl: state.bannerUrl,
        maxParticipants: state.participantCap,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(publishing: false, publishError: f.message)),
      (id) => emit(
        state.copyWith(
          publishing: false,
          publishSuccessLeagueId: id,
          publishError: null,
        ),
      ),
    );
  }

  void _onEndDate(CreateLeagueEndDateChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(endDate: e.endDate));
  }

  void _onPrizePool(CreateLeaguePrizePoolChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(prizePool: e.value));
  }

  void _onLogoUrl(CreateLeagueLogoUrlChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(logoUrl: e.value.isEmpty ? null : e.value));
  }

  void _onBannerUrl(CreateLeagueBannerUrlChanged e, Emitter<CreateLeagueState> emit) {
    emit(state.copyWith(bannerUrl: e.value.isEmpty ? null : e.value));
  }

  Future<void> _onLogoUpload(
    CreateLeagueLogoUploadRequested e,
    Emitter<CreateLeagueState> emit,
  ) async {
    emit(
      state.copyWith(
        logoUploading: true,
        logoUploadError: null,
        logoPreviewBytes: e.bytes,
      ),
    );
    final result = await _uploadLeagueDraftImageUseCase(
      UploadLeagueDraftImageParams(
        kind: LeagueImageKind.logo,
        imageBytes: e.bytes,
        contentType: e.contentType,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(logoUploading: false, logoUploadError: f.message)),
      (url) => emit(
        state.copyWith(
          logoUploading: false,
          logoUrl: url,
          logoUploadError: null,
        ),
      ),
    );
  }

  Future<void> _onBannerUpload(
    CreateLeagueBannerUploadRequested e,
    Emitter<CreateLeagueState> emit,
  ) async {
    emit(
      state.copyWith(
        bannerUploading: true,
        bannerUploadError: null,
        bannerPreviewBytes: e.bytes,
      ),
    );
    final result = await _uploadLeagueDraftImageUseCase(
      UploadLeagueDraftImageParams(
        kind: LeagueImageKind.banner,
        imageBytes: e.bytes,
        contentType: e.contentType,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(bannerUploading: false, bannerUploadError: f.message)),
      (url) => emit(
        state.copyWith(
          bannerUploading: false,
          bannerUrl: url,
          bannerUploadError: null,
        ),
      ),
    );
  }
}
