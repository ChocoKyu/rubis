library rubis.functions;

import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:rubis/class/itemClass.dart";
import "package:rubis/class/memberClass.dart";

// Partie init des variables
String ipConfig = "192.168.2.186"; //DF
// String ipConfig = "192.168.4.153"; //SIO
Member memberNew;
Member memberConnexion = Member("", "", "", "", "", "", "", "", "", "");
List<Member> newMembers = [];
List<Member> inactiveMembers = [];
List<Member> activeMembers = [];
List<Member> boardMembers = [];
List<List<Member>> allMembers = [];
List<Item> allItems = [];
bool keepLoged = false;
Item searchItem;
Item addItem = Item({
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

String capitalize(String string) {
  // Formate une chaine de caractere avec une majuscule a la premiere lettre
  return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
}

String googleTrad(String string, bool language) {
  // Traduit les mots français avec leur correspondance anglaise de la base de donnees
  Map<String, String> google = {
    "brands": "marque",
    "conditions": "etat",
    "locations": "lieu",
  };
  google.forEach((key, value) {
    if (string == value && language == true) {
      string = key;
    } else if (string == key && language == false) {
      string = value;
    }
  });

  return string;
}

Future<http.Response> addUser() {
  // Ajouter un utilisateur dans la base de donnees
  return http.post(
    Uri.parse("http://" +
        ipConfig +
        "/addMember.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
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
  // verifie la presence et le role du membre dans la abse de donnees
  String statut = "";

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/connexionMember.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
  // retourne la liste des membres de l'asso range par role
  newMembers = [];
  inactiveMembers = [];
  activeMembers = [];
  boardMembers = [];
  allMembers = [];

  String statut = "";

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getMembersList.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
  // modifie le role du membre dans la base de donnees
  return http.post(
    Uri.parse("http://" +
        ipConfig +
        "/changeMemberRole.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "pseudo": pseudo,
      "role": role.toString(),
    }),
  );
}

Future getConditionsItem() async {
  // retourne la liste des etats de la base de donnees
  List<String> conditions = ["choix"];

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getConditionsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
  }
  for (var el in conditions) {
    addItem.itemInput["etat"][el] = [];
  }
  addItem.itemInput["etat"]["ajouter un etat"] = [];
}

Future getBrandsItem() async {
  // retourne la liste des marques de la base de donnees
  List<String> brands = ["choix"];

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getBrandsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
  }
  for (var el in brands) {
    addItem.itemInput["marque"][el] = [];
  }
  addItem.itemInput["marque"]["ajouter une marque"] = [];
}

Future getLocations() async {
  // retourne la liste des lieux de la base de donnees
  List<String> lieux = ["choix"];

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getLocations.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{}),
  );

  if (response.statusCode == 200) {
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      lieux.add(jsonDecode(response.body)[i]);
    }
  }
  for (var el in lieux) {
    addItem.itemInput["lieu"][el] = [];
  }
  addItem.itemInput["lieu"]["ajouter un lieu"] = [];
}

Future getTypesItem() async {
  // retourne la liste des types de parametres de la base de donnees
  List<String> types = ["choix"];

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getTypesItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
  }
  for (var el in types) {
    addItem.itemInput["type"][el] = [];
  }
}

Future getSettingsItem() async {
  // retourne tous les parametres existant dans la base de donnees par rapport au type selectionne
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

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getSettingsItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
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
        addItem.itemInput[key]["ajouter un nouveau"] = [];
      });
    }
  }
  addItem.item["commentaire"] = "";
  addItem.itemInput["commentaire"] = {};
  addItem.itemInputType["commentaire"] = "textfield";
}

Future addSetting(table, value, condition) async {
  // ajoute un nouvel element d'un type de parametre dans la base de donnee
  return http.post(
    Uri.parse("http://" +
        ipConfig +
        "/addSetting.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{
      "table": table,
      "value": value,
      "condition": condition,
    }),
  );
}

Future addItemBDD() async {
  // ajoute un nouvel element d'un type de parametre dans la base de donnee
  return http.post(
    Uri.parse("http://" +
        ipConfig +
        "/addItem.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(addItem.item),
  );
}

Future initAddItem() async {
  await getConditionsItem();
  await getBrandsItem();
  await getLocations();
  await getTypesItem();
}

Future getInventory(String condition) async {
  allItems = [];

  final response = await http.post(
    Uri.parse("http://" +
        ipConfig +
        "/getInventory.php"), //ipconfig -all: ip  de la carte réseaux sans fil wifi si en localhost pour test (désactiver le par-feu)
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(<String, String>{"where": condition}),
  );

  if (response.statusCode == 200) {
    if (!json.decode(response.body).isEmpty) {
      json.decode(response.body).forEach(
        (key, value) {
          Item itemInventory = Item({}, {}, {}, int.parse(key));
          value.forEach(
            (thisKey, thisValue) {
              if (thisValue == 0) {
                thisValue = "non";
              } else if (thisValue == 1) {
                thisValue = "oui";
              }
              if (thisKey != "commentaire") {
                itemInventory.item[thisKey] = thisValue.toString();
              }
            },
          );
          itemInventory.item["commentaire"] = value["commentaire"];
          allItems.add(itemInventory);
        },
      );
    }
  }
}

Future deconnexion() async {
  memberConnexion = Member("", "", "", "", "", "", "", "", "", "");
}
