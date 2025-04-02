import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
          title: const Text(
            'About Us',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/loveBridge2.webp'),
                        radius: 48,
                      ),
                      SizedBox(height: 10),
                      Center(child: Text('Love Bridge', style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent)),),
                      SizedBox(height: 5),
                      Text('Bringing hearts together ❤️',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                        height: 28,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Colors.purple),
                        child: Center(
                            child: Text(
                              'Meet Our Team',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple, width: 1.75),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Developed by : ',
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text: 'Vatsal Parmar (23010101196)',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mentored by : ',
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text:
                              'Prof. Mehul Bhundiya, School of Computer Science',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Explored by : ',
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text: 'ASWDC, School of Computer Science',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Eulogized by : ',
                              style: TextStyle(color: Colors.purple),
                            ),
                            TextSpan(
                              text: 'Darshan University, Rajkot, Gujarat - INDIA',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                        height: 28,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Colors.purple),
                        child: Center(
                            child: Text(
                              'About ASWDC',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple, width: 1.75),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/darshan.jpg',
                              height: 50,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: Image.asset(
                              'assets/images/aswdc.jpg',
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 10),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          const Text(
                              'ASWDC is the Application, Software and Website Development Center @ Darshan University, run by students and staff of the School of Computer Science. '),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Sole purpose is to bridge the gap between university curriculum & industry demands. Students learn cutting-edge technologies and develop real-world'
                                'application & experiences professional environment @ASWDC under the guidance of experienced industry experts and faculty members.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                        height: 28,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Colors.purple),
                        child: Center(
                            child: Text(
                              'Contact',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple, width: 1.75),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'aswdc@darshan.ac.in',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            '+91-9727747317',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.language, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'www.darshan.ac.in',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple, width: 1.75),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.share, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'Share App',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.apps, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'More Apps',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star_border, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'Rate Us',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'Like us on Facebook',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.autorenew_outlined, color: Colors.purple),
                          SizedBox(width: 10),
                          Text(
                            'Check For Update',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text('© 2025 Darshan University'),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('All Rights Reserved - '),
                          Text('Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                              ))
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 108),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Made with '),
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 20,
                            ),
                            Text(' in India'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              ],
            ),
            ),
        );
    }
}