class PurchaseTeamPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PurchaseTeamPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PurchaseTeamPaginationMeta.fromJson(Map<String, dynamic> json) {
    final meta = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    return PurchaseTeamPaginationMeta(
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class PurchaseTeamModel {
  final String encryption;
  final String teamName;
  final String teamLeader;
  final String? description;

  PurchaseTeamModel({
    required this.encryption,
    required this.teamName,
    required this.teamLeader,
    this.description,
  });

  factory PurchaseTeamModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTeamModel(
      encryption: json['encryption'] ?? '',
      teamName: json['team_name'] ?? '',
      teamLeader: json['team_leader']?.toString() ?? '',
      description: json['description'],
    );
  }
}

class PurchaseTeamDetailModel {
  final PurchaseTeamData team;
  final String? createdByName;
  final String? updatedByName;

  PurchaseTeamDetailModel({
    required this.team,
    this.createdByName,
    this.updatedByName,
  });

  factory PurchaseTeamDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PurchaseTeamDetailModel(
      team: PurchaseTeamData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class PurchaseTeamData {
  final int? idPurchaseTeam;
  final String encryption;
  final String teamName;
  final String? teamLeaderName;
  final int? teamLeaderId;
  final String? description;
  final List<PurchaseMemberData> members;
  final String? createdDate;
  final String? updatedDate;

  PurchaseTeamData({
    this.idPurchaseTeam,
    required this.encryption,
    required this.teamName,
    this.teamLeaderName,
    this.teamLeaderId,
    this.description,
    required this.members,
    this.createdDate,
    this.updatedDate,
  });

  factory PurchaseTeamData.fromJson(Map<String, dynamic> json) {
    final memberList = _parseMembers(json);

    final leaderRaw = json['team_leader'];
    int? leaderId;
    if (leaderRaw is Map) {
      leaderId = _parseInt(leaderRaw['id_user']);
    } else {
      leaderId = _parseInt(leaderRaw);
    }

    return PurchaseTeamData(
      idPurchaseTeam: _parseInt(json['id_purchase_team']),
      encryption: json['encryption'] ?? '',
      teamName: json['team_name'] ?? '',
      teamLeaderName: json['team_leader_name']?.toString(),
      teamLeaderId: leaderId,
      description: json['description'],
      members: memberList,
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }

  static List<PurchaseMemberData> _parseMembers(Map<String, dynamic> json) {
    if (json['members'] is List && (json['members'] as List).isNotEmpty) {
      return (json['members'] as List)
          .map((e) => PurchaseMemberData.fromJson(e))
          .toList();
    }
    if (json['member'] is List) {
      return (json['member'] as List).map((e) {
        final idUser = _parseInt(e['id_user']) ?? 0;
        final karyawan = e['karyawan'];
        final nama = karyawan is Map
            ? karyawan['nama_lengkap']?.toString()
            : null;
        return PurchaseMemberData(idUser: idUser, namaKaryawan: nama);
      }).toList();
    }
    return [];
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class PurchaseMemberData {
  final int idUser;
  final String? namaKaryawan;

  PurchaseMemberData({required this.idUser, this.namaKaryawan});

  factory PurchaseMemberData.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse((json['id_user'] ?? 0).toString()) ?? 0;
    String? nama = json['nama_karyawan']?.toString();
    if (nama == null && json['karyawan'] is Map) {
      nama = json['karyawan']['nama_lengkap']?.toString();
    }
    return PurchaseMemberData(idUser: id, namaKaryawan: nama);
  }
}

class PurchaseTeamDropdownData {
  final List<UserDropdown> users;

  PurchaseTeamDropdownData({required this.users});

  factory PurchaseTeamDropdownData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return PurchaseTeamDropdownData(
      users: (data['users'] as List? ?? [])
          .map((e) => UserDropdown.fromJson(e))
          .toList(),
    );
  }
}

class UserDropdown {
  final int id;
  final String fullName;

  UserDropdown({required this.id, required this.fullName});

  factory UserDropdown.fromJson(Map<String, dynamic> json) => UserDropdown(
        id: int.tryParse((json['id_user'] ?? 0).toString()) ?? 0,
        fullName: json['nama_lengkap'] ?? '',
      );

  @override
  String toString() => fullName;

  @override
  bool operator ==(Object other) =>
      other is UserDropdown && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PurchaseTeamFormModel {
  int? idPurchaseTeam;
  String? encryption;
  String teamName;
  int? teamLeaderId;
  String description;
  List<int> memberIds;
  String? createdDate;
  String? updatedDate;

  PurchaseTeamFormModel({
    this.idPurchaseTeam,
    this.encryption,
    this.teamName = '',
    this.teamLeaderId,
    this.description = '',
    List<int>? memberIds,
    this.createdDate,
    this.updatedDate,
  }) : memberIds = memberIds ?? [];

  factory PurchaseTeamFormModel.fromDetail(PurchaseTeamDetailModel detail) {
    final t = detail.team;
    return PurchaseTeamFormModel(
      idPurchaseTeam: t.idPurchaseTeam,
      encryption: t.encryption,
      teamName: t.teamName,
      teamLeaderId: t.teamLeaderId,
      description: t.description ?? '',
      memberIds: t.members.map((m) => m.idUser).toList(),
      createdDate: t.createdDate,
      updatedDate: t.updatedDate,
    );
  }

  bool isValid() =>
      teamName.trim().isNotEmpty &&
      teamLeaderId != null &&
      memberIds.isNotEmpty;

  Map<String, dynamic> toJson() {
        final memberList = memberIds.map((id) => {'id_user': id}).toList();
        return {
          if (idPurchaseTeam != null) 'id_purchase_team': idPurchaseTeam,
          'team_name': teamName,
          'team_leader': teamLeaderId,
          'description': description.isEmpty ? null : description,
          'members': memberList,
          'member': memberList,
        };
      }
}