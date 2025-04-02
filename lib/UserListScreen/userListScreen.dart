import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_bridge/API/apiServices.dart';
import 'package:love_bridge/Database/dbConnection.dart';
import 'package:pdf/pdf.dart';
import '../AddEditScreen/addEditScreen.dart';
import '../AddEditScreen/userModelClass.dart';
import '../utils/constant.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../utils/shimmerEffect.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  String selectedSort = 'Recently Added';
  late Future<List<Map<String, dynamic>>> _userFuture;

  RangeValues _ageRange = RangeValues(18, 80);

  @override
  void initState() {
    super.initState();
    _ageRange = RangeValues(18, 80);
    _userFuture = Future.wait([
      _loadUsers(),
      Future.delayed(const Duration(seconds: 1)),
    ]).then((results) => results[0] as List<Map<String, dynamic>>);
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    // DbConnection dbConnection = DbConnection();
    ApiService apiService = ApiService();
    // List<Map<String, dynamic>> dbusers = await dbConnection.getProfiles();
    List<dynamic> apiusers = await apiService.getUsers();

    List<Map<String, dynamic>> convertedApiUsers =
    apiusers.map((user) => Map<String, dynamic>.from(user)).toList();

    List<Map<String, dynamic>> users = [...convertedApiUsers];
    setState(() {
      allUsers = users;
      filteredUsers = List.from(users);
      _sortUsers();
    });
    return users;
  }

  void _sortUsers() {
    setState(() {
      if (selectedSort == 'Name (A-Z)') {
        filteredUsers.sort((a, b) => a[NAME].compareTo(b[NAME]));
      } else if (selectedSort == 'Name (Z-A)') {
        filteredUsers.sort((a, b) => b[NAME].compareTo(a[NAME]));
      } else if (selectedSort == 'Age (Youngest First)') {
        filteredUsers.sort((a, b) => (int.tryParse(a[AGE].toString()) ?? 0).compareTo(int.tryParse(b[AGE].toString()) ?? 0));
      } else if (selectedSort == 'Age (Oldest First)') {
        filteredUsers.sort((a, b) =>(int.tryParse(b[AGE].toString()) ?? 0).compareTo(int.tryParse(a[AGE].toString()) ?? 0));
      } else {
        filteredUsers.sort((a, b) => b['id'].compareTo(a['id'])); // Recently Added
      }
    });
  }

  //region DatabaseApplyFilters
  // void _applyFilters({String? city, String? gender, int? minAge, int? maxAge}) async {
  //   // DbConnection dbConnection = DbConnection();
  //   ApiService apiService = ApiService();
  //
  //   // Get filtered users from the database
  //   // List<Map<String, dynamic>> dbUsers = await dbConnection.getProfiles();
  //   // List<Map<String, dynamic>> filteredDbUsers = dbUsers.where((user) {
  //   //   bool matchesCity = city == null || user[CITY] == city;
  //   //   bool matchesGender = gender == null || user[GENDER] == gender;
  //   //
  //   //   int userAge = int.parse(user[AGE].toString());
  //   //   bool matchesAge = (minAge == null || userAge >= minAge) &&
  //   //       (maxAge == null || userAge <= maxAge);
  //   //
  //   //   return matchesCity && matchesGender && matchesAge;
  //   // }).toList();
  //
  //   // Get filtered users from the API
  //   List<dynamic> filteredApiUsers = await apiService.filterUsers(
  //       city: city, gender: gender, minAge: minAge, maxAge: maxAge);
  //   List<Map<String, dynamic>> convertedApiUsers = filteredApiUsers
  //       .map((user) => Map<String, dynamic>.from(user))
  //       .toList();
  //
  //   setState(() {
  //     filteredUsers = [...convertedApiUsers];
  //   });
  // }
  //endregion apply

  void _applyFilters({int? minAge, int? maxAge}) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        int userAge = int.tryParse(user[AGE].toString()) ?? 0;
        bool matchesAge = (minAge == null || userAge >= minAge) &&
            (maxAge == null || userAge <= maxAge);
        return matchesAge;
      }).toList();
    });
  }

  void _updateFilteredUsers(String query) async {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((user) {
          String name = user[NAME]?.toString().toLowerCase() ?? '';
          String gender = user[GENDER]?.toString().toLowerCase() ?? '';
          String phone = user[PHONE]?.toString().toLowerCase() ?? '';
          String city = user[CITY]?.toString().toLowerCase() ?? '';
          String email = user[EMAIL]?.toString().toLowerCase() ?? '';
          String age = user[AGE]?.toString().toLowerCase() ?? '';

          return name.contains(query.toLowerCase()) ||
              gender.contains(query.toLowerCase()) ||
              phone.contains(query.toLowerCase()) ||
              city.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase()) ||
              age.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          title: Container(
            width: double.infinity,
            height: 16,
            color: Colors.grey,
          ),
          subtitle: Container(
            width: 100,
            height: 14,
            color: Colors.grey,
          ),
          trailing: Container(
            width: 50,
            height: 30,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _showAgeRangeFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter by Age'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RangeSlider(
                values: _ageRange,
                min: 18,
                max: 80,
                divisions: 31,
                labels: RangeLabels(
                  _ageRange.start.round().toString(),
                  _ageRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _ageRange = values;
                    _applyFilters(minAge: values.start.round(), maxAge: values.end.round());
                  });
                },
              ),
              Text('Age Range: ${_ageRange.start.round()} - ${_ageRange.end.round()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters(
                  minAge: _ageRange.start.round(),
                  maxAge: _ageRange.end.round(),
                );
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Profiles',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade800,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border:
                      Border.all(color: Colors.pinkAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            style: TextStyle(color: Colors.pink.shade900),
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 12),
                              labelText: 'Find your perfect match...',
                              labelStyle: TextStyle(
                                color: Colors.pink.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: 'Search by name, city, email...',
                              hintStyle: TextStyle(color: Colors.pink.shade300),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.pink.shade800,
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.pink.shade800,
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    _updateFilteredUsers('');
                                  });
                                },
                              )
                                  : null,
                              border: InputBorder.none,
                              filled: false,
                            ),
                            onChanged: (value) => _updateFilteredUsers(value),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.pinkAccent.withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.filter_list_rounded,
                              color: Colors.pink.shade800,
                            ),
                            tooltip: 'Sort & Filter',
                            onSelected: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedSort = newValue;
                                  _sortUsers();
                                });
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                _buildSortMenuItem(
                                    'Recently Added', Icons.access_time),
                                _buildSortMenuItem(
                                    'Name (A-Z)', Icons.sort_by_alpha),
                                _buildSortMenuItem(
                                    'Name (Z-A)', Icons.sort_by_alpha),
                                _buildSortMenuItem(
                                    'Age (Youngest First)', Icons.arrow_upward),
                                _buildSortMenuItem(
                                    'Age (Oldest First)', Icons.arrow_downward),
                              ];
                            },
                            offset: Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.pink.shade100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showAgeRangeFilter(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Filter by Age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: 6, // Number of shimmer items
                      itemBuilder: (context, index) {
                        return Shimmer(child: _buildShimmerCard());
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No profiles found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(filteredUsers[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            child: Text(
              user[NAME][0].toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(user[NAME],
              overflow: TextOverflow.ellipsis,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Wrap(children: [
            Expanded(
              child: Text(
                '🎂 : ${user[AGE]} years',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('🚻 : ${user[GENDER]}',
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
            Expanded(
              child: Text(
                '🏠 :  ${user[CITY]}, ${user[COUNTRY]}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  user['is_favorite'] == 1
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: user['is_favorite'] == 1 ? Colors.red : Colors.grey,
                  size: 25,
                ),
                onPressed: () => _toggleFavorite(user),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.pinkAccent),
                onSelected: (String value) {
                  if (value == 'edit') {
                    _editUser(user,user['id'].toString());
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, user);
                  } else if (value == 'print') {
                    _printUserDetails(user);
                  } else if (value == 'share') {
                    _shareUserDetails(user);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'print',
                      child: Row(
                        children: [
                          Icon(Icons.print, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Print'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Share'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          onTap: () {
            _showUserDetails(context, user);
          },
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Header
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    user[GENDER] == 'Male'
                                        ? 'assets/images/male.jpg'
                                        : 'assets/images/female.jpg',
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(user[NAME],
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                SizedBox(height: 8),
                                Text(user[NICK_NAME] ?? '',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // 1. Personal Information
                      _buildSectionCard(
                        title: 'Personal Information',
                        children: [
                          _buildUserInfoRow(
                              Icons.person, "Full Name", user[NAME]),
                          _buildUserInfoRow(Icons.email, "Email", user[EMAIL]),
                          _buildUserInfoRow(Icons.phone, "Phone", user[PHONE]),
                          _buildUserInfoRow(Icons.cake, "DOB", user[DOB]),
                          _buildUserInfoRow(
                              Icons.person_outline, "Gender", user[GENDER]),
                          _buildUserInfoRow(
                              Icons.location_on, "Address", user[ADDRESS]),
                          _buildUserInfoRow(
                              Icons.location_city, "City", user[CITY]),
                          _buildUserInfoRow(
                              Icons.public, "Country", user[COUNTRY]),
                          _buildUserInfoRow(Icons.sports, "Hobbies",
                              user[HOBBY] ?? 'No hobbies listed'),
                        ],
                      ),

                      // 2. Physical Attributes
                      _buildSectionCard(
                        title: 'Physical Attributes',
                        children: [
                          _buildUserInfoRow(
                              Icons.height, "Height", user[HEIGHT]),
                          _buildUserInfoRow(
                              Icons.face, "Complexion", user[COMPLEXION]),
                        ],
                      ),

                      // 3. Education & Career
                      _buildSectionCard(
                        title: 'Education & Career',
                        children: [
                          _buildUserInfoRow(
                              Icons.school, "Education", user[EDUCATION]),
                          _buildUserInfoRow(
                              Icons.work, "Occupation", user[OCCUPATION]),
                          _buildUserInfoRow(Icons.attach_money, "Annual Income",
                              user[ANNUAL_INCOME]),
                        ],
                      ),

                      // 4. Religion/Caste Details
                      _buildSectionCard(
                        title: 'Religion & Caste',
                        children: [
                          _buildUserInfoRow(
                              Icons.temple_hindu, "Religion", user[RELIGION]),
                          _buildUserInfoRow(Icons.group, "Caste", user[CASTE]),
                          _buildUserInfoRow(Icons.language, "Mother Tongue",
                              user[MOTHER_TONGUE]),
                          _buildUserInfoRow(
                              Icons.star, "Nakshatra", user[NAKSHATRA]),
                          _buildUserInfoRow(
                              Icons.psychology, "Rashi", user[RASHI])
                        ],
                      ),

                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: Text('Close',
                            style:
                            TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Column(
      children: [
        SizedBox(height: 15),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent)),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                // style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value ?? 'N/A',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //region DatabaseEditUser
  // void _editUser(Map<String, dynamic> user, String index) async {
  //   Map<String, dynamic>? updatedUser = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddEditScreen(personDetails: user,index: index,),
  //     ),
  //   );
  //
  //   if (updatedUser != null) {
  //     if (updatedUser['id'].runtimeType.toString() == "int") {
  //       // Update in database
  //       DbConnection dbConnection = DbConnection();
  //       await dbConnection.updateProfiles(updatedUser);
  //     } else {
  //       // Update via API
  //       ApiService apiService = ApiService();
  //       await apiService.updateUser(updatedUser['id'], updatedUser);
  //     }
  //
  //     // Refresh users list
  //     _loadUsers();
  //   }
  // }

  void _editUser(Map<String, dynamic> user, String index) async {
    Map<String, dynamic>? updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(personDetails: user, index: index),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        int userIndex = allUsers.indexWhere((element) => element['id'] == user['id']);
        if (userIndex != -1) {
          allUsers[userIndex] = updatedUser;
          filteredUsers = List.from(allUsers);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //region DatabaseDeleteUSer
  // void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> user) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text('Delete'),
  //       content: const Text('Are you sure you want to delete this user?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             if (user['id'].runtimeType.toString() == "int") {
  //               DbConnection dbConnection = DbConnection();
  //               await dbConnection.deleteProfiles(user['id']);
  //             } else {
  //               ApiService apiConnection = ApiService();
  //               await apiConnection.deleteUser(user['id']);
  //             }
  //
  //             setState(() {
  //               filteredUsers
  //                   .removeWhere((element) => element['id'] == user['id']);
  //             });
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Profile deleted successfully!'),
  //                 backgroundColor: Colors.green,
  //                 duration: Duration(milliseconds: 500),
  //                 behavior: SnackBarBehavior.floating,
  //               ),
  //             );
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Yes', style: TextStyle(color: Colors.red)),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('No', style: TextStyle(color: Colors.blue)),
  //         )
  //       ],
  //     ),
  //   );
  // }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                if (user['id'].runtimeType.toString() == "int") {
                  DbConnection dbConnection = DbConnection();
                  await dbConnection.deleteProfiles(user['id']);
                } else {
                  ApiService apiService = ApiService();
                  apiService.deleteUser(user['id']);
                }

                setState(() {
                  allUsers.removeWhere((element) => element['id'] == user['id']);
                  filteredUsers = List.from(allUsers);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile deleted successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 500),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                if (allUsers.isEmpty) {
                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete profile: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> user) async {
    Map<String, dynamic> updatedUser = Map<String, dynamic>.from(user);
    updatedUser['is_favorite'] = updatedUser['is_favorite'] == 1 ? 0 : 1;

    if (updatedUser['id'].runtimeType.toString() == "int") {
      // Update in database
      DbConnection dbConnection = DbConnection();
      await dbConnection.updateProfiles(
          {'id': updatedUser['id'], 'is_favorite': updatedUser['is_favorite']});
    } else {
      // Update via API
      ApiService apiService = ApiService();
      apiService.toggleFavoriteStatus(
          updatedUser['id'], updatedUser['is_favorite']);
    }

    setState(() {
      int index = filteredUsers
          .indexWhere((element) => element['id'] == updatedUser['id']);
      if (index != -1) {
        filteredUsers[index] = updatedUser;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(updatedUser['is_favorite'] == 1
            ? '${updatedUser[NAME]} added to favorites'
            : '${updatedUser[NAME]} removed from favorites'),
        backgroundColor:
        updatedUser['is_favorite'] == 1 ? Colors.green : Colors.red,
        duration: Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String title, IconData icon) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.pink.shade800, size: 20),
          SizedBox(width: 12),
          Text(title,
              style: TextStyle(
                  color: Colors.pink.shade900,
                  fontWeight: title == selectedSort
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ],
      ),
    );
  }

  void  _shareUserDetails(Map<String, dynamic> user) {

    String shareText = '''
    📌 *Profile Details*

    👤 *Name:* ${user[NAME]}
    ✉️ *Email:* ${user[EMAIL]}
    📞 *Phone:* ${user[PHONE]}
    🎂 *DOB:* ${user[DOB]}
    🚻 *Gender:* ${user[GENDER]}
    🏠 *Address:* ${user[ADDRESS]}, ${user[CITY]}, ${user[COUNTRY]}
    🎨 *Hobbies:* ${user[HOBBY] ?? 'No hobbies listed'}
    📏 *Height:* ${user[HEIGHT]}
    🎭 *Complexion:* ${user[COMPLEXION]}
    🎓 *Education:* ${user[EDUCATION]}
    💼 *Occupation:* ${user[OCCUPATION]}
    💰 *Annual Income:* ${user[ANNUAL_INCOME]}
    🛕 *Religion:* ${user[RELIGION]}
    🏷️ *Caste:* ${user[CASTE]}
    🗣️ *Mother Tongue:* ${user[MOTHER_TONGUE]}
    🌟 *Nakshatra:* ${user[NAKSHATRA]}
    ♈ *Rashi:* ${user[RASHI]}
    ''';

    Share.share(shareText);
  }

  void _printUserDetails(Map<String, dynamic> user) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                  level: 0,
                  child: pw.Text('User Details',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20),
              _buildPdfUserInfoRow('Full Name', user[NAME]),
              _buildPdfUserInfoRow('Email', user[EMAIL]),
              _buildPdfUserInfoRow('Phone', user[PHONE]),
              _buildPdfUserInfoRow('DOB', user[DOB]),
              _buildPdfUserInfoRow('Gender', user[GENDER]),
              _buildPdfUserInfoRow('Address', user[ADDRESS]),
              _buildPdfUserInfoRow('City', user[CITY]),
              _buildPdfUserInfoRow('Country', user[COUNTRY]),
              _buildPdfUserInfoRow(
                  'Hobbies', user[HOBBY] ?? 'No hobbies listed'),
              _buildPdfUserInfoRow('Height', user[HEIGHT]),
              _buildPdfUserInfoRow('Complexion', user[COMPLEXION]),
              _buildPdfUserInfoRow('Education', user[EDUCATION]),
              _buildPdfUserInfoRow('Occupation', user[OCCUPATION]),
              _buildPdfUserInfoRow('Annual Income', user[ANNUAL_INCOME]),
              _buildPdfUserInfoRow('Religion', user[RELIGION]),
              _buildPdfUserInfoRow('Caste', user[CASTE]),
              _buildPdfUserInfoRow('Mother Tongue', user[MOTHER_TONGUE]),
              _buildPdfUserInfoRow('Nakshatra', user[NAKSHATRA]),
              _buildPdfUserInfoRow('Rashi', user[RASHI]),
            ],
          );
        },
      ),
    );

    // Save the PDF document to a byte array
    final pdfBytes = await pdf.save();

    // Print or share the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => pdfBytes,
    );
  }

  pw.Widget _buildPdfUserInfoRow(String label, String? value) {
    return pw.Row(
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value ?? 'N/A'),
      ],
    );
  }
}