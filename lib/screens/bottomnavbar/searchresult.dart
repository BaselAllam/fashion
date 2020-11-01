import 'package:flutter/material.dart';



class SearchResult extends StatefulWidget {

final String className;

SearchResult(this.className);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.className,
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
        iconTheme: IconThemeData(color: Colors.black, size: 20.0),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.tune),
            itemBuilder: (BuildContext context){
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: Text('Popular'),
                  value: 'Popular',
                ),
                PopupMenuItem(
                  child: Text('Low Price'),
                  value: 'low price',
                ),
              ];
            },
            onSelected: (value) {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}