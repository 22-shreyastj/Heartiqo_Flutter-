import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_progress.dart';
import '../widgets/signup_primary_button.dart';

import 'verification_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final SignupController controller;

  const PersonalDetailsScreen({
    super.key,
    required this.controller,
  });

  @override
  State<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState
    extends State<PersonalDetailsScreen> {
  final TextEditingController dobController =
      TextEditingController();

  // IMPORTANT:
  // Keep dropdown values empty initially.
  String gender = '';
  String interestedIn = 'Women';
  String country = '';
  String city = '';

  bool dobError = false;
  bool genderError = false;
  bool countryError = false;
  bool cityError = false;

  Future<void> selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        dobController.text =
            '${date.month}/${date.day}/${date.year}';

        dobError = false;
      });
    }
  }

  bool validateForm() {
    setState(() {
      dobError = dobController.text.isEmpty;
      genderError = gender.isEmpty;
      countryError = country.isEmpty;
      cityError = city.isEmpty;
    });

    if (dobError ||
        genderError ||
        countryError ||
        cityError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }

    return true;
  }

  void continueSignup() {
    if (!validateForm()) {
      return;
    }

    widget.controller.savePersonalDetails(
      dateOfBirth: dobController.text,
      gender: gender,
      interestedIn: interestedIn,
      country: country,
      city: city,
    );

    widget.controller.nextPage(
      context,
      VerificationScreen(
        controller: widget.controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF9F9),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // HEADER
                SignupHeader(
                  onBack: () =>
                      widget.controller.back(context),
                ),

                const SignupProgress(
                  step: 4,
                ),

                const SizedBox(height: 30),

                const Text(
                  'STEP 4 OF 5',
                  style: TextStyle(
                    color: Color(0xFFC00055),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Tell Us About Yourself',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'This helps us find the most compatible '
                  'matches for your lifestyle.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                // DATE OF BIRTH
                const Text(
                  'Date of Birth *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: dobController,
                  readOnly: true,
                  onTap: selectDate,

                  decoration: InputDecoration(
                    hintText: 'MM/DD/YYYY',

                    suffixIcon: const Icon(
                      Icons.calendar_month,
                    ),

                    errorText: dobError
                        ? 'Date of birth is required'
                        : null,

                    border:
                        const OutlineInputBorder(),

                    enabledBorder:
                        OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dobError
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dobError
                            ? Colors.red
                            : const Color(
                                0xFFC00055,
                              ),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // GENDER
                const Text(
                  'Gender Identity *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value:
                      gender.isEmpty ? null : gender,

                  hint: const Text(
                    'Select your gender',
                  ),

                  isExpanded: true,

                  decoration: InputDecoration(
                    errorText: genderError
                        ? 'Gender is required'
                        : null,

                    border:
                        const OutlineInputBorder(),

                    enabledBorder:
                        OutlineInputBorder(
                      borderSide: BorderSide(
                        color: genderError
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderSide: BorderSide(
                        color: genderError
                            ? Colors.red
                            : const Color(
                                0xFFC00055,
                              ),
                      ),
                    ),
                  ),

                  items: const [
                    'Woman',
                    'Man',
                    'Non-binary',
                    'Other',
                  ]
                      .map(
                        (item) =>
                            DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      gender = value ?? '';
                      genderError = false;
                    });
                  },
                ),

                const SizedBox(height: 22),

                // INTERESTED IN
                const Text(
                  'Interested In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    interestedChip('Women'),
                    interestedChip('Men'),
                    interestedChip('Everyone'),
                  ],
                ),

                const SizedBox(height: 28),

                // COUNTRY AND CITY
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildDropdown(
                        title: 'Country *',
                        value: country,
                        hint: 'Select country',
                        hasError: countryError,
                        errorText:
                            'Country is required',
                        items: const [
                          'India',
                          'United States',
                          'Canada',
                          'United Kingdom',
                        ],
                        onChanged: (value) {
                          setState(() {
                            country = value ?? '';
                            countryError = false;

                            // Reset city when
                            // country changes.
                            city = '';
                            cityError = false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: buildDropdown(
                        title: 'City *',
                        value: city,
                        hint: 'Select city',
                        hasError: cityError,
                        errorText:
                            'City is required',
                        items: const [
                          'Hyderabad',
                          'Bangalore',
                          'Chennai',
                          'Mumbai',
                        ],
                        onChanged: (value) {
                          setState(() {
                            city = value ?? '';
                            cityError = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SignupPrimaryButton(
                  text: 'CONTINUE',
                  onPressed: continueSignup,
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () =>
                        widget.controller.back(context),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFFC00055),

                      side: const BorderSide(
                        color: Color(0xFFC00055),
                      ),
                    ),

                    child: const Text(
                      'BACK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );

  Widget interestedChip(String text) => ChoiceChip(
        label: Text(text),

        selected:
            interestedIn == text,

        selectedColor:
            const Color(0xFFFFD8E5),

        checkmarkColor:
            const Color(0xFFC00055),

        onSelected: (_) => setState(
          () => interestedIn = text,
        ),
      );

  Widget buildDropdown({
    required String title,
    required String value,
    required String hint,
    required bool hasError,
    required String errorText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value:
                value.isEmpty ? null : value,

            hint: Text(hint),

            isExpanded: true,

            decoration: InputDecoration(
              errorText:
                  hasError ? errorText : null,

              border:
                  const OutlineInputBorder(),

              enabledBorder:
                  OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : Colors.grey,
                ),
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : const Color(
                          0xFFC00055,
                        ),
                ),
              ),
            ),

            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),

            onChanged: onChanged,
          ),
        ],
      );

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }
}