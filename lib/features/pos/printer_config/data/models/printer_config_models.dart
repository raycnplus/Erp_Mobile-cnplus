int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

bool _pb(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is int) return v == 1;
  final s = v.toString().toLowerCase();
  return s == '1' || s == 'true';
}

class PrinterConfigModel {
  final int id;
  final String printerName;
  final String? description;
  final bool isDefault;

  PrinterConfigModel({
    required this.id,
    required this.printerName,
    this.description,
    this.isDefault = false,
  });

  factory PrinterConfigModel.fromJson(Map<String, dynamic> j) => PrinterConfigModel(
        id:          _pi(j['id']),
        printerName: _ps(j['printer_name']),
        description: j['description']?.toString(),
        isDefault:   _pb(j['is_default']),
      );
}

class PrinterPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  PrinterPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class PrinterConfigFormModel {
  int? id;
  String printerName;
  String? description;
  bool isDefault;

  PrinterConfigFormModel({
    this.id,
    this.printerName = '',
    this.description,
    this.isDefault = false,
  });

  bool get isEditMode => id != null;

  Map<String, dynamic> toJson() => {
        'printer_name': printerName,
        'description':  description,
        'isdefault':    isDefault,
      };

  factory PrinterConfigFormModel.fromModel(PrinterConfigModel p) => PrinterConfigFormModel(
        id:          p.id,
        printerName: p.printerName,
        description: p.description,
        isDefault:   p.isDefault,
      );
}