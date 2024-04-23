import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/common_model.dart';
import 'package:tutoree_app/data/models/tutor_model.dart';
import 'package:tutoree_app/data/services/common_api_service.dart';
import 'package:tutoree_app/data/services/tutor_api_service.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

class TutorEditProfilePage extends StatefulWidget {
  final String bio;
  final String websites;
  final int mailSubscription;
  final List<int> tutorInterests;
  const TutorEditProfilePage({
    super.key,
    required this.bio,
    required this.websites,
    required this.mailSubscription,
    required this.tutorInterests,
  });

  @override
  State<TutorEditProfilePage> createState() => _TutorEditProfilePageState();
}

class _TutorEditProfilePageState extends State<TutorEditProfilePage> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final bioController = TextEditingController();
  final websiteController = TextEditingController();
  int userId = 0;
  String _token = '';
  List<Course> courseList = [];
  CourseApi courseApiService = CourseApi();
  List<int> selectCourses = [];
  TutorApi tutorApiService = TutorApi();
  PostTutorProfiletRes? postTutorProfiletRes;
  bool _loadingIndicator = false;
  var _buttonColor = Colors.black;
  int _mailSubSelectorValue = 0;

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    getTokenData();
    // setting values for text controllers
    setState(() {
      bioController.text = widget.bio;
      websiteController.text = widget.websites;
      _mailSubSelectorValue = widget.mailSubscription;
      selectCourses.addAll(widget.tutorInterests);
    });
    await getCourseListDo();
  }

  void _stopLoadingIndicator() {
    setState(() {
      _loadingIndicator = false;
      _buttonColor = Colors.black;
    });
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString("user_id").toString());
      _token = prefs.getString("token")!;
    });
  }

  Future<void> getCourseListDo() async {
    List<Course> data = await courseApiService.getCourseList();
    setState(() {
      courseList.addAll(data);
    });
  }

  Future<void> addProfileDo(int tutorId, List<int> courseIds, String bio,
      String website, int mailSubscription, String token) async {
    postTutorProfiletRes = await tutorApiService.addProfile(
      {
        "tutorId": tutorId,
        "courseIds": courseIds,
        "bio": bio,
        "websites": website,
        "mailSubscription": mailSubscription,
      },
      token,
    );
    if (postTutorProfiletRes?.statusCode == 400) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['addIntrstCheckError']!,
      );
    } else if (postTutorProfiletRes?.statusCode == 500) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['commonError']!,
      );
    } else if (postTutorProfiletRes?.statusCode == 200) {
      _stopLoadingIndicator();
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['interestAdded']!,
      );
      Get.offAndToNamed('tutorHomeProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 90, 10, 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  maxLines: 3,
                  controller: bioController,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'bio',
                    hintStyle: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF757575),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  controller: websiteController,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'website',
                    hintStyle: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF757575),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _mailSubscriptionSelector(0,
                      text: "don't send mail", icon: Icons.cancel),
                  _mailSubscriptionSelector(1,
                      text: "send mail", icon: Icons.mark_email_read_sharp),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 16),
                    child: Text(
                      '*if subscribed, mails will be received whenever\n  students send a request',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 350,
                child: MultiSelectDialogField(
                  backgroundColor: Colors.white,
                  title: const Text('select interests'),
                  buttonText: const Text(
                    'select interests',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  key: _key,
                  searchable: true,
                  selectedColor: Colors.black54,
                  selectedItemsTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  items: courseList
                      .map((e) => MultiSelectItem(e.id, e.name))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  initialValue: widget.tutorInterests,
                  onConfirm: (values) {
                    selectCourses = values;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return textFieldErrors["add_interest_mandatory"];
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _buttonColor,
                  minimumSize: const Size(100, 40),
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
                  if (_key.currentState!.validate()) {
                    setState(() {
                      _loadingIndicator = true;
                      _buttonColor = Colors.white;
                      addProfileDo(
                        userId,
                        selectCourses,
                        bioController.text,
                        websiteController.text,
                        _mailSubSelectorValue,
                        _token,
                      );
                    });
                  }
                },
                child: _loadingIndicator
                    ? Container(
                        height: 50,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: loadingIndicator(),
                      )
                    : const Text(
                        'update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'courses you are looking for are unavailable?\nmail to ${commonConfig["support_email"]}\nand we will verify and add them',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for mail subscription option selection
  Widget _mailSubscriptionSelector(int index,
      {String text = '', IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 8),
      child: InkResponse(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  _mailSubSelectorValue == index ? Colors.black : Colors.grey,
            ),
            Text(
              text,
              style: TextStyle(
                color:
                    _mailSubSelectorValue == index ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () => setState(
          () {
            _mailSubSelectorValue = index;
          },
        ),
      ),
    );
  }
}
