
class CategoryModel{
  String name = '';
  String image = '';

  CategoryModel({
    required this.name,
    required this.image,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}

class ProductModel{
  String id = '';
  String name = '';
  int price = 0;
  String brand = '';
  String image = '';
  String created = '';
  String sku = '';
  int discount = 0;
  String? size = '';
  List<CategoryModel>? category = [];
  bool isNew = true;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.brand,
    required this.image,
    required this.created,
    required this.isNew,
    required this.discount,
    required this.sku,
    this.size,
    this.category,

  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    brand = json['brand'];
    image = json['image'];
    created = json['created'];
    sku = json['sku'];
    size = json['size'];
    discount = json['discount'];
    isNew = json['isNew'];
    if (json['category'] != null) {
      category?.clear();
      json['category'].forEach((v) {
        category?.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'brand': brand,
    'image': image,
    'created': created,
    'isNew': isNew,
    'discount': discount,
    'sku': sku,
    'size': size,
    'category': category,
  };
}

// List categoryList = [
//   {
//     'name': 'Fashion & Beauty',
//     'image': 'assets/icons/fashion.png',
//     'subCategory': [
//       {'name': 'Pants', 'image': 'assets/icons/fashion-jeans.png'},
//       {'name': 'Heels', 'image': 'assets/icons/fashion-heels.png'},
//       {'name': 'Jackets', 'image': 'assets/icons/fashion-jackets.png'},
//       {'name': 'Shades', 'image': 'assets/icons/fashion-glasses.png'},
//       {'name': 'Caskets', 'image': 'assets/icons/fashion-hat.png'},
//       {'name': 'Sneakers', 'image': 'assets/icons/fashion-sneakers.png'},
//       {'name': 'Woman', 'image': 'assets/icons/fashion-woman.png'},
//       {'name': 'Kids', 'image': 'assets/icons/fashion-kids.png'},
//       {'name': 'Man', 'image': 'assets/icons/fashion-man.png'},
//
//     ],
//   },
//
//   {
//     'name': 'Mobile Phone',
//     'image': 'assets/icons/phone.png',
//     'subCategory': [
//       {'name': 'Android', 'image': 'assets/icons/phone-android.png'},
//       {'name': 'iOS', 'image': 'assets/icons/phone-iphone.png'},
//       {'name': 'Windows', 'image': 'assets/icons/phone-window.png'},
//     ],
//   },
//
//   {
//     'name': 'Personal Computer',
//     'image': 'assets/icons/computer.png',
//     'subCategory': [
//       {'name': 'Desktop', 'image': 'assets/icons/computer-desktop.png'},
//       {'name': 'Laptop', 'image': 'assets/icons/computer-laptop.png'},
//       {'name': 'Microcontroller', 'image': 'assets/icons/computer-micro.png'},
//     ],
//   },
//
//   {
//     'name': 'Console & PDA',
//     'image': 'assets/icons/console.png',
//     'subCategory': [
//       {'name': 'PlayStation', 'image': 'assets/icons/console-playstation.png'},
//       {'name': 'XBox', 'image': 'assets/icons/console-xbox.png'},
//       {'name': 'Nintendo', 'image': 'assets/icons/console-nintendo.png'},
//     ],
//   },
//
//   {
//     'name': 'Gadget & Accessory',
//     'image': 'assets/icons/accessory-smart-watch.png',
//     'subCategory': [
//       {'name': 'AirPod', 'image': 'assets/icons/accessory-airpod.png'},
//       {'name': 'Charger', 'image': 'assets/icons/accessory-charger.png'},
//       {'name': 'HeadPhone', 'image': 'assets/icons/accessory-headphone.png'},
//       {'name': 'SmartWatch', 'image': 'assets/icons/accessory-smart-watch.png'},
//     ],
//   },
//
// ];
//
// List productList = [
//
//   {
//     'id': 'White Air Max',
//     'name': 'White Air Max',
//     'price': 21000,
//     'brand': 'Air Max',
//     'image': 'assets/images/image1.webp',
//     'created': '${DateTime.now()}',
//     'quantity': 13,
//     'discount': 0,
//     'sku': 'W5IMA5',
//     'isNew': true,
//     'color':  ['White', 'Black'],
//     'size':  ['41', '43', '44'],
//     'category': [
//       {
//         'name': 'Fashion & Beauty',
//         'image': 'assets/icons/fashion-jeans.png',
//         'subCategory': [
//           {
//             'name': 'Sneakers',
//             'image': 'assets/icons/fashion-sneakers.png',
//           }
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'Outing Tight Pant',
//     'price': 8000,
//     'brand': 'Jeans',
//     'image': 'assets/images/image2.jpeg',
//     'created': '${DateTime.now()}',
//     'quantity': 34,
//     'sku': 'OI78RG',
//     'color':  ['Blue', 'Black'],
//     'size':  ['M', 'XL', 'XXL'],
//     'discount': 0,
//     'isNew': true,
//     'category': [
//       {
//         'name': 'Fashion & Beauty',
//         'image': 'assets/icons/fashion.png',
//         'subCategory': [
//           {
//             'name': 'Pants',
//             'image': 'assets/icons/fashion-jeans.png',
//           },
//           {
//             'name': 'Woman',
//             'image': 'assets/icons/fashion-woman.png',
//           },
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'Sport Jordan Air',
//     'price': 42000,
//     'brand': 'Sneaker',
//     'image': 'assets/images/image3.webp',
//     'created': '${DateTime.now()}',
//     'quantity': 8,
//     'sku': 'M24DP2',
//     'color':  ['Purple'],
//     'size':  ['40', '41'],
//     'discount': 12,
//     'isNew': true,
//     'category': [
//       {
//         'name': 'Fashion & Beauty',
//         'image': 'assets/icons/fashion.png',
//         'subCategory': [
//           {
//             'name': 'Sneakers',
//             'image': 'assets/icons/fashion-sneakers.png',
//           }
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'Designer Party Pant',
//     'price': 12000,
//     'brand': 'Jeans',
//     'image': 'assets/images/image4.jpg',
//     'created': '${DateTime.now()}',
//     'quantity': 28,
//     'sku': 'EWT0P2',
//     'color':  ['Black', 'Brown'],
//     'size':  ['S', 'M', 'XL'],
//     'discount': 0,
//     'isNew': true,
//     'category': [
//       {
//         'name': 'Fashion & Beauty',
//         'image': 'assets/icons/fashion.png',
//         'subCategory': [
//           {
//             'name': 'Pants',
//             'image': 'assets/icons/fashion-jeans.png',
//           },
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'Polar Outdoor Jacket',
//     'price': 4000,
//     'brand': 'Jacket',
//     'image': 'assets/images/image5.jpg',
//     'created': '${DateTime.now()}',
//     'quantity': 5,
//     'sku': 'PO5HG2',
//     'color':  ['Green'],
//     'size':  ['XL'],
//     'discount': 0,
//     'isNew': true,
//     'category': [
//       {
//         'name': 'Fashion & Beauty',
//         'image': 'assets/icons/fashion.png',
//         'subCategory': [
//           {
//             'name': 'Jackets',
//             'image': 'assets/icons/fashion-jackets.png',
//           },
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'iPhone 13 Pro Max',
//     'price': 803000,
//     'brand': 'Apple',
//     'image': 'assets/images/image7.jpg',
//     'created': '${DateTime.now()}',
//     'quantity': 11,
//     'sku': 'DQ14M5',
//     'isNew': true,
//     'color':  ['Blue'],
//     'size':  ['N/A'],
//     'discount': 0,
//     'category': [
//       {
//         'name': 'Mobile Phone',
//         'image': 'assets/icons/phone.png',
//         'subCategory': [
//           {
//             'name': 'iOS',
//             'image': 'assets/icons/phone-iphone.png',
//           },
//         ],
//       }
//     ]
//   },
//
//   {
//     'name': 'Dell Probook Laptop',
//     'price': 210000,
//     'brand': 'Dell',
//     'image': 'assets/images/image8.jpg',
//     'created': '${DateTime.now()}',
//     'quantity': 33,
//     'sku': 'BHA74E',
//     'color':  ['Black', 'White', 'Red'],
//     'size':  ['N/A'],
//     'discount': 25,
//     'isNew': false,
//     'category': [
//       {
//         'name': 'Personal Computer',
//         'image': 'assets/icons/computer.png',
//         'subCategory': [
//           {
//             'name': 'Laptop',
//             'image': 'assets/icons/computer-laptop.png',
//           },
//         ],
//       }
//     ]
//   },

//];
