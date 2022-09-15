class User {
  User({
    required this.name,
    required this.deviceName,
    required this.highScore,
    required this.timeRegistered,
  });

  final String name;
  final String deviceName;
  final HighScore highScore;
  final String timeRegistered;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        deviceName = json['deviceName'],
        highScore = HighScore.fromJson(json['highScore']),
        timeRegistered = json['timeRegistered'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'deviceName': deviceName,
        'highScore': highScore.toJson(),
        'timeRegistered': timeRegistered,
      };
}

class HighScore {
  HighScore({
    this.highScoreTime20 = const {},
    this.highScore20Taps = const {},
    this.highScoreNoLimit = const {},
    this.highScoreEndless = const {},
  });

  final Map<int, num> highScoreTime20;
  final Map<int, num> highScore20Taps;
  final Map<int, num> highScoreNoLimit;
  final Map<int, num> highScoreEndless;

  HighScore.fromJson(Map<String, dynamic> json)
      : highScoreTime20 = json['highScoreTime20'],
        highScore20Taps = json['highScore20Taps'],
        highScoreNoLimit = json['highScoreNoLimit'],
        highScoreEndless = json['highScoreEndless'];

  Map<String, dynamic> toJson() => {
        'highScoreTime20': highScoreTime20,
        'highScore20Taps': highScore20Taps,
        'highScoreNoLimit': highScoreNoLimit,
        'highScoreEndless': highScoreEndless,
      };
}
