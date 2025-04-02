import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Share Your Thoughts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEC407A), Color(0xFFAB47BC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/loveBridge2.webp'),
                radius: 48,
              ),
              const SizedBox(height: 25),
              const Text(
                'Help Us Create\nBetter Matches 💞',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF880E4F),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(
                        controller: _nameController,
                        label: 'Your Name',
                        icon: Icons.person_outline,
                        validator: (value) => value!.isEmpty ? 'Please tell us your name' : null,
                      ),
                      const SizedBox(height: 25),
                      _buildInputField(
                        controller: _feedbackController,
                        label: 'Your Valuable Feedback',
                        icon: Icons.feedback_outlined,
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty) return 'We\'d love to hear from you!';
                          if (value.length < 5) return 'Please share a bit more detail';
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.favorite, size: 22),
                        label: const Text('Send Your Thoughts',
                            style: TextStyle(fontSize: 16, letterSpacing: 1.1)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC407A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.pink.shade100,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmation(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.pink.shade50,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.pink.shade200, width: 2),
        ),
        errorStyle: TextStyle(color: Colors.pink.shade700),
      ),
      validator: validator,
    );
  }

  void _showConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                  text: 'Thank you, ',
                  style: TextStyle(fontSize: 16)),
              TextSpan(
                  text: _nameController.text,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '! ❤️\nYour insights help us connect hearts more effectively!'),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFEC407A),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    _nameController.clear();
    _feedbackController.clear();
  }
}