

class PurchaseTeamShowModel {
  final int id;
  final String teamName;
  final String teamLeaderName;
  final String description;
  final String createdDate;
  final String createdBy;
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
    
    final List<dynamic> memberList = json['member'] ?? [];
    
    
    final List<String> memberNames = memberList.map<String?>((item) {
      final karyawanData = item?['karyawan'];
      if (karyawanData is Map) {
        return karyawanData['nama_lengkap'] as String?;
      }
      return null;
    }).whereType<String>().toList(); // Filter nilai null dan 

    return PurchaseTeamShowModel(
      id: json['id_purchase_team'] ?? 0,
      teamName: json['team_name'] ?? 'No Name',
      teamLeaderName: json['team_leader'] is Map
          ? json['team_leader']['nama_lengkap'] ?? 'No Leader'
          : json['team_leader'] ?? 'No Leader',
      description: json['description'] ?? '',
      createdDate: json['created_on'] ?? '-',
      createdBy: (json['created_by'] ?? 'Unknown').toString(),
      
      //  parsing 
      memberNames: memberNames,
    );
  }
}