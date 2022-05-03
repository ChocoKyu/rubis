import 'package:flutter/material.dart';
import 'package:rubis/sizeConfig.dart';
import "package:rubis/class/itemClass.dart";
import 'package:rubis/utils/functions.dart' as functions;
import 'package:shaky_animated_listview/scroll_animator.dart';
import 'package:shaky_animated_listview/widgets/animated_gridview.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key key}) : super(key: key);

  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  List<Item> allItems = [];

  @override
  void initState() {
    allItems = functions.allItems;
    super.initState();
  }

  List<Color> colors = List.filled(functions.allItems.length, Colors.white);

  @override
  Widget build(BuildContext context) {
    allItems = functions.allItems;

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
        title: const Text('Inventaire'),
      ),
      body: AnimatedGridView(
        duration: 100,
        crossAxisCount: 2,
        mainAxisExtent: 256,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(
          functions.allItems.length,
          (index) => Card(
            elevation: 50,
            color: Theme.of(context).colorScheme.background,
            child: SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  _showText(context, allItems[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/474x/92/78/0d/92780ddfa1283f24297b855f6e31ef9f.jpg"),
                          //NetworkImage
                          radius: 50,
                        ),
                      ),
                      Text(
                        allItems[index].item["type"],
                        style: TextStyle(
                            color: colors[index],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        allItems[index].item["marque"],
                        style: TextStyle(
                            color: colors[index],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        allItems[index].id.toString(),
                        style: TextStyle(
                            color: colors[index],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showText(BuildContext context, Item thisItem) {
    String text = "";
    thisItem.item.forEach(
      (key, value) {
        text += key + ": " + value + "\n";
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
