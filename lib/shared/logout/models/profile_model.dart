// lib/shared/models/profile_model.dart

class Profile {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String? imageUrl;
  final String? position;
  final String? department;

  Profile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.position,
    this.department,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      // [DIUBAH] Ambil 'id_user' dan beri nilai default jika null
      id: json['id_user'] ?? 0,
      
      // [DIUBAH] Ambil 'username' dan 'nama_lengkap'
      username: json['username'] ?? '',
      fullName: json['nama_lengkap'] ?? 'Tanpa Nama',
      
      // [DIUBAH] Ambil 'email'
      email: json['email'] ?? 'Tanpa Email',
      
      // [DIUBAH] Cek 'image', jika string kosong "" jadikan null
      imageUrl: (json['image'] != null && json['image'].isNotEmpty) 
                  ? json['image'] 
                  : null,
      
      // [DIUBAH] Ambil 'position_name' dan 'department_name' (keduanya nullable)
      position: json['position_name'],
      department: json['department_name'],
    );
  }
}