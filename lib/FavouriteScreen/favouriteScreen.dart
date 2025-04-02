import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_bridge/utils/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import '../API/apiServices.dart';
import '../AddEditScreen/addEditScreen.dart';
import '../Database/dbConnection.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/shimmerEffect.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> allFavorites = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  String selectedSort = 'Recently Added';
  late Future<void> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
  }

  //region DatabaseLoadUser
  // Future<void> _loadFavorites() async {
  //   DbConnection dbConnection = DbConnection();
  //   ApiService apiService = ApiService();
  //
  //   List<Map<String, dynamic>> dbUsers = await dbConnection.getProfiles();
  //   List<dynamic> apiUsers = await apiService.getUsers();
  //   List<Map<String, dynamic>> convertedApiUsers =
  //   apiUsers.map((user) => Map<String, dynamic>.from(user)).toList();
  //
  //   // Filter only favorite users
  //   List<Map<String, dynamic>> allUsers = [...dbUsers, ...convertedApiUsers];
  //   setState(() {
  //     allFavorites = allUsers.where((user) => user['is_favorite'] == 1).toList();
  //     filteredUsers = List.from(allFavorites);
  //     _sortUsers();
  //   });
  // }

  Future<List<Map<String, dynamic>>> _loadFavorites() async {
    ApiService apiService = ApiService();
    List<dynamic> apiusers = await apiService.getUsers();

    List<Map<String, dynamic>> convertedApiUsers =
        apiusers.map((user) => Map<String, dynamic>.from(user)).toList();

    List<Map<String, dynamic>> favoriteUsers =
        convertedApiUsers.where((user) => user['is_favorite'] == 1).toList();

    setState(() {
      allFavorites = favoriteUsers;
      filteredUsers = List.from(favoriteUsers);
      _sortUsers();
    });
    return favoriteUsers;
  }

  void _updateFilteredUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allFavorites);
      } else {
        filteredUsers = allFavorites.where((user) {
          String name = user[NAME]?.toString().toLowerCase() ?? '';
          String gender = user[NAME]?.toString().toLowerCase() ?? '';
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
      _sortUsers();
    });
  }

  void _sortUsers() {
    setState(() {
      if (selectedSort == 'Name (A-Z)') {
        filteredUsers.sort((a, b) => a[NAME].compareTo(b[NAME]));
      } else if (selectedSort == 'Name (Z-A)') {
        filteredUsers.sort((a, b) => b[NAME].compareTo(a[NAME]));
      } else if (selectedSort == 'Age (Youngest First)') {
        filteredUsers.sort((a, b) => (int.tryParse(a[AGE].toString()) ?? 0)
            .compareTo(int.tryParse(b[AGE].toString()) ?? 0));
      } else if (selectedSort == 'Age (Oldest First)') {
        filteredUsers.sort((a, b) => (int.tryParse(b[AGE].toString()) ?? 0)
            .compareTo(int.tryParse(a[AGE].toString()) ?? 0));
      } else {
        filteredUsers
            .sort((a, b) => b['id'].compareTo(a['id'])); // Recently Added
      }
    });
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          title: Container(
            width: double.infinity,
            height: 16,
            color: Colors.grey[300],
          ),
          subtitle: Container(
            width: 100,
            height: 14,
            color: Colors.grey[300],
          ),
          trailing: Container(
            width: 50,
            height: 30,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Matches'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          labelText: 'Search Favorites',
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Search by name, city, profession...',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.white),
                                  onPressed: () {
                                    searchController.clear();
                                    _updateFilteredUsers('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                        ),
                        onChanged: _updateFilteredUsers,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        icon:
                            const Icon(Icons.filter_list, color: Colors.white),
                        tooltip: 'Sort & Filter',
                        onSelected: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSort = newValue;
                              _sortUsers();
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          _buildSortMenuItem(
                              'Recently Added', Icons.access_time),
                          _buildSortMenuItem('Name (A-Z)', Icons.sort_by_alpha),
                          _buildSortMenuItem('Name (Z-A)', Icons.sort_by_alpha),
                          _buildSortMenuItem(
                              'Age (Youngest First)', Icons.arrow_upward),
                          _buildSortMenuItem(
                              'Age (Oldest First)', Icons.arrow_downward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: _favoritesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: 6, // Number of shimmer placeholders
                      itemBuilder: (context, index) {
                        return Shimmer(child: _buildShimmerCard());
                      },
                    );
                  } else if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No favorite matches yet!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(index);
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

  PopupMenuItem<String> _buildSortMenuItem(String title, IconData icon) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.pink.shade800),
          const SizedBox(width: 12),
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

  void _showConfirmDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Remove from Favorites'),
        content: const Text(
            'Are you sure you want to remove this user from favorites?'),
        actions: [
          TextButton(
            onPressed: () async {
              // Create a new mutable map from the original read-only map
              Map<String, dynamic> updatedUser =
                  Map<String, dynamic>.from(user);

              // Update favorite status
              updatedUser['is_favorite'] = 0;

              // Update the database
              DbConnection dbConnection = DbConnection();
              await dbConnection
                  .updateProfiles({'id': updatedUser['id'], 'is_favorite': 0});

              // Remove from UI list
              setState(() {
                filteredUsers.removeWhere(
                    (element) => element['id'] == updatedUser['id']);
              });

              // Close the dialog
              Navigator.pop(context);

              // Show confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${updatedUser[NAME]} removed from favorites'),
                  backgroundColor: Colors.pink[200],
                  duration: Duration(milliseconds: 500),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(int index) {
    final user = filteredUsers[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: Colors.white.withOpacity(0.9),
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
              child: Text('🎂 : ${user[AGE]} years',
                  style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ),
            Text(
              '🚻 : ${user[GENDER]}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
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
                  Icons.favorite,
                  color: Colors.red.shade700,
                  size: 28,
                ),
                onPressed: () => _showConfirmDialog(context, user),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.pinkAccent),
                onSelected: (String value) {
                  if (value == 'edit') {
                    _editUser(user as Map<String, dynamic>, index as String);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(
                        context, user as Map<String, dynamic>);
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
          onTap: () => _showUserDetails(context, user),
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
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
                                backgroundColor: Colors.pinkAccent,
                                child: Text(
                                  user[NAME][0].toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                        _buildUserInfoRow(Icons.height, "Height", user[HEIGHT]),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Close',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value ?? '',
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
  // void _editUser(int index) async {
  //   final user = filteredUsers[index];
  //   var result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => AddEditScreen(personDetails: user),
  //       ));
  //
  //   if (result != null) {
  //     // Find the index of the user in the main list
  //     int mainIndex =
  //     UserModelClass.userList.indexWhere((u) => u[NAME] == user[NAME]);
  //     if (mainIndex != -1) {
  //       // Update the user in the main list
  //       UserModelClass.userList[mainIndex] = result;
  //     }
  //
  //     // Update the filtered list
  //     setState(() {
  //       filteredUsers[index] = result;
  //     });
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
      ApiService apiService = ApiService();
      await apiService.updateUser(
          updatedUser['id'], updatedUser); // Save to API

      setState(() {
        int userIndex =
            allFavorites.indexWhere((element) => element['id'] == user['id']);
        if (userIndex != -1) {
          allFavorites[userIndex] = updatedUser;
        }

        int filteredIndex =
            filteredUsers.indexWhere((element) => element['id'] == user['id']);
        if (filteredIndex != -1) {
          filteredUsers[filteredIndex] = updatedUser;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //region DatabseDeleteConfirtion
  // void _showDeleteConfirmation(BuildContext context, int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       title: const Text('Delete'),
  //       content: const Text('Are you sure you want to delete this user?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             // Remove the user from the main list
  //             UserModelClass.userList
  //                 .removeWhere((u) => u[NAME] == filteredUsers[index][NAME]);
  //
  //             // Remove the user from the filtered list
  //             setState(() {
  //               filteredUsers.removeAt(index);
  //             });
  //
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Profile deleted successfully!'),
  //                 backgroundColor: Colors.green,
  //                 duration: Duration(seconds: 1),
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
  //endregion DatabseDeleteConfirtion

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
                  allFavorites
                      .removeWhere((element) => element['id'] == user['id']);
                  filteredUsers = List.from(allFavorites);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile deleted successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 500),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                if (allFavorites.isEmpty) {
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

  //region DatabaseShareUserDetails
  // void _shareUserDetails(Map<String, dynamic> user) {
  //
  //   DateTime dob = DateTime.parse(user[DOB]);
  //   DateTime now = DateTime.now();
  //   int age = now.year - dob.year;
  //   if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
  //     age--;
  //   }
  //
  //   String shareText = '''
  //   📌 *Profile Details*
  //
  //   👤 *Name:* ${user[NAME]}
  //   ✉️ *Email:* ${user[EMAIL]}
  //   📞 *Phone:* ${user[PHONE]}
  //   🎂 *DOB:* ${user[DOB]}
  //   🎂 *Age:* $age
  //   🚻 *Gender:* ${user[GENDER]}
  //   🏠 *Address:* ${user[ADDRESS]}, ${user[CITY]}, ${user[COUNTRY]}
  //   🎨 *Hobbies:* ${user[HOBBY] ?? 'No hobbies listed'}
  //   📏 *Height:* ${user[HEIGHT]}
  //   🎭 *Complexion:* ${user[COMPLEXION]}
  //   🎓 *Education:* ${user[EDUCATION]}
  //   💼 *Occupation:* ${user[OCCUPATION]}
  //   💰 *Annual Income:* ${user[ANNUAL_INCOME]}
  //   🛕 *Religion:* ${user[RELIGION]}
  //   🏷️ *Caste:* ${user[CASTE]}
  //   🗣️ *Mother Tongue:* ${user[MOTHER_TONGUE]}
  //   🌟 *Nakshatra:* ${user[NAKSHATRA]}
  //   ♈ *Rashi:* ${user[RASHI]}
  //   ''';
  //
  //   Share.share(shareText);
  // }
  //endregion DatabaseShareUserDetails

  void _shareUserDetails(Map<String, dynamic> user) {
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
