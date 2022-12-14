class VideoModel {
  const VideoModel({
    required this.id,
    required this.title,
    required this.url,
    required this.userId,
    required this.userNick,
    required this.userPhoto,
    required this.tribeNick,
    required this.tribePhoto,
    required this.claps,
    required this.views,
    required this.userName,
    required this.uploaded,
    required this.gsID,
    required this.userCompany,
    required this.userIsVerified,
    required this.userRole,
    required this.userClapped,
    required this.userBookmarked,
    required this.userSeen,
    required this.userSeenScore,
    required this.tags,
    this.filePath,
  });

  static VideoModel fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      userId: map['user_id'],
      userNick: map['user_nick'],
      userPhoto: map['user_photo'],
      tribeNick: map['tribe_nick'],
      tribePhoto: map['tribe_photo'],
      claps: map['claps'],
      views: map['views'],
      userName: map['user_name'],
      uploaded: map['uploaded'],
      userCompany: map['user_company'],
      userIsVerified: map['user_is_verified'],
      userRole: map['user_role'],
      userClapped: map['user_clapped'],
      userBookmarked: map['user_bookmarked'],
      userSeen: map['user_seen'],
      userSeenScore: map['user_seen_score'],
      gsID: map['gsID'],
      tags: map['tags']?.cast<String>() ?? <String>[],
    );
  }

  final String id;
  final String title;
  final String url;
  final String userId;
  final String userNick;
  final String? userPhoto;
  final String? tribeNick;
  final String? tribePhoto;
  final int claps;
  final int views;
  final String userName;
  final String uploaded;
  final String userCompany;
  final bool userIsVerified;
  final String userRole;
  final bool userClapped;
  final bool userBookmarked;
  final bool userSeen;
  final double userSeenScore;
  final String gsID;
  final List<String> tags;
  final String? filePath;

  VideoModel copyWith({
    String? id,
    String? title,
    String? url,
    String? userId,
    String? userNick,
    String? userPhoto,
    String? tribeNick,
    String? tribePhoto,
    int? claps,
    int? views,
    String? userName,
    String? uploaded,
    String? userCompany,
    bool? userIsVerified,
    String? userRole,
    bool? userClapped,
    bool? userBookmarked,
    bool? userSeen,
    double? userSeenScore,
    String? gsID,
    List<String>? tags,
    String? filePath,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      userId: userId ?? this.userId,
      userNick: userNick ?? this.userNick,
      userPhoto: userPhoto ?? this.userPhoto,
      tribeNick: tribeNick ?? this.tribeNick,
      tribePhoto: tribePhoto ?? this.tribePhoto,
      claps: claps ?? this.claps,
      views: views ?? this.views,
      userName: userName ?? this.userName,
      uploaded: uploaded ?? this.uploaded,
      userCompany: userCompany ?? this.userCompany,
      userIsVerified: userIsVerified ?? this.userIsVerified,
      userRole: userRole ?? this.userRole,
      userClapped: userClapped ?? this.userClapped,
      userBookmarked: userBookmarked ?? this.userBookmarked,
      userSeen: userSeen ?? this.userSeen,
      userSeenScore: userSeenScore ?? this.userSeenScore,
      gsID: gsID ?? this.gsID,
      tags: tags ?? this.tags,
      filePath: filePath ?? this.filePath,
    );
  }
}
