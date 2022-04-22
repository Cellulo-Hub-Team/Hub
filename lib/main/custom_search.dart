import 'package:cellulo_hub/main/custom.dart';
import 'package:cellulo_hub/main/custom_colors.dart';
import 'package:cellulo_hub/main/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearch extends SearchDelegate<String> {
  final List<String> allGames;

  CustomSearch({required this.allGames});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      // Define the default brightness and colors.
      //brightness: Common.darkTheme ? Brightness.dark : Brightness.light,
      primaryColor: CustomColors.currentColor,


      // Define the default font family.
      fontFamily: GoogleFonts.comfortaa().fontFamily,

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough),
        headline6: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, decoration: TextDecoration.none),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', decoration: TextDecoration.lineThrough),
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
      onPressed: (){
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
      itemBuilder: (context, index) =>
          ListTile(
            title: Text(suggestionList[index], style: Style.descriptionStyle()),
            onTap: () {
              query = suggestionList[index];
              close(context, query);
            },
          ),
    );
  }
}
