import "package:flutter/material.dart";
import "package:rubis/home.dart";
import "package:rubis/class/memberClass.dart";
import "package:rubis/new_member/newMember.dart";
import "package:rubis/userSecurStorage.dart";
import "package:rubis/utils/functions.dart" as functions;

class Connexion extends StatefulWidget {
  const Connexion({Key key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _textPseudo = TextEditingController();
  final _textPassword = TextEditingController();
  bool _validatePseudo = false;
  bool _validatePassword = false;

  @override
  void dispose() {
    _textPseudo.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final pseudo = await UserSecureStorage().getPseudo() ?? "";
    final password = await UserSecureStorage().getPassword() ?? "";

    setState(() {
      _textPseudo.text = pseudo;
      functions.memberConnexion.pseudo = pseudo;
      _textPassword.text = password;
      functions.memberConnexion.password = password;
    });
  }

  // page de connexion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            // container titre
            height: 400,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/big-light.png"))),
                  ),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/little-light.png"))),
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 40,
                  width: 80,
                  height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/controler.png"))),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: const Center(
                      child: Text(
                        "RUBIS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    // conneion login/mdp
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          controller: _textPseudo,
                          onChanged: (String newvalue) {
                            functions.memberConnexion.pseudo =
                                newvalue.toLowerCase();
                          },
                          decoration: InputDecoration(
                            errorText: _validatePseudo
                                ? "Veuillez compléter ce champ"
                                : null,
                            border: InputBorder.none,
                            hintText: "Pseudo",
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: _textPassword,
                          onChanged: (String newvalue) {
                            functions.memberConnexion.password = newvalue;
                          },
                          decoration: InputDecoration(
                            errorText: _validatePassword
                                ? "Veuillez compléter ce champ"
                                : null,
                            border: InputBorder.none,
                            hintText: "Mot de passe",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    setState(() {
                      _textPseudo.text.isEmpty
                          ? _validatePseudo = true
                          : _validatePseudo = false;
                      _textPassword.text.isEmpty
                          ? _validatePassword = true
                          : _validatePassword = false;
                    });
                    if (!_validatePseudo && !_validatePassword) {
                      String connexion = await functions.login();
                      if (connexion == "valide") {
                        if (functions.keepLoged) {
                          await UserSecureStorage()
                              .setPseudo(functions.memberConnexion.pseudo);
                          await UserSecureStorage()
                              .setPassword(functions.memberConnexion.password);
                        }
                        if (functions.memberConnexion.role == "nouveau") {
                          const snackBar = SnackBar(
                              content: Text(
                                  "Veuillez attendre la validation par un administrateur avant de vous connecter."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          _textPseudo.text = "";
                          _textPassword.text = "";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ));
                          setState(() {
                            // functions.pseudo = "";
                          });
                        }
                      } else {
                        if (connexion == "invalide") {
                          const snackBar = SnackBar(
                              content: Text("Identifiants invalides."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (connexion == "echec") {
                          const snackBar = SnackBar(
                              content:
                                  Text("echec de la connexion au serveur."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 88.0,
                        minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: functions.keepLoged,
                      onChanged: (bool value) {
                        setState(() {
                          functions.keepLoged = value;
                        });
                      },
                    ),
                    const Text("Enregistrer de nouveaux identifiants"),
                  ],
                ),
                TextButton(
                  // nouveau membre
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "ZenKurenaido"),
                  ),
                  onPressed: () {
                    functions.memberNew =
                        Member("", "", "", "", "", "", "", "", "", "");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewMember(),
                        ));
                    setState(() {});
                  },
                  child: const Text("Nouveau membre ?"),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
