import 'package:flutter/material.dart';
import 'package:rubis/sizeConfig.dart';
// import 'package:rubis/utils/functions.dart' as functions;

class Inventory extends StatefulWidget {
  const Inventory({Key key}) : super(key: key);

  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<Inventory> {
  List<String> typeItems = [];

  @override
  void initState() {
    // typeItems = functions.typeItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // typeItems = functions.typeItems;
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
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: typeItems.isNotEmpty ? typeItems.length : 1,
        itemBuilder: (BuildContext context, int index) => listItemType(index),
      ),
    );
  }

  Widget listItemType(int index) {
    // String text = typeItems[index];

    return const Material(
      color: Colors.transparent,
      child: Card(),
      // child: ExpansionTile(
      //   trailing: const Icon(
      //     Icons.keyboard_arrow_down_rounded,
      //     color: Color.fromARGB(255, 77, 77, 77),
      //   ),
      //   leading: const Icon(
      //     Icons.access_time_filled_rounded,
      //     size: 40,
      //     color: Color.fromARGB(255, 92, 92, 92),
      //   ),
      //   title: Text(
      //     text,
      //     style: const TextStyle(
      //       fontSize: 20,
      //       color: Color.fromARGB(255, 34, 34, 34),
      //     ),
      //   ),
      //   children: <Widget>[
      //     // Card(),
      //     SizedBox(
      //       width: 50.0,
      //       height: typeItems.isNotEmpty ? 200.00 : 100.00,
      //       child: ListView.builder(
      //         physics: const ClampingScrollPhysics(),
      //         scrollDirection: Axis.horizontal,
      //         shrinkWrap: true,
      //         // itemCount: newMembers.isNotEmpty ? newMembers.length : 1,
      //         itemCount: 1,
      //         itemBuilder: (BuildContext context, int index) =>
      //             buildNewMember(context, index),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
