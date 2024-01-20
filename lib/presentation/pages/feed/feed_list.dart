import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tutoree_app/data/models/feeds_model.dart';
import 'package:tutoree_app/presentation/pages/feed/add_feed.dart';
import 'package:tutoree_app/data/services/feed_api_service.dart';

class CommonFeedsPage extends StatefulWidget {
  const CommonFeedsPage({super.key});

  @override
  State<CommonFeedsPage> createState() => _CommonFeedsPageState();
}

class _CommonFeedsPageState extends State<CommonFeedsPage> {
  ScrollController _scrollController = ScrollController();
  bool _addIconVisible = true;
  FeedsListResponse? feedsListRes;
  FeedsApi apiService = FeedsApi();
  List<Map<String, dynamic>> feedList = [];
  bool _isApiLoading = true;

  @override
  void initState() {
    super.initState();
    getFeedsDo();
    hideAddButton();
  }

  ///Hides add (floating action button) upon scrolling
  void hideAddButton() {
    _scrollController = ScrollController();
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

  Future<void> getFeedsDo() async {
    feedsListRes = await apiService.getGlobalFeeds();
    setState(() {
      feedList.addAll(feedsListRes!.data);
      _isApiLoading = false;
    });
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
        body: _isApiLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
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
                    ],
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
                child: const Icon(Icons.post_add_rounded),
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
          'oops! unable to fetch\nglobal feeds at the moment',
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
        itemCount: lists.length,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      lists[index]["content"],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade100,
                    height: 2,
                    width: 350,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lists[index]["createdBy"],
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF757575),
                        ),
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
        },
      );
    }
  }
}
