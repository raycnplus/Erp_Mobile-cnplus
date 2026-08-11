class SalesTeamPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  SalesTeamPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SalesTeamPaginationMeta.fromJson(Map<String, dynamic> json) {
    final meta = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return SalesTeamPaginationMeta(
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class SalesTeamModel {
  final String encryption;
  final String teamName;
  final String teamLeaderName;
  final String? description;
  final int memberCount;

  SalesTeamModel({
    required this.encryption,
    required this.teamName,
    required this.teamLeaderName,
    this.description,
    required this.memberCount,
  });

  factory SalesTeamModel.fromJson(Map<String, dynamic> json) {
    return SalesTeamModel(
      encryption: json['encryption'] ?? '',
      teamName: json['team_name'] ?? '',
      teamLeaderName: json['team_leader_name']?.toString() ??
          json['team_leader']?.toString() ?? '-',
      description: json['description'],
      memberCount: _parseInt(json['member_count']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

class SalesTeamDetailModel {
  final SalesTeamData team;
  final String? teamLeaderName;
  final List<SalesTeamMemberData> members;
  final String? createdByName;
  final String? updatedByName;

  SalesTeamDetailModel({
    required this.team,
    this.teamLeaderName,
    required this.members,
    this.createdByName,
    this.updatedByName,
  });

  factory SalesTeamDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SalesTeamDetailModel(
      team: SalesTeamData.fromJson(data),
      teamLeaderName: json['team_leader_name']?.toString(),
      members: (json['members'] as List? ?? [])
          .map((e) => SalesTeamMemberData.fromJson(e))
          .toList(),
      createdByName: json['created_by_name']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
    );
  }
}

class SalesTeamData {
  final String encryption;
  final String teamName;
  final int? teamLeaderId;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  SalesTeamData({
    required this.encryption,
    required this.teamName,
    this.teamLeaderId,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory SalesTeamData.fromJson(Map<String, dynamic> json) {
    return SalesTeamData(
      encryption: json['encryption'] ?? '',
      teamName: json['team_name'] ?? '',
      teamLeaderId: _parseInt(json['team_leader']),
      description: json['description'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class SalesTeamMemberData {
  final int idUser;
  final String? namaKaryawan;
  final String? email;

  SalesTeamMemberData({required this.idUser, this.namaKaryawan, this.email});

  factory SalesTeamMemberData.fromJson(Map<String, dynamic> json) {
    return SalesTeamMemberData(
      idUser: int.tryParse((json['id_user'] ?? 0).toString()) ?? 0,
      namaKaryawan: json['nama_karyawan']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

class SalesTeamDropdownData {
  final List<UserDropdown> users;

  SalesTeamDropdownData({required this.users});

  factory SalesTeamDropdownData.fromJson(Map<String, dynamic> json) {
    return SalesTeamDropdownData(
      users: (json['users'] as List? ?? [])
          .map((e) => UserDropdown.fromJson(e))
          .toList(),
    );
  }
}

class UserDropdown {
  final int id;
  final String fullName;
  final String? email;

  UserDropdown({required this.id, required this.fullName, this.email});

  factory UserDropdown.fromJson(Map<String, dynamic> json) => UserDropdown(
        id: int.tryParse((json['id_user'] ?? 0).toString()) ?? 0,
        fullName: json['nama_lengkap'] ?? '',
        email: json['email'],
      );

  @override
  String toString() => fullName;

  @override
  bool operator ==(Object other) => other is UserDropdown && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SalesTeamFormModel {
  String? encryption;
  String teamName;
  int? teamLeaderId;
  String description;
  List<int> memberIds;
  String? createdDate;
  String? updatedDate;

  SalesTeamFormModel({
    this.encryption,
    this.teamName = '',
    this.teamLeaderId,
    this.description = '',
    List<int>? memberIds,
    this.createdDate,
    this.updatedDate,
  }) : memberIds = memberIds ?? [];

  factory SalesTeamFormModel.fromDetail(SalesTeamDetailModel detail) {
    return SalesTeamFormModel(
      encryption: detail.team.encryption,
      teamName: detail.team.teamName,
      teamLeaderId: detail.team.teamLeaderId,
      description: detail.team.description ?? '',
      memberIds: detail.members.map((m) => m.idUser).toList(),
      createdDate: detail.team.createdDate,
      updatedDate: detail.team.updatedDate,
    );
  }

  bool isValid() =>
      teamName.trim().isNotEmpty &&
      teamLeaderId != null &&
      memberIds.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'team_name': teamName,
        'team_leader': teamLeaderId,
        'description': description.isEmpty ? null : description,
        'members': memberIds.map((id) => {'id_user': id}).toList(),
      };
}