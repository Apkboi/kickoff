import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/league_format.dart';
import '../../domain/entities/user_search_result_entity.dart';

sealed class CreateLeagueEvent extends Equatable {
  const CreateLeagueEvent();

  @override
  List<Object?> get props => [];
}

class CreateLeagueNameChanged extends CreateLeagueEvent {
  const CreateLeagueNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class CreateLeagueSportChanged extends CreateLeagueEvent {
  const CreateLeagueSportChanged(this.sport);

  final String sport;

  @override
  List<Object?> get props => [sport];
}

class CreateLeagueFormatSelected extends CreateLeagueEvent {
  const CreateLeagueFormatSelected(this.format);

  final LeagueFormat format;

  @override
  List<Object?> get props => [format];
}

class CreateLeagueAutomateToggled extends CreateLeagueEvent {
  const CreateLeagueAutomateToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class CreateLeagueCreatorJoinToggled extends CreateLeagueEvent {
  const CreateLeagueCreatorJoinToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class CreateLeagueParticipantQueryChanged extends CreateLeagueEvent {
  const CreateLeagueParticipantQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CreateLeagueAdminQueryChanged extends CreateLeagueEvent {
  const CreateLeagueAdminQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CreateLeagueParticipantRemoved extends CreateLeagueEvent {
  const CreateLeagueParticipantRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class CreateLeaguePublishPressed extends CreateLeagueEvent {
  const CreateLeaguePublishPressed();
}

class CreateLeagueEndDateChanged extends CreateLeagueEvent {
  const CreateLeagueEndDateChanged(this.endDate);

  final DateTime? endDate;

  @override
  List<Object?> get props => [endDate];
}

class CreateLeaguePrizePoolChanged extends CreateLeagueEvent {
  const CreateLeaguePrizePoolChanged(this.value);

  final double? value;

  @override
  List<Object?> get props => [value];
}

class CreateLeagueLogoUrlChanged extends CreateLeagueEvent {
  const CreateLeagueLogoUrlChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class CreateLeagueBannerUrlChanged extends CreateLeagueEvent {
  const CreateLeagueBannerUrlChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class CreateLeagueLogoUploadRequested extends CreateLeagueEvent {
  const CreateLeagueLogoUploadRequested({
    required this.bytes,
    required this.contentType,
  });

  final Uint8List bytes;
  final String contentType;

  @override
  List<Object?> get props => [];
}

class CreateLeagueBannerUploadRequested extends CreateLeagueEvent {
  const CreateLeagueBannerUploadRequested({
    required this.bytes,
    required this.contentType,
  });

  final Uint8List bytes;
  final String contentType;

  @override
  List<Object?> get props => [];
}

class CreateLeagueSearchDebounced extends CreateLeagueEvent {
  const CreateLeagueSearchDebounced(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CreateLeagueParticipantAdded extends CreateLeagueEvent {
  const CreateLeagueParticipantAdded(this.user);

  final UserSearchResultEntity user;

  @override
  List<Object?> get props => [user];
}

class CreateLeagueParticipantAdminToggled extends CreateLeagueEvent {
  const CreateLeagueParticipantAdminToggled(this.participantId);

  final String participantId;

  @override
  List<Object?> get props => [participantId];
}

class CreateLeagueAdminAdded extends CreateLeagueEvent {
  const CreateLeagueAdminAdded(this.user);

  final UserSearchResultEntity user;

  @override
  List<Object?> get props => [user];
}

class CreateLeagueAdminRemoved extends CreateLeagueEvent {
  const CreateLeagueAdminRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class CreateLeagueAdminSearchDebounced extends CreateLeagueEvent {
  const CreateLeagueAdminSearchDebounced(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CreateLeagueSoloMatchCountChanged extends CreateLeagueEvent {
  const CreateLeagueSoloMatchCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}
