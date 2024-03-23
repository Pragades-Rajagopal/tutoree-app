import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/data/models/feeds_model.dart';
import 'package:tutoree_app/presentation/pages/feed/add_feed.dart';
import 'package:tutoree_app/data/services/feed_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFeedsPage extends StatefulWidget {
  const CommonFeedsPage({super.key});

  @override
  State<CommonFeedsPage> createState() => _CommonFeedsPageState();
}

class _CommonFeedsPageState extends State<CommonFeedsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _addIconVisible = true;
  FeedsListResponse? feedsListRes;
  FeedUserData? feedUserDataRes;
  UpdateUpvoteResponse? updateUpvoteRes;
  FeedsApi apiService = FeedsApi();
  List<Map<String, dynamic>> feedList = [];
  bool _isApiLoading = true;
  int _userId = 0;
  String _token = '';
  // feed pagination
  final int _limit = 25;
  int _offset = 0;
  bool _hasFeedData = true;

  @override
  void initState() {
    super.initState();
    getTokenData();
    hideAddButton();
    pagination();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = int.parse(prefs.getString("user_id").toString());
      _token = prefs.getString("token")!;
    });
    getFeedsDo(_limit, _offset, _token);
  }

  ///Hides add (floating action button) upon scrolling
  void hideAddButton() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addIconVisible) {
          setState(() {
            _addIconVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_addIconVisible) {
          setState(() {
            _addIconVisible = true;
          });
        }
      }
    });
  }

  /// Pagination of feeds
  void pagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (_hasFeedData) {
          getFeedsDo(_limit, _offset, _token);
        }
      }
    });
  }

  Future<void> getFeedsDo(int limit, int offset, String token) async {
    feedsListRes = await apiService.getGlobalFeeds(limit, offset, token);
    int localOffset = _offset + 25;
    setState(() {
      // feedList.clear();
      feedList.addAll(feedsListRes!.data);
      _isApiLoading = false;
      _offset = localOffset;
      if (feedsListRes!.data.length < _limit) {
        _hasFeedData = false;
      }
    });
  }

  Future<void> getFeedUserDataDo(int userId) async {
    feedUserDataRes = await apiService.getFeedUserData(userId, _token);
    if (feedUserDataRes!.email != null) {
      if (!mounted) return;
      bottomSheet(context);
    }
  }

  Future<void> updateUpvoteDo(int id, String token) async {
    updateUpvoteRes = await apiService.updateUpvote(id, token);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isApiLoading = true;
              feedList.clear();
              _offset = 0;
              _hasFeedData = true;
            });
            await getFeedsDo(_limit, _offset, _token);
          },
          color: Colors.black,
          child: _isApiLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('global feeds...'),
                        const SizedBox(
                          height: 6.0,
                        ),
                        feedsWidget(feedList),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        floatingActionButton: _addIconVisible
            ? FloatingActionButton(
                onPressed: () {
                  Get.to(() => const AddFeedPage());
                },
                backgroundColor: Colors.black87,
                splashColor: Colors.grey,
                tooltip: 'add feed',
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget feedsWidget(List lists) {
    if (lists.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'no feeds at the moment',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: lists.length + 1,
        itemBuilder: (context, index) {
          if (index < lists.length) {
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                      child: LinkifyText(
                        lists[index]["content"],
                        linkStyle: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 14,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        linkTypes: const [LinkType.url, LinkType.email],
                        onTap: (link) async {
                          if (link.type == LinkType.url) {
                            await launchUrl(Uri.parse('${link.value}'));
                          } else if (link.type == LinkType.email) {
                            final Uri params = Uri(
                              scheme: 'mailto',
                              path: '${link.value}',
                            );
                            String url = params.toString();
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_upward_sharp,
                            size: 18.0,
                          ),
                          onTap: () async {
                            await updateUpvoteDo(lists[index]["id"], _token);
                          },
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        lists[index]["upvotes"] == 0 ||
                                lists[index]["upvotes"] == 1
                            ? Text(
                                '${lists[index]["upvotes"]} upvote',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF757575),
                                ),
                              )
                            : Text(
                                '${lists[index]["upvotes"]} upvotes',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF757575),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      height: 2,
                      width: 350,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        lists[index]["createdById"] == _userId
                            ? const Text(
                                'you',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF757575),
                                ),
                              )
                            : GestureDetector(
                                child: Text(
                                  '${lists[index]["createdBy"]} •',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () async {
                                  await getFeedUserDataDo(
                                      lists[index]["createdById"]);
                                },
                              ),
                        Text(
                          lists[index]["date"],
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
          } else {
            return Center(
              child: _hasFeedData
                  ? const Text(
                      'crunching the data...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  : const Text(
                      'no more feeds!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
            );
          }
        },
      );
    }
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      elevation: 100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: ((context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
                    child: Text(
                      '${feedUserDataRes?.name}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF484848),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                    child: Text(
                      '${feedUserDataRes?.userType}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 141, 141, 141),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  //   child: Text(
                  //     '${feedUserDataRes?.email}',
                  //     style: const TextStyle(
                  //       fontSize: 18.0,
                  //       color: Color(0xFF484848),
                  //     ),
                  //   ),
                  // ),
                  feedUserDataRes?.websites != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '${feedUserDataRes?.websites}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF484848),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  feedUserDataRes?.bio != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '${feedUserDataRes?.bio}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                    child: Text(
                      '${feedUserDataRes?.interests}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF484848),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
