// ignore_for_file: file_names
import "package:rubis/sizeConfig.dart";
import "package:flutter/material.dart";
import "package:rubis/class/itemClass.dart";
import "package:rubis/userSecurStorage.dart";
import "package:rubis/inventory/addItem.dart";
import "package:rubis/inventory/scanner.dart";
import "package:rubis/inventory/inventory.dart";
import "package:rubis/manage_member/manageMember.dart";
import "package:rubis/utils/functions.dart" as functions;
import "package:permission_handler/permission_handler.dart";
import "package:flutter_barcode_scanner/flutter_barcode_scanner.dart";

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // demande de permission pour activer la camera
  final cameraRequest = Permission.camera.request();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // bar du haut: nom appliction: utilisateur connecté + déconnexion
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {},
            icon: const Icon(Icons.videogame_asset),
            iconSize:
                IconTheme.of(context).size - SizeConfig.safeBlockVertical * 2),
        title: Text(functions.capitalize(functions.memberConnexion.pseudo) +
            " - " +
            functions.memberConnexion.role),
        actions: <Widget>[
          const Align(alignment: Alignment.center, child: Text("Déconnexion")),
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            iconSize:
                IconTheme.of(context).size - SizeConfig.safeBlockVertical * 2,
            onPressed: () async {
              //deconnexion: nettoyage du storage & variables utilisateur + retour page de connexion
              await functions.deconnexion();
              await UserSecureStorage().clearStorage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: OrientationBuilder(
                // verification de l orientation de l écran pour affichage responsive
                builder: (context, orientation) {
                  return Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                      itemCount: functions.memberConnexion.role == "inactif"
                          ? 1
                          : functions.memberConnexion.role == "bureau"
                              ? 4
                              : 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: CardMenu(
                            index: index,
                            orientation: orientation,
                          ),
                        );
                      }, // itemBuilder
                    ),
                  );
                }, // builder
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  // init des variables de la class
  final int index;
  final Orientation orientation;

  // recuperation des variables de la class
  const CardMenu({
    Key key,
    this.index,
    this.orientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Liste des titres et icons des boutons
    var menuTitle = [];
    var menuIcon = [];
    if (functions.memberConnexion.role == "inactif") {
      // si le membre n est pas actif aucuns boutons disponibles
      menuTitle = ["Compte innactif"];
      menuIcon = [Icons.warning_rounded];
    } else if (functions.memberConnexion.role == "actif") {
      // si le membre est actif boutons de stocks disponibles
      menuTitle = ["Scanner un QRCode", "Ajouter un item", "Voir l'inventaire"];
      menuIcon = [Icons.qr_code, Icons.add_box_rounded, Icons.summarize];
    } else if (functions.memberConnexion.role == "bureau") {
      // si le membre est bureau aout du bouton gestion des membres
      menuTitle = [
        "Scanner un QRCode",
        "Ajouter un item",
        "Voir l'inventaire",
        "Gérer les membres"
      ];
      menuIcon = [
        Icons.qr_code,
        Icons.add_box_rounded,
        Icons.summarize,
        Icons.account_box
      ];
    }

    // construction des boutons
    return Padding(
      // padding responsive
      padding: orientation == Orientation.portrait
          ? EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 1,
              horizontal: SizeConfig.safeBlockHorizontal * 10)
          : EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 10,
              horizontal: SizeConfig.safeBlockHorizontal * 1),
      child: InkWell(
        child: Container(
          height: orientation == Orientation.portrait
              ? SizeConfig.safeBlockVertical * 20
              : double.infinity,
          width: orientation == Orientation.portrait
              ? double.infinity
              : SizeConfig.safeBlockHorizontal * 22,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(menuIcon[index],
                    color: Theme.of(context).colorScheme.onPrimary),
                const Spacer(),
                Text(
                  menuTitle[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: orientation == Orientation.portrait
                          ? SizeConfig.safeBlockVertical * 3.5
                          : SizeConfig.safeBlockHorizontal * 3,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          if (index == 0) {
            if (functions.memberConnexion.role != "inactif") {
              String cameraScanResult = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", false, ScanMode.DEFAULT);
              await functions.getInventory(
                  "WHERE items.qrcode = '" + cameraScanResult + "'");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scanner(),
                ),
              );
            } else {
              const snackBar = SnackBar(
                  content: Text(
                      "Votre compte est inactif, contactez un administrateur."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else if (index == 1) {
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
            await functions.initAddItem();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemWidget(),
              ),
            );
          } else if (index == 2) {
            await functions.getInventory("");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Inventory(),
              ),
            );
          } else if (index == 3) {
            if (await functions.getMembersList() != "echec") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageMember(),
                ),
              );
            } else {
              const snackBar = SnackBar(
                  content: Text("Echec de la connexion à la base de donnée."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
      ),
    );
  }
}
