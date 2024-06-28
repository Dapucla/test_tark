import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'github_users_event.dart';
import 'github_users_state.dart';
import '../models/github_user.dart';

class GitHubUsersBloc extends Bloc<GitHubUsersEvent, GitHubUsersState> {
  final Map<String, int> _lastFetchedUser = {'A-H': 0, 'I-P': 0, 'Q-Z': 0};
  final int _perPage = 30;

  GitHubUsersBloc() : super(UsersInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<GitHubUsersState> emit) async {
    emit(UsersLoading());
    try {
      final users = await _fetchUsers(event.section, 0);
      emit(UsersLoaded(_groupUsers(users)));
    } catch (_) {
      emit(UsersError('Failed to load users'));
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<GitHubUsersState> emit) async {
    emit(UsersLoading());
    try {
      final response = await http.get(Uri.parse('https://api.github.com/search/users?q=${event.query}'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['items'];
        List<GitHubUser> users = await Future.wait(
          jsonResponse.map((user) => GitHubUser.fromJson(user)).map((user) => _fetchUserDetails(user)),
        );
        emit(SearchResultsLoaded(users));
      } else {
        emit(UsersError('Failed to search users'));
      }
    } catch (_) {
      emit(UsersError('Failed to search users'));
    }
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsers event, Emitter<GitHubUsersState> emit) async {
    if (state is UsersLoaded) {
      try {
        final users = await _fetchUsers(event.section, _lastFetchedUser[event.section]!);
        final currentState = state as UsersLoaded;
        final currentUsers = currentState.groupedUsers[event.section] ?? [];
        final updatedUsers = currentUsers + users;
        final updatedGroupedUsers = {...currentState.groupedUsers, event.section: updatedUsers};
        emit(UsersLoaded(updatedGroupedUsers));
      } catch (_) {
        emit(UsersError('Failed to load more users'));
      }
    }
  }

  Future<List<GitHubUser>> _fetchUsers(String section, int since) async {
    final response = await http.get(Uri.parse('https://api.github.com/users?since=$since&per_page=$_perPage'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      _lastFetchedUser[section] = jsonResponse.last['id'];
      return await Future.wait(
        jsonResponse.map((user) => GitHubUser.fromJson(user)).map((user) => _fetchUserDetails(user)),
      );
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<GitHubUser> _fetchUserDetails(GitHubUser user) async {
    final response = await http.get(Uri.parse('https://api.github.com/users/${user.login}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      user.followers = jsonResponse['followers'];
      user.following = jsonResponse['following'];
      return user;
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Map<String, List<GitHubUser>> _groupUsers(List<GitHubUser> users) {
    Map<String, List<GitHubUser>> groupedUsers = {'A-H': [], 'I-P': [], 'Q-Z': []};
    for (var user in users) {
      String firstLetter = user.login[0].toUpperCase();
      if ('A'.compareTo(firstLetter) <= 0 && 'H'.compareTo(firstLetter) >= 0) {
        groupedUsers['A-H']!.add(user);
      } else if ('I'.compareTo(firstLetter) <= 0 && 'P'.compareTo(firstLetter) >= 0) {
        groupedUsers['I-P']!.add(user);
      } else if ('Q'.compareTo(firstLetter) <= 0 && 'Z'.compareTo(firstLetter) >= 0) {
        groupedUsers['Q-Z']!.add(user);
      }
    }
    return groupedUsers;
  }
}
