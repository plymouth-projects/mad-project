import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFDDE9F8),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("First Name"),
                _buildTextField("Last Name"),
                _buildTextField("Email"),
                _buildTextField("Phone Number"),
                const SizedBox(height: 10),
                const Text("Select Area?", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildRadioOption("Home Maintenance"),
                _buildRadioOption("Personal Care"),
                _buildRadioOption("Constructions And Repairs"),
                _buildRadioOption("Transport And Security"),
                _buildTextField("Message"),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {},
                    child: const Text("Send Message", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return Row(
      children: [
        Radio(value: title, groupValue: null, onChanged: (value) {}),
        Text(title),
      ],
    );
  }
}
