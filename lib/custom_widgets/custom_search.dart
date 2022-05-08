import 'package:flutter/material.dart';
import 'package:cellulo_hub/custom_widgets/custom_colors.dart';
import 'package:cellulo_hub/custom_widgets/style.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main/common.dart';

class CustomSearch extends SearchDelegate<String> {
  final List<String> allGames;

  CustomSearch({required this.allGames});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme(
          //primary: Common.darkTheme ? Colors.white : CustomColors.currentColor,
          primary: CustomColors.currentColor,
          secondary: Colors.white,
          brightness: Common.darkTheme ? Brightness.dark : Brightness.light,
          onSecondary: Colors.white,
          onError: Colors.white,
          onBackground: Colors.white,
          error: Colors.white,
          surface: CustomColors.currentColor,
          onPrimary: Colors.white,
          background: Colors.white,
          onSurface: Colors.white),

      fontFamily: GoogleFonts.comfortaa().fontFamily,

      textTheme: const TextTheme(
        headline6: TextStyle(
            fontSize: 24
        )
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> result = allGames
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(result[index], style: Style.descriptionStyle()),
              onTap: () {
                query = result[index];
                close(context, query);
              },
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = allGames
        .where((name) => name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index], style: Style.descriptionStyle()),
        onTap: () {
          query = suggestionList[index];
          close(context, query);
        },
      ),
    );
  }
}
