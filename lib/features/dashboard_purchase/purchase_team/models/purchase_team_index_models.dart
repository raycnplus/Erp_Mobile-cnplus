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
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'team_leader': teamLeader,
      'description': description,
    };
  }
}

class PurchaseTeamShowModel {
  final String teamName;
  final String teamLeaderName;
  final String description;
  final String createdDate;
  final int createdBy;
  final List<String> memberNames;

  PurchaseTeamShowModel({
    required this.teamName,
    required this.teamLeaderName,
    required this.description,
    required this.createdDate,
    required this.createdBy,
    required this.memberNames,
  });

  factory PurchaseTeamShowModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamShowModel(
      teamName: json['team_name'] ?? '',
      teamLeaderName: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
      createdDate: json['created_date'] ?? '',
      createdBy: json['created_by'] ?? 0,
      memberNames: (json['member'] as List<dynamic>)
       .map((m) => m['karyawan']?['nama_lengkap'] ?? '')
       .whereType<String>()
       .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'team_leader_name': teamLeaderName,
      'description': description,
      'created_date': createdDate,
      'created_by': createdBy,
      'member_names': memberNames,
    };
  }
}

