import 'package:equatable/equatable.dart';

abstract class GitHubUsersEvent extends Equatable {
  const GitHubUsersEvent();

  @override
  List<Object> get props => [];
}

class FetchUsers extends GitHubUsersEvent {
  final String section;

  const FetchUsers(this.section);

  @override
  List<Object> get props => [section];
}

class LoadMoreUsers extends GitHubUsersEvent {
  final String section;

  LoadMoreUsers(this.section);

  @override
  List<Object> get props => [section];
}

class SearchUsers extends GitHubUsersEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}
