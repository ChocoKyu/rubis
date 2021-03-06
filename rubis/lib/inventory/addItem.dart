// ignore_for_file: file_names, unrelated_type_equality_checks

import "package:rubis/sizeConfig.dart";
import "package:flutter/material.dart";
import "package:rubis/class/itemClass.dart";
import "package:rubis/utils/functions.dart" as functions;
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";

class ItemWidget extends StatefulWidget {
  const ItemWidget({Key key}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<ItemWidget> {
  Map<String, Map<String, List<String>>> itemInput = {
    "qrcode": {},
    "collection": {},
    "etat": {},
    "marque": {},
    "lieu": {},
    "type": {}
  };
  Map<String, String> itemInputType = {
    "qrcode": "barcode",
    "collection": "checkbox",
    "etat": "dropdown",
    "marque": "dropdown",
    "lieu": "dropdown",
    "type": "dropdown"
  };
  List<bool> isCheckedList = List.filled(20, false);
  List<String> dropdownValues = List.filled(20, "");
  List<String> selectedItemValue = <String>[];

  @override
  void initState() {
    itemInput = functions.addItem.itemInput;
    itemInputType = functions.addItem.itemInputType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<String>>> itemInput =
        functions.addItem.itemInput;
    Map<String, String> itemInputType = functions.addItem.itemInputType;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvel item"),
        actions: <Widget>[
          const Align(alignment: Alignment.center, child: Text("Ajouter")),
          IconButton(
            icon: const Icon(Icons.save_as_rounded),
            iconSize:
                IconTheme.of(context).size - SizeConfig.safeBlockVertical * 2,
            onPressed: () async {
              bool complet = true;
              functions.addItem.item.forEach((key, value) {
                if (value == "" && key != "commentaire") {
                  complet = false;
                }
              });
              if (complet) {
                await functions.addItemBDD();
                functions.addItem = Item({
                  "qrcode": "",
                  "collection": "false",
                  "etat": "",
                  "marque": "",
                  "lieu": "",
                  "type": "",
                }, {
                  "qrcode": {},
                  "collection": {},
                  "etat": {},
                  "marque": {},
                  "lieu": {},
                  "type": {}
                }, {
                  "qrcode": "barcode",
                  "collection": "checkbox",
                  "etat": "dropdown",
                  "marque": "dropdown",
                  "lieu": "dropdown",
                  "type": "dropdown"
                }, 0);
                Navigator.pop(context);
              } else {
                const snackBar =
                    SnackBar(content: Text("Informations incompl??tes."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: itemInput.length,
        itemBuilder: (BuildContext context, int index) {
          for (int i = 0; i < itemInput.length; i++) {
            selectedItemValue.add("choix");
          }
          return listWidget(context, index, itemInputType.keys.toList(),
              itemInputType, itemInput, isCheckedList, dropdownValues);
        }, // itemBuilder
      ),
    );
  }

  Object listWidget(
    BuildContext context,
    int index,
    List<String> keys,
    Map<String, String> addItemInputType,
    Map<String, Map<String, List<String>>> addItemInput,
    List<bool> isCheckedList,
    List<String> dropdownValues,
  ) {
    String title = functions.capitalize(keys[index]);
    if (addItemInputType[keys[index]] == "barcode") {
      return ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text(
          functions.addItem.item[keys[index]],
        ),
        onTap: () async {
          functions.addItem.item[keys[index]] =
              await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", false, ScanMode.DEFAULT);
          setState(() {});
        },
      );
    } else if (addItemInputType[keys[index]] == "checkbox") {
      functions.addItem.item[keys[index]] = "false";
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CheckboxListTile(
          secondary: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          value: isCheckedList[index],
          onChanged: (bool value) {
            isCheckedList[index] = value;
            functions.addItem.item[keys[index]] = value.toString();
            setState(() {});
          },
        ),
      );
    } else if (addItemInputType[keys[index]] == "dropdown") {
      dropdownValues[index] =
          functions.capitalize(addItemInput[keys[index]].keys.toList()[0]);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 15.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 25.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value:
                    functions.capitalize(selectedItemValue[index].toString()),
                icon: const Icon(
                  // Add this
                  Icons.arrow_drop_down, // Add this
                  color: Color.fromRGBO(168, 58, 46, 1), // Add this
                ),
                items: addItemInput[keys[index]]
                    .keys
                    .toList()
                    .map((value) => DropdownMenuItem(
                          value: functions.capitalize(value),
                          child: Text(functions.capitalize(value)),
                        ))
                    .toList(),
                onChanged: (value) async {
                  functions.addItem.item[keys[index]] = value.toLowerCase();
                  selectedItemValue[index] = functions.capitalize(value);
                  if (keys[index] == "type") {
                    await functions.getSettingsItem();
                  }
                  if (value.split(" ")[0] == "Ajouter") {
                    await _displayTextInputDialog(context, keys[index], index);
                  }
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      );
    } else if (addItemInputType[keys[index]] == "textfield") {
      return ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: TextField(
          decoration: InputDecoration(
            alignLabelWithHint: true,
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            labelText: "Rentrez un commentaire",
          ),
          onChanged: (String newvalue) {
            functions.addItem.item[keys[index]] = newvalue;
          },
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    }
  }

  Future<void> _displayTextInputDialog(
    BuildContext context,
    String key,
    int index,
  ) async {
    String addValue = "";
    String title = "Ajouter un/une autre " + key;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            onChanged: (value) {
              addValue = value;
              setState(() {});
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side:
                      const BorderSide(color: Color.fromRGBO(168, 58, 46, 1))),
              child: const Text(
                "Retour",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            ElevatedButton(
              child: const Text("Valider"),
              onPressed: () async {
                String keyTrad = functions.googleTrad(key, true);
                if (keyTrad != key) {
                  await functions.addSetting(keyTrad, addValue, "");
                }
                functions.addItem.itemInput[key][addValue] = [];
                functions.addItem.item[key] = addValue;
                selectedItemValue[index] = functions.capitalize(addValue);
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
