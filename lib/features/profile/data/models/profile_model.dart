import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.email,
    super.imageUrl,
    super.position,
    super.department,
    super.idRole,    
    super.roleName,  
    super.roleLevel, 
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id:         json['id_user'] != null ? int.tryParse(json['id_user'].toString()) ?? 0 : 0,
      username:   json['username'] ?? '',
      fullName:   json['nama_lengkap'] ?? 'Tanpa Nama',
      email:      json['email'] ?? 'Tanpa Email',
      imageUrl:   (json['image'] != null && json['image'].toString().isNotEmpty)
                    ? json['image']
                    : null,
      position:   json['position_name'],
      department: json['department_name'],
      idRole:     json['id_role'] != null ? int.tryParse(json['id_role'].toString()) : null,
      roleName:   json['role_name'] as String?,
      roleLevel:  json['role_level'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_user':        id,
    'username':       username,
    'nama_lengkap':   fullName,
    'email':          email,
    'image':          imageUrl,
    'position_name':  position,
    'department_name':department,
    'id_role':        idRole,    
    'role_name':      roleName,  
    'role_level':     roleLevel, 
  };
}