import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/github_users_bloc.dart';
import 'bloc/github_users_event.dart';
import 'ui/github_users_list.dart';

void main() {
  runApp(GitHubUsersApp());
}

class GitHubUsersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Users',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => GitHubUsersBloc()..add(FetchUsers('A-H')),
        child: GitHubUsersList(),
      ),
    );
  }
}
