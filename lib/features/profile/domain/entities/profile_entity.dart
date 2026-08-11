class ProfileEntity {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String? imageUrl;
  final String? position;
  final String? department;
  final int? idRole;      
  final String? roleName; 
  final String? roleLevel;

  ProfileEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.position,
    this.department,
    this.idRole,    
    this.roleName,  
    this.roleLevel, 
  });

  bool get isSuperAdmin => roleLevel == 'SA';
  bool get isAdmin => roleLevel == 'Administrator';
  bool get isUser => roleLevel == 'User';
}