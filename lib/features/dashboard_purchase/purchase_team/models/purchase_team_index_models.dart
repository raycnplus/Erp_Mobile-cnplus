class PurchaseTeamIndexModel {
  final String teamName;
  final String teamLeader;
  final String description;

  PurchaseTeamIndexModel({
    required this.teamName,
    required this.teamLeader,
    required this.description,
  });

  factory PurchaseTeamIndexModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamIndexModel(
      teamName: json['teamName'],
      teamLeader: json['teamLeader'],
      description: json['description'],
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'teamLeader': teamLeader,
      'description': description,
    };
  }
}