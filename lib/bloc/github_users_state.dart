import 'package:equatable/equatable.dart';
import '../models/github_user.dart';

abstract class GitHubUsersState extends Equatable {
  const GitHubUsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends GitHubUsersState {}

class UsersLoading extends GitHubUsersState {}

class UsersLoaded extends GitHubUsersState {
  final Map<String, List<GitHubUser>> groupedUsers;

  const UsersLoaded(this.groupedUsers);

  @override
  List<Object> get props => [groupedUsers];
}

class SearchResultsLoaded extends GitHubUsersState {
  final List<GitHubUser> searchResults;

  const SearchResultsLoaded(this.searchResults);

  @override
  List<Object> get props => [searchResults];
}

class UsersError extends GitHubUsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}
