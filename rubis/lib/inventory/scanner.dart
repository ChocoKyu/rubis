import 'package:flutter/material.dart';
import 'package:rubis/sizeConfig.dart';
import "package:rubis/class/itemClass.dart";
import 'package:rubis/utils/functions.dart' as functions;
import 'package:shaky_animated_listview/scroll_animator.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key key}) : super(key: key);

  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> {
  Item thisItem;
  List<String> keys;

  @override
  void initState() {
    thisItem = functions.allItems[0];
    keys = thisItem.item.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    thisItem = functions.allItems[0];
    keys = thisItem.item.keys.toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.videogame_asset),
          iconSize:
              IconTheme.of(context).size - SizeConfig.safeBlockVertical * 2,
        ),
        title: Text(thisItem.item["type"] +
            " " +
            thisItem.item["marque"] +
            " " +
            thisItem.id.toString()),
      ),
      body: AnimatedListView(
        duration: 100,
        extendedSpaceBetween: 30,
        spaceBetween: 10,
        children: List.generate(
          thisItem.item.length,
          (index) => Card(
            elevation: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shadowColor: Colors.black,
            color: Theme.of(context).colorScheme.background,
            child: SizedBox(
              height: 80,
              child: Column(
                children: [
                  Text(
                    keys[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    thisItem.item[keys[index]],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
