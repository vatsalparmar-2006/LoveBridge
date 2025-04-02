import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_bridge/AnalysisScreen/analysisScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AboutScreen/aboutUsScreen.dart';
import '../AddEditScreen/addEditScreen.dart';
import '../FavouriteScreen/favouriteScreen.dart';
import '../FeedBackScreen/feedBackScreen.dart';
import '../LoginScreen/loginScreen.dart';
import '../UserListScreen/userListScreen.dart';
import '../utils/backgroundPainterTry.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  final String? name;
  final String? email;
  final File? profileImage;
  final String? password;

  const DashboardScreen(
      {super.key, this.name, this.email, this.profileImage, this.password});

  @override
  State<DashboardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashboardScreen> {
  DateTime? signUpDate;
  DateTime? lastLogin;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadAuthDates();
  }

  Future<void> _clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedEmail');
    await prefs.remove('savedPassword');
  }

  Future<void> _loadAuthDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastLogin = DateTime.parse(
          prefs.getString('signUpDate') ?? DateTime.now().toString());
      signUpDate = DateTime.parse(
          prefs.getString('lastLogin') ?? DateTime.now().toString());
    });
// Update last login time
    await prefs.setString('lastLogin', DateTime.now().toString());
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await _clearSavedCredentials(); // Clear saved credentials
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink.shade100,
                Colors.purple.shade100,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink.shade700,
                      Colors.purple.shade700,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.profileImage != null
                          ? FileImage(widget.profileImage!)
                          : null,
                      child: widget.profileImage == null
                          ? Icon(Icons.person, size: 50, color: Colors.pink)
                          : null,
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget.name ?? 'Guest',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.email ?? 'guest@example.com',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.date_range,
                      title: 'Account Created',
                      subtitle: signUpDate != null
                          ? DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(signUpDate!)
                          : '',
                    ),
                    Divider(color: Colors.pink.withOpacity(0.3)),
                    _buildDrawerItem(
                      icon: Icons.login,
                      title: 'Last Login',
                      subtitle: lastLogin != null
                          ? DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(lastLogin!)
                          : '',
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text('LOGOUT',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade700,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.pink.withOpacity(0.3),
                        ),
                        onPressed: () => _showLogoutConfirmation(context),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            bool exitApp = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Rounded corners
                backgroundColor: Colors.pink[50], // Soft romantic color
                title: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.pink), // Attractive icon
                    SizedBox(width: 10),
                    Text(
                      "Leaving so soon? 💕",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink[800]),
                    ),
                  ],
                ),
                content: Text(
                  "Are you sure you want to leave? ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
                    child: Text("Stay and Explore ❤️", style: TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text("Exit 😢", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),

            );
            return exitApp; // Return user's choice
          },
          child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, MediaQuery.of(context).size.height),
              painter: BackgroundPainter(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 25),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: widget.profileImage != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(widget.profileImage!),
                        radius: 20,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person, // Fallback icon
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Welcome to LoveBridge ❤️',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade800,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(20),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      getDashBoardCard(
                        context,
                        icon: Icons.person_add_alt_1_sharp,
                        title: 'Add Profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AddEditScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0); // Slide from right
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, -1.0), // Start from bottom
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      getDashBoardCard(
                        context,
                        icon: Icons.groups,
                        title: 'View Profiles',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      UserListScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0); // Slide from right
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, -1.0), // Start from top
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      getDashBoardCard(
                        context,
                        icon: Icons.favorite_sharp,
                        title: 'Favorite Profiles',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FavoriteScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: 0.8, end: 1.0)
                                        .animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      getDashBoardCard(
                        context,
                        icon: Icons.info_sharp,
                        title: 'About Us',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AboutUsScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0); // Slide from right
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, 1.0), // Start from bottom
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      getDashBoardCard(
                        context,
                        icon: Icons.feedback,
                        title: 'FeedBack',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FeedbackScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0); // Slide from right
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      getDashBoardCard(
                        context,
                        icon: Icons.analytics_outlined,
                        title: 'Analysis',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                  AnalysisChartScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0); // Slide from right
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                animation.drive(tween);

                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDashBoardCard(BuildContext context, {required IconData icon, required String title, required onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.pink.shade200,
      highlightColor: Colors.pink.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade50.withOpacity(0.9),
              Colors.purple.shade50.withOpacity(0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 4), // Soft shadow below the card
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
// Icon with floating effect
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.shade100,
                    Colors.purple.shade100,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: Offset(0, 4), // Shadow for the icon
                  ),
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 30,
                color: Colors.pink.shade600,
              ),
            ),
            SizedBox(height: 15),
// Title with romantic font style
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.pink.shade800,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //region buildDrawerItem
  Widget _buildDrawerItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink.shade700, size: 28),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.pink.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pink.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //endregion buildDrawerItem

}

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.1), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.7), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.9), 55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
