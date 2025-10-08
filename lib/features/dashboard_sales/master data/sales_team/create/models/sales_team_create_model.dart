class SalesTeamCreateModel {
  final String teamName;
  final int teamLeaderId;
  final String description;
  final List<int> memberIds;

  SalesTeamCreateModel({
    required this.teamName,
    required this.teamLeaderId,
    required this.description,
    required this.memberIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName, // Changed key from 'purchase_team_name' to 'team_name'
      'team_leader': teamLeaderId,
      'description': description,
      // The member list structure matches the example JSON
      'members': memberIds.map((id) => {'id_karyawan': id}).toList(),
    };
  }
}