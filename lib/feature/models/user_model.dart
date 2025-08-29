class UserDetails {
  final String userId;
  final String? clinicId;
  final String? doctorId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? contactNo;

  UserDetails({
    required this.userId,
    this.clinicId,
    this.doctorId,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNo,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'] ?? '',
      clinicId: json['clinicId'],
      doctorId: json['doctorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      contactNo: json['contactNo'],
    );
  }
}
class Menu {
  final int menuId;
  final String menuName;
  final String menuIcon;
  final String controllerName;

  Menu({
    required this.menuId,
    required this.menuName,
    required this.menuIcon,
    required this.controllerName,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuId: json['menuId'],
      menuName: json['menuName'] ?? '',
      menuIcon: json['menuIcon'] ?? '',
      controllerName: json['controllerName'] ?? '',
    );
  }
}

class Module {
  final int moduleId;
  final String moduleName;
  final List<Menu> menus;

  Module({required this.moduleId, required this.moduleName, required this.menus});

  factory Module.fromJson(Map<String, dynamic> json) {
    final menus = (json['menus'] as List).map((e) => Menu.fromJson(e)).toList();
    return Module(
      moduleId: json['moduleId'],
      moduleName: json['moduleName'] ?? '',
      menus: menus,
    );
  }
}

class LoginResponse {
  final String accessToken;
  final UserDetails userDetails;
  final List<Module> menuData;

  LoginResponse({
    required this.accessToken,
    required this.userDetails,
    required this.menuData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      userDetails: UserDetails.fromJson(json['userDetails']),
      menuData: (json['menuData'] as List).map((e) => Module.fromJson(e)).toList(),
    );
  }
}
