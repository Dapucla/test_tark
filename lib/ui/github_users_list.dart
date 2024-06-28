import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/github_users_bloc.dart';
import '../bloc/github_users_event.dart';
import '../bloc/github_users_state.dart';
import '../models/github_user.dart';

class GitHubUsersList extends StatefulWidget {
  @override
  _GitHubUsersListState createState() => _GitHubUsersListState();
}

class _GitHubUsersListState extends State<GitHubUsersList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    BlocProvider.of<GitHubUsersBloc>(context).add(FetchUsers(_getCurrentSection()));
  }

  String _getCurrentSection() {
    switch (_tabController.index) {
      case 0:
        return 'A-H';
      case 1:
        return 'I-P';
      case 2:
        return 'Q-Z';
      default:
        return 'A-H';
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      BlocProvider.of<GitHubUsersBloc>(context).add(SearchUsers(_searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text('GitHub Users'),
        actions: _buildActions(),
        bottom: _isSearching
            ? null
            : TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'A-H'),
            Tab(text: 'I-P'),
            Tab(text: 'Q-Z'),
          ],
        ),
      ),
      body: BlocBuilder<GitHubUsersBloc, GitHubUsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return _isSearching ? _buildSearchResults(state.groupedUsers) : _buildTabBarView(state.groupedUsers);
          } else if (state is SearchResultsLoaded) {
            return _buildUserList(state.searchResults);
          } else if (state is UsersError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No Users Found'));
        },
      ),
    );
  }

  Widget _buildTabBarView(Map<String, List<GitHubUser>> groupedUsers) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildUserListWithPagination(groupedUsers['A-H'] ?? []),
        _buildUserListWithPagination(groupedUsers['I-P'] ?? []),
        _buildUserListWithPagination(groupedUsers['Q-Z'] ?? []),
      ],
    );
  }

  Widget _buildSearchResults(Map<String, List<GitHubUser>> groupedUsers) {
    return _buildUserList(groupedUsers['A-H']!);
  }

  Widget _buildUserList(List<GitHubUser> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        GitHubUser user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.login),
          subtitle: Text('Followers: ${user.followers}, Following: ${user.following}'),
        );
      },
    );
  }

  Widget _buildUserListWithPagination(List<GitHubUser> users) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          BlocProvider.of<GitHubUsersBloc>(context).add(LoadMoreUsers(_getCurrentSection()));
        }
        return false;
      },
      child: ListView.builder(
        itemCount: users.length + 1,
        itemBuilder: (context, index) {
          if (index == users.length) {
            return _buildLoadingMoreIndicator();
          }
          GitHubUser user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            title: Text(user.login),
            subtitle: Text('Followers: ${user.followers}, Following: ${user.following}'),
          );
        },
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _clearSearch();
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _startSearch();
          },
        ),
      ];
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
