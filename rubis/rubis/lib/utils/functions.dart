library rubis.functions;

import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:rubis/class/itemClass.dart";
import "package:rubis/class/memberClass.dart";

Member memberNew;
Member memberConnexion = Member("", "", "", "", "", "", "", "", "", "");
List<Member> newMembers = [];
List<Member> inactiveMembers = [];
List<Member> activeMembers = [];
List<Member> boardMembers = [];
List<List<Member>> allMembers = [];
bool keepLoged = false;
Item searchItem;
Item addItem = Item({
  "qrcode": "",
  "item collection": "",
  "etat": "",
  "marque": "",
  "lieu": "",
  "type": "",
}, {
  "qrcode": {},
  "item collection": {},
  "etat": {},
  "marque": {},
  "lieu": {},
  "type": {}
}, {
  "qrcode": "barcode",
  "item collection": "checkbox",
  "etat": "dropdown",
  "marque": "dropdown",
  "lieu": "dropdown",
  "type": "dropdown"
});

String capitalize(String string) {
  return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
}

Future<http.Response> addUser() {
  return http.post(
    Uri.parse(
        "http://192.168.4.153/addMember.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "firstname": memberNew.firstname.toLowerCase(),
      "lastname": memberNew.lastname.toLowerCase(),
      "pseudo": memberNew.pseudo.toLowerCase(),
      "password": memberNew.password,
      "phone": memberNew.phone,
      "email": memberNew.email.toLowerCase(),
    }),
  );
}

Future<String> login() async {
  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/connexionMember.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "pseudo": memberConnexion.pseudo,
      "password": memberConnexion.password,
    }),
  );
  if (response.statusCode == 200) {
    if (jsonDecode(response.body).length == 0) {
      statut = "invalide";
    } else {
      memberConnexion.role = jsonDecode(response.body)[0]["name"].toString();
      statut = "valide";
    }
  } else {
    statut = "echec";
  }
  return statut;
}

Future<String> getMembersList() async {
  newMembers = [];
  inactiveMembers = [];
  activeMembers = [];
  boardMembers = [];
  allMembers = [];

  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getMembersList.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)["new"][0].length != 0) {
      for (MapEntry e in jsonDecode(response.body)["new"][0].entries) {
        newMembers.add(Member(
            e.key.toString(),
            e.value[0].toString(),
            e.value[1].toString(),
            "",
            "",
            e.value[3].toString(),
            e.value[2].toString(),
            "",
            e.value[4].toString(),
            ""));
      }
    }
    if (jsonDecode(response.body)["inactive"][0].length != 0) {
      for (MapEntry e in jsonDecode(response.body)["inactive"][0].entries) {
        inactiveMembers.add(Member(
            e.key.toString(),
            e.value[0].toString(),
            e.value[1].toString(),
            "",
            "",
            e.value[3].toString(),
            e.value[2].toString(),
            "",
            e.value[4].toString(),
            ""));
      }
    }
    if (jsonDecode(response.body)["active"][0].length != 0) {
      for (MapEntry e in jsonDecode(response.body)["active"][0].entries) {
        activeMembers.add(Member(
            e.key.toString(),
            e.value[0].toString(),
            e.value[1].toString(),
            "",
            "",
            e.value[3].toString(),
            e.value[2].toString(),
            "",
            e.value[4].toString(),
            ""));
      }
    }
    if (jsonDecode(response.body)["board"][0].length != 0) {
      for (MapEntry e in jsonDecode(response.body)["board"][0].entries) {
        boardMembers.add(Member(
            e.key.toString(),
            e.value[0].toString(),
            e.value[1].toString(),
            "",
            "",
            e.value[3].toString(),
            e.value[2].toString(),
            "",
            e.value[4].toString(),
            ""));
      }
    }
    allMembers.add(newMembers);
    allMembers.add(inactiveMembers);
    allMembers.add(activeMembers);
    allMembers.add(boardMembers);
  } else {
    statut = "echec";
  }
  return statut;
}

Future<http.Response> changeMemberRole(String pseudo, int role) {
  return http.post(
    Uri.parse(
        "http://192.168.4.153/changeMemberRole.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "pseudo": pseudo,
      "role": role.toString(),
    }),
  );
}

Future<String> getConditionsItem() async {
  List<String> conditions = ["choix"];
  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getConditionsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      conditions.add(jsonDecode(response.body)[i]);
    }
    // conditionsItem.add("ajouter un état");
  } else {
    statut = "echec";
  }
  for (var el in conditions) {
    addItem.itemInput["etat"][el] = [];
  }
  addItem.itemInput["etat"]["add"] = [];
  return statut;
}

Future<String> getBrandsItem() async {
  List<String> brands = ["choix"];
  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getBrandsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      brands.add(jsonDecode(response.body)[i]);
    }
    // brandsItem.add("ajouter une marque");
  } else {
    statut = "echec";
  }
  for (var el in brands) {
    addItem.itemInput["marque"][el] = [];
  }
  addItem.itemInput["marque"]["add"] = [];
  return statut;
}

Future<String> getLieuxItem() async {
  List<String> lieux = ["choix"];
  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getLieuxItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      lieux.add(jsonDecode(response.body)[i]);
    }
  } else {
    statut = "echec";
  }
  for (var el in lieux) {
    addItem.itemInput["lieu"][el] = [];
  }
  addItem.itemInput["lieu"]["add"] = [];
  return statut;
}

Future<String> getTypesItem() async {
  List<String> types = ["choix"];
  String statut = "";

  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getTypesItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      types.add(jsonDecode(response.body)[i]);
    }
    // typesItem.add("ajouter un type");
  } else {
    statut = "echec";
  }
  for (var el in types) {
    addItem.itemInput["type"][el] = [];
  }
  addItem.itemInput["type"]["add"] = [];
  return statut;
}

Future<String> getSettingsItem() async {
  // on vide les deux dictionnaires qui contiennent les paramètres correspondant à un type particulier

  int index = 0;
  List<String> itemInputRemove = ["choix"];
  addItem.itemInput.forEach((key, value) {
    if (index > 5) {
      itemInputRemove.add(key);
    }
    index++;
  });
  for (String key in itemInputRemove) {
    addItem.item.remove(key);
    addItem.itemInput.remove(key);
    addItem.itemInputType.remove(key);
  }

  String statut = "";
  final response = await http.post(
    Uri.parse(
        "http://192.168.4.153/getSettingsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "type": addItem.item["type"],
    }),
  );

  if (response.statusCode == 200) {
    if (!json.decode(response.body).isEmpty) {
      json.decode(response.body).forEach((key, value) {
        index = 0;
        addItem.itemInput[key] = {};
        addItem.itemInput[key]["choix"] = [];
        for (String el in value) {
          addItem.item[key] = "";
          if (index == 0) {
            addItem.itemInputType[key] = el;
          } else if (el != null) {
            addItem.itemInput[key][el] = [];
          }
          index++;
        }
        addItem.itemInput[key]["add"] = [];
      });
    }
  } else {
    statut = "echec";
  }
  addItem.item["commentaire"] = "";
  addItem.itemInput["commentaire"] = {};
  addItem.itemInputType["commentaire"] = "textfield";
  return statut;
}

Future initAddItem() async {
  await getConditionsItem();
  await getBrandsItem();
  await getLieuxItem();
  await getTypesItem();
}

Future deconnexion() async {
  memberConnexion = Member("", "", "", "", "", "", "", "", "", "");
}
