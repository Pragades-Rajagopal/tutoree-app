import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/models/feeds_model.dart';
import 'package:tutoree_app/services/feed_api_service.dart';
import 'package:tutoree_app/utils/common_utils.dart';

class AddFeedPage extends StatefulWidget {
  const AddFeedPage({super.key});

  @override
  State<AddFeedPage> createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  static const _maxLines = 10;
  var buttonColor = const Color.fromARGB(255, 214, 172, 255);
  bool _loadingIndicator = false;
  var userName = '';
  var userType = '';
  var userId = 0;

  AddFeedResponse? addFeedResponse;
  FeedsApi feedsApi = FeedsApi();

  @override
  void initState() {
    super.initState();
    getTokenData();
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name")!;
      userType = prefs.getString("user_type")!;
      userId = int.parse(prefs.getString("user_id").toString());
    });
  }

  void switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      buttonColor = const Color.fromARGB(255, 214, 172, 255);
    });
  }

  Future<void> addFeedDo(
    String content,
    int createdById,
    String createdBy,
  ) async {
    addFeedResponse = await feedsApi.saveFeed({
      "content": content,
      "createdById": createdById,
      "createdBy": createdBy,
    });
    if (addFeedResponse!.statusCode == 500) {
      errorSnackBar(
        alertDialog["oops"]!,
        alertDialog["addFeedError"]!,
      );
    } else if (addFeedResponse!.statusCode == 200) {
      successSnackBar(
        alertDialog["commonSuccess"]!,
        alertDialog["addFeedSuccess"]!,
      );
      // Route to respective page based on user type
      if (userType == 'student') {
        Get.offAndToNamed('studentHomeFeed');
      } else if (userType == 'tutor') {
        Get.offAndToNamed('tutorHome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: _maxLines * 24,
                width: 340.0,
                child: TextFormField(
                  maxLines: _maxLines,
                  controller: textController,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: 'type a feed...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF939393),
                      fontSize: 18.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFBDBDBD),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF757575),
                        width: 1.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF0000),
                        width: 1.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF757575),
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return textFieldErrors["add_feed_mandatory"];
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: buttonColor,
                  minimumSize: const Size(130, 50),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addFeedDo(textController.text, userId, userName);
                  }
                },
                child: _loadingIndicator
                    ? Container(
                        height: 50,
                        width: 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      )
                    : const Text(
                        'add',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
