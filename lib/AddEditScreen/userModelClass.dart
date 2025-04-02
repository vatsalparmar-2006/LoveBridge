import "package:flutter/foundation.dart";
import "../utils/constant.dart";

class UserModelClass {
  static List<Map<String, dynamic>> userList = [
    {
      NAME: 'Vatsal Parmar',
      EMAIL: 'vats@gmail.com',
      PHONE: '1234567890',
      DOB: '2003-12-15',
      COUNTRY: 'India',
      CITY: 'Rajkot',
      GENDER: 'Male',
      HOBBY: ['Cricket'],
      AGE: '26',
      HEIGHT: '5.4',
      OCCUPATION: 'B.tech - CSE',
      RELIGION: '',
      CASTE: '',
      'is_favorite': false
    },
    {
      NAME: 'John Doe',
      EMAIL: 'john@gmail.com',
      PHONE: '9876543210',
      DOB: '1995-05-20',
      COUNTRY: 'India',
      CITY: 'Ahmedabad',
      GENDER: 'Male',
      HOBBY: ['Reading', 'Traveling'],
      AGE: '28',
      'is_favorite': false
    },
    {
      NAME: 'Jane Smith',
      EMAIL: 'jane@gmail.com',
      PHONE: '5555555555',
      DOB: '1998-09-10',
      COUNTRY: 'India',
      CITY: 'Surat',
      GENDER: 'Female',
      HOBBY: ['Music', 'Sports'],
      AGE: '25',
      'is_favorite': false
    }
  ];

  void toggleFavorite(int id) {
    userList[id][IS_FAVORITE] = !userList[id][IS_FAVORITE];
    print('Favorite status toggled for ID $id');
  }

  List<Map<String, dynamic>> getFavorites() {
    return userList.where((user) => user[IS_FAVORITE] == true).toList();
  }

  void addLifeMate(
      {required String fullName,
      required email,
      required phone,
      required dob,
      required city,
      required gender,
      required hobbies,
      int? age}) {
    Map<String, dynamic> map = {};
    map[NAME] = fullName;
    map[EMAIL] = email;
    map[PHONE] = phone;
    map[DOB] = dob;
    map[CITY] = city;
    map[GENDER] = gender;
    map[HOBBY] = hobbies;
    map[AGE] = age.toString();
    map[IS_FAVORITE] = false;

    userList.add(map);
    print('User added successfully.\n');
  }

  void updateUser(
      {required int id,
      String? newName,
      newEmail,
      newPhone,
      newDob,
      newCity,
      newGender,
      newHobbies}) {
    for (dynamic i in userList) {
      if (i[ID] == id) {
        i[NAME] = newName;
        i[EMAIL] = newEmail;
        i[PHONE] = newPhone;
        i[DOB] = newDob;
        i[CITY] = newCity;
        i[GENDER] = newGender;
        i[HOBBY] = newHobbies;
        print('User with ID $id updated successfully.\n');
        return;
      }
    }
    print("Error: User with ID $id not found.\n");
  }

  void deleteUser({required int id}) {
    for (dynamic i in userList) {
      if (i[ID] == id) {
        userList.remove(i);
        print('User with ID $id deleted successfully.\n');
        return;
      }
    }
    if (kDebugMode) {
      print("Error: User with ID $id not found.\n");
    }
  }

  List<Map<String, dynamic>> displayUser() {
    if (userList.isEmpty) {
      print('No lifeMate(s) available.\n');
    }
    return userList;
  }

  List<Map<String, dynamic>> searchLifeMate(String searchData) {
    var data =  userList.where((lover) {
      return lover[NAME]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          lover[PHONE]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          lover[CITY]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          lover[EMAIL]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase()) ||
          lover[AGE]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase());
    }).toList();
    print(data);
    return data;
  }
}
