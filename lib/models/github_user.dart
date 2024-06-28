class GitHubUser {
  final String login;
  final String avatarUrl;
  int followers;
  int following;

  GitHubUser({
    required this.login,
    required this.avatarUrl,
    this.followers = 0,
    this.following = 0,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
