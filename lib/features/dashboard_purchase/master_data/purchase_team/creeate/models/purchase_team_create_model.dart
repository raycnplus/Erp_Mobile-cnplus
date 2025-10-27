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
      'members': memberIds.map((id) => {'id_user': id}).toList(),
      // -------------------------
    };
  }
}