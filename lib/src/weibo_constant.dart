class WeiboRegister {
  const WeiboRegister._();

  static const String DEFAULT_REDIRECTURL =
      'https://api.weibo.com/oauth2/default.html';
}

class WeiboScope {
  const WeiboScope._();

  static const String EMAIL = 'email';
  static const String DIRECT_MESSAGES_READ = 'direct_messages_read';
  static const String DIRECT_MESSAGES_WRITE = 'direct_messages_write';
  static const String FRIENDSHIPS_GROUPS_READ = 'friendships_groups_read';
  static const String FRIENDSHIPS_GROUPS_WRITE = 'friendships_groups_write';
  static const String STATUSES_TO_ME_READ = 'statuses_to_me_read';
  static const String FOLLOW_APP_OFFICIAL_MICROBLOG =
      'follow_app_official_microblog';
  static const String INVITATION_WRITE = 'invitation_write';
  static const String ALL = 'all';
}
