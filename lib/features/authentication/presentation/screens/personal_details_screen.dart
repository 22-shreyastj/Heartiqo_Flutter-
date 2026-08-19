import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';
import '../../data/location_data.dart';

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
  final TextEditingController dobController = TextEditingController();

  String gender = '';
  String interestedIn = 'Women';
  String country = '';
  String state = '';
  String city = '';

  bool hasSubmitted = false;

  bool dobError = false;
  bool genderError = false;
  bool countryError = false;
  bool stateError = false;
  bool cityError = false;

  Future<void> selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC00055),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        dobController.text =
            '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
        dobError = false;
      });
    }
  }

  bool validateForm() {
    setState(() {
      hasSubmitted = true;
      dobError = dobController.text.trim().isEmpty;
      genderError = gender.isEmpty;
      countryError = country.isEmpty;
      stateError = state.isEmpty;
      cityError = city.isEmpty;
    });

    return !(dobError ||
        genderError ||
        countryError ||
        stateError ||
        cityError);
  }

  void continueSignup() {
    if (!validateForm()) {
      return;
    }

    widget.controller.savePersonalDetails(
      dateOfBirth: dobController.text.trim(),
      gender: gender,
      interestedIn: interestedIn,
      country: country,
      state: state,
      city: city,
    );

    widget.controller.nextPage(
      context,
      VerificationScreen(
        controller: widget.controller,
      ),
    );
  }

  Future<void> _showSearchSelection({
    required String title,
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    if (items.isEmpty) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items
                .where((item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select $title',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search $title...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFC00055),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFF9F9),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(
                              color: Color(0xFFC00055),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (query) {
                          setModalState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Expanded(
                      child: filteredItems.isEmpty
                          ? Center(
                              child: Text(
                                'No $title found',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final isSelected = item == selectedValue;
                                return ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFFC00055)
                                          : Colors.black87,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFFC00055),
                                        )
                                      : null,
                                  onTap: () {
                                    onSelected(item);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildLocationPicker({
    required String title,
    required String value,
    required String hint,
    required bool hasError,
    required String errorText,
    required bool isEnabled,
    required VoidCallback onTap,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: isEnabled ? Colors.white : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: hasError
                      ? Colors.red
                      : (isEnabled
                          ? Colors.grey.shade400
                          : Colors.grey.shade300),
                  width: hasError ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value.isNotEmpty ? value : hint,
                      style: TextStyle(
                        fontSize: 15,
                        color: value.isNotEmpty
                            ? Colors.black87
                            : (isEnabled
                                ? Colors.grey.shade500
                                : Colors.grey.shade400),
                        fontWeight: value.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isEnabled
                        ? const Color(0xFFC00055)
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 6),
            Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      );

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Color(0xFFC00055),
                    ),

                    errorText: dobError
                        ? 'Date of birth is required'
                        : null,

                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dobError
                            ? Colors.red
                            : Colors.grey.shade400,
                        width: dobError ? 1.5 : 1.0,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dobError
                            ? Colors.red
                            : Colors.grey.shade400,
                        width: dobError ? 1.5 : 1.0,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dobError
                            ? Colors.red
                            : const Color(0xFFC00055),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),

                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
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
                  initialValue:
                      gender.isEmpty ? null : gender,

                  hint: const Text(
                    'Select your gender',
                  ),

                  isExpanded: true,

                  decoration: InputDecoration(
                    errorText: genderError
                        ? 'Gender is required'
                        : null,

                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: genderError
                            ? Colors.red
                            : Colors.grey.shade400,
                        width: genderError ? 1.5 : 1.0,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: genderError
                            ? Colors.red
                            : Colors.grey.shade400,
                        width: genderError ? 1.5 : 1.0,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: genderError
                            ? Colors.red
                            : const Color(0xFFC00055),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),

                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
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

                // COUNTRY
                buildLocationPicker(
                  title: 'Country *',
                  value: country,
                  hint: 'Select country',
                  hasError: countryError,
                  errorText: 'Country is required',
                  isEnabled: true,
                  onTap: () {
                    _showSearchSelection(
                      title: 'Country',
                      items: LocationService.getCountries(),
                      selectedValue: country,
                      onSelected: (val) {
                        setState(() {
                          country = val;
                          countryError = false;
                          state = '';
                          stateError = false;
                          city = '';
                          cityError = false;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 22),

                // STATE
                buildLocationPicker(
                  title: 'State *',
                  value: state,
                  hint: country.isEmpty
                      ? 'Select country first'
                      : 'Select state',
                  hasError: stateError,
                  errorText: 'State is required',
                  isEnabled: country.isNotEmpty,
                  onTap: () {
                    if (country.isEmpty) {
                      setState(() => countryError = true);
                      return;
                    }
                    _showSearchSelection(
                      title: 'State',
                      items: LocationService.getStates(country),
                      selectedValue: state,
                      onSelected: (val) {
                        setState(() {
                          state = val;
                          stateError = false;
                          city = '';
                          cityError = false;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 22),

                // CITY / DISTRICT
                buildLocationPicker(
                  title: 'City / District *',
                  value: city,
                  hint: state.isEmpty
                      ? 'Select state first'
                      : 'Select city/district',
                  hasError: cityError,
                  errorText: 'City/District is required',
                  isEnabled: state.isNotEmpty,
                  onTap: () {
                    if (country.isEmpty) {
                      setState(() => countryError = true);
                      return;
                    }
                    if (state.isEmpty) {
                      setState(() => stateError = true);
                      return;
                    }
                    _showSearchSelection(
                      title: 'City / District',
                      items: LocationService.getCities(
                        country,
                        state,
                      ),
                      selectedValue: city,
                      onSelected: (val) {
                        setState(() {
                          city = val;
                          cityError = false;
                        });
                      },
                    );
                  },
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

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }
}