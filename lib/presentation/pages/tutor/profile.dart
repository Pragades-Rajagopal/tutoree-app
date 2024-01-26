import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/config/constants.dart';
import 'package:tutoree_app/data/models/feeds_model.dart';
import 'package:tutoree_app/data/models/login_model.dart';
import 'package:tutoree_app/data/models/tutor_model.dart';
import 'package:tutoree_app/data/services/feed_api_service.dart';
import 'package:tutoree_app/data/services/login_api_service.dart';
import 'package:tutoree_app/presentation/pages/login.dart';
import 'package:tutoree_app/data/services/tutor_api_service.dart';
import 'package:tutoree_app/presentation/pages/tutor/edit_profile.dart';
import 'package:tutoree_app/presentation/utils/common_utils.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({super.key});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  int _userId = 0;
  String _userEmail = '';
  TutorApi apiService = TutorApi();
  FeedsApi feedsApiService = FeedsApi();
  LoginApi loginApiService = LoginApi();
  DeactivationApi deactivationApiService = DeactivationApi();
  TutorProfile? tutorProfile;
  DeleteFeedResponse? deleteFeedRes;
  LogoutResponse? logoutResponse;
  DeactivationResponse? deactivationRes;
  List interests = [];
  List<int> interestIds = [0];
  List feeds = [];
  String _interestsHeader = 'no interests! try adding some courses';
  bool _isApiLoading = true;
  final String _deviceType = 'app';

  @override
  void initState() {
    super.initState();
    getTokenData();
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = int.parse(prefs.getString("user_id").toString());
      _userEmail = prefs.getString("user_email")!;
    });
    getStudentProfileDo(_userId);
  }

  Future<void> getStudentProfileDo(int userId) async {
    tutorProfile = await apiService.getTutorProfile(userId);
    setState(() {
      feeds.clear();
      interests.clear();
      feeds.addAll(tutorProfile!.feeds);
      interests.addAll(tutorProfile!.interests);
      interestIds.clear();
      for (var element in tutorProfile!.interests) {
        interestIds.add(element["courseId"]);
      }
      _isApiLoading = false;
    });
    _changeInterestHeader();
  }

  Future<void> deleteFeedDo(int id) async {
    // Load page
    setState(() {
      _isApiLoading = true;
    });
    deleteFeedRes = await feedsApiService.deleteFeed(id);
    if (deleteFeedRes!.statusCode == 400) {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['deleteFeedError']!,
      );
    } else if (deleteFeedRes!.statusCode == 200) {
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['deleteFeed']!,
      );
      getStudentProfileDo(_userId);
    }
  }

  Future<void> logoutDo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logoutResponse = await loginApiService.logout({"email": email});
    if (logoutResponse!.statusCode == 200) {
      prefs.remove("token");
      Get.offAll(() => const LoginPage());
    } else {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['commonError']!,
      );
    }
  }

  Future<void> deactivateDo(String email, String deviceType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deactivationRes = await deactivationApiService.deactivate({
      "email": email,
      "deviceType": deviceType,
    });
    if (deactivationRes!.statusCode == 200) {
      prefs.remove("token");
      successSnackBar(
        alertDialog['commonSuccess']!,
        alertDialog['deactivationSuccess']!,
      );
      Get.offAll(() => const LoginPage());
    } else {
      errorSnackBar(
        alertDialog['oops']!,
        alertDialog['commonError']!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isApiLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text(
                          '${tutorProfile?.email}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                        child: Text(
                          '${tutorProfile?.mobileNum}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                        child: Text(
                          tutorProfile?.bio == ""
                              ? "(bio)"
                              : '${tutorProfile?.bio}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                        child: Text(
                          tutorProfile?.websites == ""
                              ? "(websites)"
                              : '${tutorProfile?.websites}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: 1000.0,
                        alignment: Alignment.center,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                        child: Text(
                          tutorProfile?.mailSubscription == 0
                              ? "not subscribed to mail"
                              : 'subscribed to mail',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text(
                          '*if subscribed, mails will be received whenever\n  students send a request',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: 1000.0,
                        alignment: Alignment.center,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text(
                          _interestsHeader,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                      Wrap(
                        children: List<Widget>.generate(
                          interests.length,
                          (int index) {
                            return SizedBox(
                              height: 42.0,
                              child: Chip(
                                label: Text(
                                  interests[index]["courseName"],
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                backgroundColor: Colors.grey.shade200,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => TutorEditProfilePage(
                                bio: '${tutorProfile?.bio}',
                                websites: '${tutorProfile?.websites}',
                                mailSubscription: int.parse(
                                    '${tutorProfile?.mailSubscription}'),
                                tutorInterests: interestIds,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                          child: Container(
                            height: 30,
                            width: 140,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: Text(
                              interests.isEmpty
                                  ? 'add interests'
                                  : 'edit interests',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: 1000.0,
                        alignment: Alignment.center,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text(
                          'feeds (${feeds.length})',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feeds.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical: 5.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            shadowColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: Text(
                                            feeds[index]["content"],
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          deleteFeedDo(feeds[index]["id"]);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 22.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Colors.grey.shade100,
                                    height: 2,
                                    width: 350,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        feeds[index]["created_by"],
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                      Text(
                                        feeds[index]["date_"],
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 0.5,
                        width: 1000.0,
                        alignment: Alignment.center,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.fromLTRB(4, 24, 4, 8),
                      ),
                      GestureDetector(
                        onTap: () {
                          logoutDo(_userEmail);
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Text(
                            'logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          deactivateDo(_userEmail, _deviceType);
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Text(
                            'deactivate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 0, 0),
                        child: Text(
                          '!this will delete your interests, feeds, user data from the system. you can create an account anytime',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(4, 1, 0, 0),
                        child: Text(
                          '*double tab to deactivate',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /// Method to change the interest header
  /// based on interest count
  void _changeInterestHeader() {
    if (interests.isEmpty) {
      setState(() {
        _interestsHeader = _interestsHeader;
      });
    } else {
      setState(() {
        _interestsHeader = 'interests (${interests.length})';
      });
    }
  }
}
