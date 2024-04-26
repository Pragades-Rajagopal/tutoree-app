import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoree_app/data/services/common_api_service.dart';

BorderRadius searchBarRadius = BorderRadius.circular(30.0);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  // String _userName = '';
  String _token = '';
  SearchApi searchApi = SearchApi();
  List<dynamic> searchResult = [];
  int searchResultCount = 0;
  String _searchValue = '';
  bool _searchResultVisibility = false;

  @override
  void initState() {
    super.initState();
    getTokenData();
    setState(() {
      searchResult.clear();
      _searchValue = '';
    });
  }

  Future<void> getTokenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // _userName = prefs.getString("user_name").toString();
      _token = prefs.getString("token")!;
    });
  }

  Future<void> getSearchResult(String value, String token) async {
    Map<String, dynamic> result = await searchApi.getSearchResult(value, token);
    searchResult.clear();
    searchResult.addAll(result["result"]);
    searchResultCount = result["count"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 360.0,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: 'search something',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: searchBarRadius,
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: Colors.black26,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: searchBarRadius,
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: Colors.black54,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white12,
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.text = '';
                      },
                    ),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (textController.text != '') {
                          setState(() {
                            _searchValue = textController.text;
                            _searchResultVisibility = true;
                          });
                        }
                      },
                    ),
                  ),
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onSubmitted: (data) {
                    if (textController.text != '') {
                      setState(() {
                        _searchValue = textController.text;
                        _searchResultVisibility = true;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_searchResultVisibility) ...{
                // Text('showing $searchResultCount results...'),
                searchResultBuilder(_searchValue, _token),
              }
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> searchResultBuilder(String value, String token) {
    return FutureBuilder(
      future: getSearchResult(value, token),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (searchResult.isEmpty) {
              return const Center(
                child: Text(
                  "no result for the search",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return searchResultView(searchResult);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        } catch (e) {
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }

  Widget searchResultView(List searchResult) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResult.length,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                  child: Text(
                    searchResult[index]["tbl_nm"],
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                  child: Text(
                    searchResult[index]["field1"],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Text(
                    searchResult[index]["field2"],
                    style: const TextStyle(
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                  child: Text(
                    searchResult[index]["field3"],
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
