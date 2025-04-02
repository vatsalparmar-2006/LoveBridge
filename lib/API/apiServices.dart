import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constant.dart';

class ApiService {
  String baseUrl = "API Here...";

  Future<List<dynamic>> getUsers() async {
    var res = await http.get(Uri.parse(baseUrl));
    print(res.body);
    if (res.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(res.body);
      // _parseUserId(jsonData);
      return jsonData;
    }
    return [];
  }

  // void _parseUserId(List userList){
  //   for(var user in userList){
  //     if(user[DbConnection.ID]){
  //       user[DbConnection.ID] = int.parse(user[DbConnection.ID]);
  //     }
  //   }
  // }

  Future<void> addUser(Map<String,dynamic> map) async {

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      print('Post successful');
      getUsers();
    } else {
      print('Failed to post');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if(response.statusCode==200){
      print("delete succfully");
    }else{
      print("error :: :");
    }
    getUsers();
  }

  Future<void> updateUser(String id, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
      } else {
        print('Failed to update user: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  int _calculateAge(String date) {
    DateTime dob = DateTime.parse(date);
    DateTime today = DateTime.now();
    int age = today.year - dob.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> toggleFavoriteStatus(String id, int isFavorite) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'is_favorite': isFavorite}),
      );

      if (response.statusCode == 200) {
        print('Favorite status updated successfully');
      } else {
        print('Failed to update favorite status: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating favorite status: $error');
    }
  }

  Future<List<dynamic>> filterUsers({String? city, String? gender, int? minAge, int? maxAge}) async {
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);

        // Filter users
        List<dynamic> filteredUsers = users.where((user) {
          bool matchesCity = city == null || user[CITY] == city;
          bool matchesGender = gender == null || user[GENDER] == gender;

          int userAge = _calculateAge(user[DOB]);
          bool matchesAge = (minAge == null || userAge >= minAge) && (maxAge == null || userAge <= maxAge);

          return matchesCity && matchesGender && matchesAge;
        }).toList();

        return filteredUsers;
      }
    } catch (error) {
      print("Error fetching users: $error");
    }
    return [];
  }

  Future<List<dynamic>> getSortedUsers(String sortBy, bool ascending) async {
    try {
      String order = ascending ? "asc" : "desc";
      var response = await http.get(Uri.parse('$baseUrl?sortBy=$sortBy&order=$order'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (error) {
      print("Error fetching sorted users: $error");
    }
    return [];
  }
}
