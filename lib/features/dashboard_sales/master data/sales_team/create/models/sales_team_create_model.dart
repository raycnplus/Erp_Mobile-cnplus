// Ganti isi file sales_team_create_model.dart

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
      'team_name': teamName, 
      'team_leader': teamLeaderId,
      'description': description,
      'members': memberIds.map((id) => {'id_user': id}).toList(),
    };
  }
}