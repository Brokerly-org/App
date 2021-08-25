import 'package:brokerly/style.dart';
import 'package:brokerly/widgets/circle_button.dart';
import 'package:brokerly/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> recentSearches;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: FractionalOffset(0.95, 0.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: GestureDetector(
                  onTap: onCloseClick,
                  child: CircleButton(
                    size: 36.0,
                    iconData: Icons.close_sharp,
                    onTap: onCloseClick,
                    iconSize: 23,
                    bgColor: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 21.0),
              child: Text(
                "Search",
                style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SearchField(
              hint: "Enter the bot name",
              iconData: Icons.search,
              onChanged: onChanged,
            ),
            // if (recentSearches.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 21.0, top: 15.0),
            //     child: Text(
            //       "Recent Searches",
            //       style: TextStyle(
            //         fontSize: 22.0,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       textAlign: TextAlign.left,
            //     ),
            //   ),
            // if (recentSearches.isNotEmpty)
            //   SizedBox(
            //     height: 30,
            //   ),
            // if (recentSearches.isNotEmpty)
            //   Expanded(
            //     child: SingleChildScrollView(
            //       child: Column(
            //         children: [
            //           // for (var search in recentSearches)
            //           //   LastSearchItem(
            //           //     text: search,
            //           //     onTap: onSubmitted,
            //           //   ),
            //           Divider(
            //             color: Color(0xFF2D2E42),
            //             thickness: 1,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            //if (recentSearches.isEmpty)
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "No Searches Yet.",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      "You can find any bot from our bot collection\nType the bot name in the field above.",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void updateRecentSearches(String newSearch) {}

  void onChanged(String text) {}

  void onCloseClick() {
    Navigator.pop(context);
  }
}
