class ProductCreateModel {
  final String productName;
  final String productCode;
  final int productTypeId;
  final int productCategoryId;
  final int productBrandId;
  final int unitOfMeasureId;
  final double salesPrice;
  final double costPrice;
  final String barcode;
  final String tracking;
  final String note;

  ProductCreateModel({
    required this.productName,
    required this.productCode,
    required this.productTypeId,
    required this.productCategoryId,
    required this.productBrandId,
    required this.unitOfMeasureId,
    required this.salesPrice,
    required this.costPrice,
    required this.barcode,
    required this.tracking,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_name": productName,
      "product_code": productCode,
      "product_type_id": productTypeId,
      "product_category_id": productCategoryId,
      "product_brand_id": productBrandId,
      "uom_id": unitOfMeasureId,
      "sales_price": salesPrice,
      "cost_price": costPrice,
      "barcode": barcode,
      "tracking": tracking,
      "note_detail": note,
    };
  }
} 


class DropdownProductType {
  final int id;
  final String name;

  DropdownProductType({
    required this.id,
    required this.name,
  });

  factory DropdownProductType.fromJson(Map<String, dynamic> json) {
    return DropdownProductType(
      id: json['id_product_type'],
      name: json['product_type_name'],
    );
  }
}

class DropdownProductCategory {
  final int id;
  final String name;

  DropdownProductCategory({
    required this.id,
    required this.name,
  });

  factory DropdownProductCategory.fromJson(Map<String, dynamic> json) {
    return DropdownProductCategory(
      id: json['id_product_category'],
      name: json['product_category_name'],
    );
  }
}

class DropdownProductBrand {
  final int id;
  final String name;

  DropdownProductBrand({
    required this.id,
    required this.name,
  });

  factory DropdownProductBrand.fromJson(Map<String, dynamic> json) {
    return DropdownProductBrand(
      id: json['id_brand'],
      name: json['brand_name'],
    );
  }
}

class DropdownUnitOfMeasure {
  final int id;
  final String name;

  DropdownUnitOfMeasure({
    required this.id,
    required this.name,
  });

  factory DropdownUnitOfMeasure.fromJson(Map<String, dynamic> json) {
    return DropdownUnitOfMeasure(
      id: json['id_unit_of_measure'],
      name: json['unit_of_measure_name'],
    );
  }
}