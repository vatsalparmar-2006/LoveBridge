import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:love_bridge/DashBoard/dashBoardScreen.dart';
import 'package:love_bridge/utils/constant.dart';

import '../API/apiServices.dart';
import '../Database/dbConnection.dart';

class AddEditScreen extends StatefulWidget {
  Map<String, dynamic>? personDetails;
  String? index;

  AddEditScreen({super.key, this.personDetails, this.index});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  // UserClass _user = UserClass();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();

  // Dropdown values
  String? selectedGender;
  String? selectedCity;
  String? selectedCountry;
  String? selectedHeight;
  String? selectedComplexion;
  String? selectedReligion;
  String? selectedMotherTongue;
  String? selectedNakshatra;
  String? selectedRashi;
  String? selectedEducation;
  String? selectedAnnualIncome;
  DateTime? selectedDate;
  String? selectedCaste;
  int? age;

  List<String> genders = ['Male', 'Female'];
  List<String> cities = [
    'Rajkot',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Chennai',
    'Kolkata',
    'Surat',
    'Pune',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
    'Ghaziabad',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Varanasi',
    'Srinagar',
    'Aurangabad',
    'Dhanbad',
    'Amritsar',
    'Navi Mumbai',
    'Allahabad',
    'Ranchi',
    'Howrah',
    'Coimbatore',
    'Jabalpur',
    'Gwalior',
    'Vijayawada',
    'Jodhpur',
    'Madurai',
    'Raipur',
    'Kota',
    'Guwahati',
    'Chandigarh',
    'Solapur',
    'Hubli-Dharwad',
    'Bareilly',
    'Moradabad',
    'Mysore',
    'Gurgaon',
    'Aligarh',
    'Jalandhar',
    'Tiruchirappalli',
    'Bhubaneswar',
    'Salem',
    'Warangal',
  ];
  List<String> countries = [
    'India',
    'United States',
    'China',
    'Japan',
    'Germany',
    'United Kingdom',
    'France',
    'Brazil',
    'Italy',
    'Canada',
    'South Korea',
    'Russia',
    'Australia',
    'Spain',
    'Mexico',
    'Indonesia',
    'Netherlands',
    'Saudi Arabia',
    'Turkey',
    'Switzerland',
    'Argentina',
    'Sweden',
    'Nigeria',
    'Poland',
    'Belgium',
    'Thailand',
    'Iran',
    'Austria',
    'Norway',
    'United Arab Emirates',
    'Israel',
    'Singapore',
    'Malaysia',
    'South Africa',
    'Philippines',
    'Denmark',
    'Egypt',
    'Pakistan',
    'Finland',
    'Vietnam',
    'Colombia',
    'Bangladesh',
    'Chile',
    'Portugal',
    'Greece',
    'Iraq',
    'Ireland',
    'Ukraine',
    'New Zealand',
    'Qatar',
  ];
  List<String> hobbies = [
    'Reading',
    'Traveling',
    'Music',
    'Sports',
  ];
  List<String> educationLevels = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Other'
  ];
  List<String> religions = [
    'Hindu',
    'Muslim',
    'Christian',
    'Sikh',
    'Jain',
    'Buddhist',
    'Other'
  ];
  List<String> motherTongues = [
    'Hindi',
    'English',
    'Gujarati',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Marathi',
    'Bengali',
    'Punjabi',
    'Urdu',
    'Other'
  ];
  List<String> complexions = ['Fair', 'Wheatish', 'Brown', 'Dark'];
  List<String> heightOptions = [
    '4ft 6in',
    '4ft 7in',
    '4ft 8in',
    '4ft 9in',
    '4ft 10in',
    '4ft 11in',
    '5ft 0in',
    '5ft 1in',
    '5ft 2in',
    '5ft 3in',
    '5ft 4in',
    '5ft 5in',
    '5ft 6in',
    '5ft 7in',
    '5ft 8in',
    '5ft 9in',
    '5ft 10in',
    '5ft 11in',
    '6ft 0in',
    '6ft 1in',
    '6ft 2in',
    '6ft 3in',
    '6ft 4in',
    '6ft 5in',
    '6ft 6in'
  ];
  List<String> nakshatras = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati'
  ];
  List<String> annualIncome = [
    '1-4 LPA',
    '5-8 LPA',
    '9-12 LPA',
    '13-16 LPA',
    '17-20 LPA',
    '21-24 LPA',
    '25-28 LPA',
    '29-32 LPA',
    '33-36 LPA',
    '37-40 LPA',
    '40+ LPA'
  ];
  List<String> rashis = [
    'Aries (Mesha)',
    'Taurus (Vrishabha)',
    'Gemini (Mithuna)',
    'Cancer (Karka)',
    'Leo (Simha)',
    'Virgo (Kanya)',
    'Libra (Tula)',
    'Scorpio (Vrischika)',
    'Sagittarius (Dhanu)',
    'Capricorn (Makara)',
    'Aquarius (Kumbha)',
    'Pisces (Meena)'
  ];
  List<String> castes = [
    "Brahmin", // Priestly and scholarly class
    "Kshatriya", // Warrior and ruling class
    "Vaishya", // Merchant and business class
    "Shudra", // Working and service class
    "Dalit", // Historically marginalized communities (Scheduled Castes)
    "Adivasi", // Indigenous tribal communities (Scheduled Tribes)
    "Jat", // Predominantly in North India (agricultural community)
    "Rajput", // Warrior class, especially in Rajasthan and North India
    "Yadav", // Predominantly in North India (agricultural community)
    "Gurjar", // Predominantly in North India
    "Maratha", // Predominantly in Maharashtra
    "Lingayat", // Predominantly in Karnataka
    "Vanniyar", // Predominantly in Tamil Nadu
    "Nair", // Predominantly in Kerala
    "Ezhava", // Predominantly in Kerala
    "Reddy", // Predominantly in Andhra Pradesh and Telangana
    "Kamma", // Predominantly in Andhra Pradesh and Telangana
    "Vokkaliga", // Predominantly in Karnataka
    "Kurmi", // Predominantly in North India
    "Khatri", // Predominantly in North India (business community)
    "Bania", // Business community
    "Kayastha", // Scribe and administrative class
    "Bhumihar", // Predominantly in Bihar and Uttar Pradesh
    "Patel", // Predominantly in Gujarat
    "Meena", // Predominantly in Rajasthan
    "Gowda", // Predominantly in Karnataka
    "Mali", // Predominantly in Maharashtra and Gujarat
    "Teli", // Predominantly in North India
    "Koli", // Predominantly in Gujarat and Maharashtra
    "Chamar", // Dalit community
    "Dhobi", // Washerman community
    "Nai", // Barber community
    "Lohar", // Blacksmith community
    "Kumhar", // Potter community
    "Tamil Chettiar", // Business community in Tamil Nadu
    "Nadar", // Predominantly in Tamil Nadu
    "Pillai", // Predominantly in Tamil Nadu
    "Scheduled Castes (SC)", // Official term for Dalit communities
    "Scheduled Tribes (ST)" // Official term for Adivasi communities
  ];
  List<dynamic> selectedHobbies = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 18 * 365)),
      // Defaults to 18 years ago
      firstDate: DateTime.now().subtract(Duration(days: 80 * 365)),
      // Allows users born from 1950
      lastDate: DateTime.now()
          .subtract(Duration(days: 18 * 365)), // Ensures minimum age is 18
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text =
            "${picked.day.toString().padLeft(2, '0')} - ${picked.month.toString().padLeft(2, '0')} - ${picked.year}";
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (selectedDate != null) {
      DateTime today = DateTime.now();
      int calculatedAge = today.year - selectedDate!.year;
      if (today.month < selectedDate!.month ||
          (today.month == selectedDate!.month &&
              today.day < selectedDate!.day)) {
        calculatedAge--;
      }
      setState(() {
        age = calculatedAge;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.personDetails != null) {
      fullNameController.text = widget.personDetails![NAME].toString();
      emailController.text = widget.personDetails![EMAIL].toString();
      phoneController.text = widget.personDetails![PHONE].toString();
      dobController.text = widget.personDetails![DOB].toString();
      addressController.text = widget.personDetails![ADDRESS].toString();
      selectedGender = widget.personDetails![GENDER];
      selectedCity = widget.personDetails![CITY];
      selectedCountry = widget.personDetails![COUNTRY];
      selectedHobbies = widget.personDetails?[HOBBY] != null
          ? widget.personDetails![HOBBY]
              .split(',')
              .map((hobby) => hobby.trim())
              .toList()
          : []; // If null, initialize as empty list
      selectedHeight = widget.personDetails![HEIGHT];
      selectedComplexion = widget.personDetails![COMPLEXION];
      occupationController.text = widget.personDetails![OCCUPATION].toString();
      selectedReligion = widget.personDetails![RELIGION];
      selectedMotherTongue = widget.personDetails![MOTHER_TONGUE];
      selectedRashi = widget.personDetails![RASHI];
      selectedNakshatra = widget.personDetails![NAKSHATRA];
      selectedEducation = widget.personDetails![EDUCATION];
      selectedAnnualIncome = widget.personDetails![ANNUAL_INCOME];
      selectedCaste = widget.personDetails![CASTE];
      selectedEducation = widget.personDetails![EDUCATION];
      nickNameController.text = widget.personDetails![NICK_NAME].toString();

      // Initialize selectedDate and age
      if (widget.personDetails![DOB] != null) {
        List<String> dobParts = widget.personDetails![DOB].split(' - ');
        if (dobParts.length == 3) {
          selectedDate = DateTime(
            int.parse(dobParts[2]),
            int.parse(dobParts[1]),
            int.parse(dobParts[0]),
          );
          _calculateAge(); // Calculate age based on the selected date
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.personDetails == null ? 'Add Profile' : 'Edit Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade800,
            ),
          ),
          backgroundColor: Colors.pink.shade100,
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    getTextFormField(
                        controller: fullNameController,
                        lableText: 'Full Name',
                        hintText: 'Enter your full name',
                        icon: Icons.add_reaction_rounded,
                        maxLength: 50,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^[A-Za-z\s'-]+$")),
                          capitalizeWords(fullNameController.text.toString())
                        ],
                        onChanged: (value) {
                          // Capitalize the first letter of each word
                          fullNameController.value = TextEditingValue(
                            text: value.split(' ').map((word) {
                              if (word.isEmpty) return word;
                              return word[0].toUpperCase() +
                                  word.substring(1).toLowerCase();
                            }).join(' '),
                            selection: fullNameController.selection,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          if (!RegExp(r"^[a-zA-Z\s']{3,50}$").hasMatch(value)) {
                            return 'Invalid Full Name';
                          }
                          return null;
                        }),
                    // Name

                    SizedBox(height: 20),

                    getTextFormField(
                        controller: emailController,
                        lableText: 'Email Address',
                        hintText: 'Enter your email address',
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return 'Invalid Email Address';
                          }
                          return null;
                        }),
                    // Email

                    SizedBox(height: 20),

                    getTextFormField(
                        maxLength: 10,
                        controller: phoneController,
                        lableText: 'Contact Number',
                        hintText: 'Enter your contact number',
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        icon: Icons.phone_iphone_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // Allows only digits (0-9)
                          LengthLimitingTextInputFormatter(10),
                          // Ensures max length is 10
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          }
                          if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                            return "Enter valid contact number";
                          }
                          return null;
                        }),
                    // Phone

                    SizedBox(height: 20),

                    getTextFormField(
                        controller: addressController,
                        lableText: 'Address',
                        hintText: 'Enter your address',
                        maxLines: 3,
                        icon: Icons.location_on_sharp,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        }),
                    // Address

                    SizedBox(height: 20),

                    TextFormField(
                      controller: dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.pink,
                        ),
                        labelText: 'Date of Birth',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        hintText: 'Select your birth date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFFE06E8E), width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        if (age != null && age! < 18) {
                          return 'You must be at least 18 years old';
                        }
                        return null;
                      },
                    ),
                    // BirthDate

                    _buildFormRow(
                      label: 'Gender :',
                      child: _buildGenderRadioButtons(),
                    ),
                    // Gender

                    _buildDropdown(
                        'Country',
                        'Select your country',
                        icon: Icons.public,
                        countries,
                        selectedCountry, (newValue) {
                      setState(() {
                        selectedCountry = newValue;
                      });
                    }),
                    // Country

                    SizedBox(height: 20),

                    _buildDropdown(
                        'City',
                        'Select your city',
                        icon: Icons.location_city,
                        cities,
                        selectedCity, (newValue) {
                      setState(() {
                        selectedCity = newValue;
                      });
                    }),
                    // City

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Height',
                        'Select your height',
                        icon: Icons.height_outlined,
                        heightOptions,
                        selectedHeight, (newValue) {
                      setState(() {
                        selectedHeight = newValue;
                      });
                    }),
                    // height

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Complexion',
                        'Select your complexion',
                        icon: Icons.face,
                        complexions,
                        selectedComplexion, (newValue) {
                      setState(() {
                        selectedComplexion = newValue;
                      });
                    }),
                    // complexion

                    SizedBox(height: 20),

                    _buildFormRow(
                      label: 'Hobbies : ',
                      child: _buildHobbyChips(),
                    ),
                    // Hobbies

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Religion',
                        'Select your religion',
                        icon: Icons.temple_buddhist_outlined,
                        religions,
                        selectedReligion, (newValue) {
                      setState(() {
                        selectedReligion = newValue;
                      });
                    }),
                    // religion

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Caste',
                        'Select your caste',
                        icon: Icons.group,
                        castes,
                        selectedCaste, (newValue) {
                      setState(() {
                        selectedCaste = newValue;
                      });
                    }),
                    // caste

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Mother Tongue',
                        'Select your motherTongue',
                        icon: Icons.language_outlined,
                        motherTongues,
                        selectedMotherTongue, (newValue) {
                      setState(() {
                        selectedMotherTongue = newValue;
                      });
                    }),
                    // mother tongue

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Rashi',
                        'Select your rashi',
                        icon: Icons.psychology,
                        rashis,
                        selectedRashi, (newValue) {
                      setState(() {
                        selectedRashi = newValue;
                      });
                    }),

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Nakshatra',
                        'Select your nakshatra',
                        icon: Icons.star,
                        nakshatras,
                        selectedNakshatra, (newValue) {
                      setState(() {
                        selectedNakshatra = newValue;
                      });
                    }),

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Education',
                        'Select your educationLevel',
                        icon: Icons.school_outlined,
                        educationLevels,
                        selectedEducation, (newValue) {
                      setState(() {
                        selectedEducation = newValue;
                      });
                    }),

                    SizedBox(height: 20),

                    _buildDropdown(
                        'Annual Income',
                        'Select your annualIncome',
                        annualIncome,
                        icon: Icons.attach_money,
                        selectedAnnualIncome, (newValue) {
                      setState(() {
                        selectedAnnualIncome = newValue;
                      });
                    }),

                    SizedBox(height: 20),

                    getTextFormField(
                        controller: occupationController,
                        lableText: 'Occupation',
                        hintText: 'Enter your occupation',
                        icon: Icons.work,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your occupation';
                          }
                          return null;
                        }),
                    // Occupation

                    SizedBox(height: 20),

                    getTextFormField(
                      controller: nickNameController,
                      lableText: 'Nick Name (Optional)',
                      hintText: 'Enter your nickname',
                      icon: Icons.tag_faces_outlined,
                      maxLength: 30,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      onChanged: (value) {
                        // Capitalize the first letter of each word
                        nickNameController.value = TextEditingValue(
                          text: value.split(' ').map((word) {
                            if (word.isEmpty) return word;
                            return word[0].toUpperCase() +
                                word.substring(1).toLowerCase();
                          }).join(' '),
                          selection: nickNameController.selection,
                        );
                      },
                      validator: (value) {
                        return null;
                      },
                    ),

                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: Text(widget.personDetails == null
                              ? 'Add Profile'
                              : 'Edit Profile'),
                        ),
                        ElevatedButton(
                          onPressed: _resetForm,
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Prevents bottom overflow
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    String hobbies1 = selectedHobbies.join(",");
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {
        NAME: fullNameController.text,
        EMAIL: emailController.text,
        PHONE: phoneController.text,
        DOB: dobController.text,
        ADDRESS: addressController.text,
        CASTE: selectedCaste,
        OCCUPATION: occupationController.text,
        CITY: selectedCity,
        GENDER: selectedGender,
        HOBBY: hobbies1,
        AGE: age ?? 18,
        COUNTRY: selectedCountry,
        COMPLEXION: selectedComplexion,
        HEIGHT: selectedHeight,
        RELIGION: selectedReligion,
        RASHI: selectedRashi,
        MOTHER_TONGUE: selectedMotherTongue,
        NAKSHATRA: selectedNakshatra,
        EDUCATION: selectedEducation,
        ANNUAL_INCOME: selectedAnnualIncome,
        NICK_NAME: nickNameController.text,
        'is_favorite': widget.personDetails?['is_favorite'] ?? 0,
      };

      // DbConnection dbConnection = DbConnection();
      ApiService apiService = ApiService();

      //region DatabseLogicAddUpdate
      // if (widget.personDetails != null) {
      //   // Editing existing profile
      //   map['id'] = widget.personDetails!['id'];
      //   if (map['id'].runtimeType.toString() == "int") {
      //     await dbConnection.updateProfiles(map);
      //   } else {
      //     await apiService.updateUser(map['id'], map);
      //   }
      //   Navigator.pop(context, map); // Return updated data
      // } else {
      //   // Adding a new profile
      //   bool check = await dbConnection.insertProfile(map);
      //   if (check) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text('Profile added successfully!'),
      //       backgroundColor: Colors.green,
      //       duration: Duration(milliseconds: 500),
      //       behavior: SnackBarBehavior.floating,
      //     ));
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Failed to add profile!'),
      //         backgroundColor: Colors.red,
      //         duration: Duration(milliseconds: 500),
      //         behavior: SnackBarBehavior.floating,
      //       ),
      //     );
      //   }
      // }

      if(widget.personDetails != null) {
         apiService.updateUser(widget.index!, map);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, map);
      }
      else {
         apiService.addUser(map);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        // Future.delayed(Duration(milliseconds: 800), () {
        //
        // });
      }
    }
  }

  void _resetForm() {
    setState(() {
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      dobController.clear();
      addressController.clear();
      casteController.clear();
      occupationController.clear();
      selectedDate = null;
      selectedGender = null;
      selectedCountry = null;
      selectedCity = null;
      selectedComplexion = null;
      selectedHeight = null;
      selectedHobbies.clear();
      selectedReligion = null;
      selectedRashi = null;
      selectedMotherTongue = null;
      selectedNakshatra = null;
      selectedEducation = null;
      selectedAnnualIncome = null;
      nickNameController.clear();
      age = null;
    });
  }

  Widget _buildHobbyChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hobbies
          .map((hobby) => FilterChip(
                shape: StadiumBorder(),
                label: Text(hobby),
                selected: selectedHobbies.contains(hobby),
                selectedColor: Colors.pinkAccent,
                backgroundColor: Color(0xFFF9B8C9),
                labelStyle: TextStyle(
                    color: selectedHobbies.contains(hobby)
                        ? Colors.white
                        : Colors.black),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    selectedHobbies.add(hobby);
                  } else {
                    selectedHobbies.remove(hobby);
                  }
                }),
              ))
          .toList(),
    );
  }

  Widget _buildGenderRadioButtons() {
    return Row(
      children: genders.map((gender) {
        return Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: gender,
                  groupValue: selectedGender,
                  activeColor: Colors.pinkAccent,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                // Wrap the Text with GestureDetector or InkWell
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                  child: Text(gender),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  //region buildDropdown
  Widget _buildDropdown(
      String label,
      String hint,
      List<String> items,
      String? value,
      Function(String?) onChanged, {
        IconData? icon,
      }) {
    final TextEditingController textEditingController = TextEditingController();

    // Ensure selectedValue exists in items to avoid "no matching value" error
    String? selectedValue = (value != null && items.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add the label text here
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.black,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            value: selectedValue,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
                selectedValue = newValue;
              }
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 1),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(height: 40),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding:
                const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Search for an item...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, color: Colors.pink),
            ),
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedValue ?? hint,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }
  //endregion buildDropdown

  Widget _buildFormRow({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          Expanded(flex: 6, child: child),
        ],
      ),
    );
  }

  String capitalizeWords(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  //region getTextFormField
  Widget getTextFormField(
      {required TextEditingController controller,
        required String lableText,
        String? hintText,
        required validator,
        keyboardType,
        IconData? icon,
        inputFormatters,
        maxLength,
        maxLines,
        onChanged}) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: lableText,
        labelStyle: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        hintText: hintText,
        hintStyle: TextStyle(),
        prefixIcon: icon != null
            ? IconButton(
          icon: Icon(
            icon,
            color: Colors.pink,
          ),
          onPressed: () {
            return;
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // borderSide: BorderSide(color: Color(0xFFE06E8E), width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE06E8E), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
//endregion getTextFormField
}