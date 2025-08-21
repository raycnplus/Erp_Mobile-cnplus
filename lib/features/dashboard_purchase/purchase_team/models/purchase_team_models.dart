class PurchaseTeamIndexModel {
  final int idPurchaseTeam;
  final String teamName;
  final String teamLeader;
  final String description;

  PurchaseTeamIndexModel({
    required this.idPurchaseTeam,
    required this.teamName,
    required this.teamLeader,
    required this.description,
  });

  factory PurchaseTeamIndexModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamIndexModel(
      idPurchaseTeam: json['id_purchase_team'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?['nama_lengkap'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_purchase_team': idPurchaseTeam,
      'team_name': teamName,
      'team_leader': teamLeader,
      'description': description,
    };
  }
}

class PurchaseTeamShowModel {
  final int id;
  final String teamName;
  final String teamLeaderName;
  final String description;
  final String createdDate;
  final int createdBy;
  final List<String> memberNames;

  PurchaseTeamShowModel({
    required this.id,
    required this.teamName,
    required this.teamLeaderName,
    required this.description,
    required this.createdDate,
    required this.createdBy,
    required this.memberNames,
  });

  factory PurchaseTeamShowModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamShowModel(
      id: json['id_purchase_team'] ?? 0,
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
      'id_purchase_team': id,
      'team_name': teamName,
      'team_leader_name': teamLeaderName,
      'description': description,
      'created_date': createdDate,
      'created_by': createdBy,
      'member_names': memberNames,
    };
  }
}


class PurchaseTeamCreateModel {
  final String teamName;
  final int teamLeaderId;
  final String description;
  final List<int> memberIds;

  PurchaseTeamCreateModel({
    required this.teamName,
    required this.teamLeaderId,
    required this.description,
    required this.memberIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }

  Map<String, dynamic> toUpdateJson(int id) {
    return {
      'id_purchase_team': id,
      'team_name': teamName,
      'team_leader': teamLeaderId,
      'description': description,
      'member': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}


class KaryawanDropdownModel {
  final int id;
  final String fullName;

  KaryawanDropdownModel({
    required this.id,
    required this.fullName,
  });

  factory KaryawanDropdownModel.fromJson(Map<String, dynamic> json) {
    return KaryawanDropdownModel(
      id: json['id_karyawan'] ?? 0,
      fullName: json['nama_lengkap'] ?? '',
    );
  }

  @override
  String toString() => fullName;
}

