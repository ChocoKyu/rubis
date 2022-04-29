// ignore_for_file: file_names

import "package:flutter/material.dart";
// import "package:rubis/sizeConfig.dart";
import "package:rubis/utils/functions.dart" as functions;

class NewMember extends StatefulWidget {
  const NewMember({Key key}) : super(key: key);

  @override
  State<NewMember> createState() => _NewMemberState();
}

class _NewMemberState extends State<NewMember> {
  final _textLastname = TextEditingController();
  final _textFirstname = TextEditingController();
  final _textPseudo = TextEditingController();
  final _textEmail = TextEditingController();
  final _textEmailCheck = TextEditingController();
  final _textPhone = TextEditingController();
  final _textPassword = TextEditingController();
  final _textPasswordCheck = TextEditingController();

  bool _validateLastname = false;
  bool _validateFirstname = false;
  bool _validatePseudo = false;
  bool _validateEmail = false;
  bool _validateEmailCheck = false;
  bool _validatePhone = false;
  bool _validatePassword = false;
  bool _validatePasswordCheck = false;
  bool _validateSameEmail = false;
  bool _validateSamePassword = false;

  @override
  void dispose() {
    _textLastname.dispose();
    _textFirstname.dispose();
    _textPseudo.dispose();
    _textEmail.dispose();
    _textEmailCheck.dispose();
    _textPhone.dispose();
    _textPassword.dispose();
    _textPasswordCheck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouveau membre")),
      body: Center(
        child: ListView(children: [
          //Intervenant
          ListTile(
            leading: const Icon(Icons.design_services, size: 40.0),
            title: const Text(
              "Nom",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textLastname,
              onChanged: (String newvalue) {
                functions.memberNew.lastname = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validateLastname ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.design_services),
            title: const Text(
              "Prénom",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textFirstname,
              onChanged: (String newvalue) {
                functions.memberNew.firstname = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validateFirstname ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text(
              "Pseudo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textPseudo,
              onChanged: (String newvalue) {
                functions.memberNew.pseudo = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validatePseudo ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text(
              "E-mail",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textEmail,
              onChanged: (String newvalue) {
                functions.memberNew.email = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validateEmail ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text(
              "Répétez l'E-mail",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textEmailCheck,
              onChanged: (String newvalue) {
                functions.memberNew.emailCheck = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validateEmailCheck ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_phone),
            title: const Text(
              "Téléphone",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              controller: _textPhone,
              onChanged: (String newvalue) {
                functions.memberNew.phone = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validatePhone ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              "Mot de passe",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              obscureText: true,
              controller: _textPassword,
              onChanged: (String newvalue) {
                functions.memberNew.password = newvalue;
              },
              decoration: InputDecoration(
                errorText:
                    _validatePassword ? "Veuillez compléter ce champ" : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              "Répétez votre mot de passe",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextField(
              obscureText: true,
              controller: _textPasswordCheck,
              onChanged: (String newvalue) {
                functions.memberNew.passwordCheck = newvalue;
              },
              decoration: InputDecoration(
                errorText: _validatePasswordCheck
                    ? "Veuillez compléter ce champ"
                    : null,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _textFirstname.text.isEmpty
                          ? _validateFirstname = true
                          : _validateFirstname = false;
                      _textLastname.text.isEmpty
                          ? _validateLastname = true
                          : _validateLastname = false;
                      _textPseudo.text.isEmpty
                          ? _validatePseudo = true
                          : _validatePseudo = false;
                      _textEmail.text.isEmpty
                          ? _validateEmail = true
                          : _validateEmail = false;
                      _textEmailCheck.text.isEmpty
                          ? _validateEmailCheck = true
                          : _validateEmailCheck = false;
                      _textPhone.text.isEmpty
                          ? _validatePhone = true
                          : _validatePhone = false;
                      _textPassword.text.isEmpty
                          ? _validatePassword = true
                          : _validatePassword = false;
                      _textPasswordCheck.text.isEmpty
                          ? _validatePasswordCheck = true
                          : _validatePasswordCheck = false;
                    });

                    if (!_validateFirstname &&
                        !_validateLastname &&
                        !_validatePseudo &&
                        !_validateEmail &&
                        !_validateEmailCheck &&
                        !_validatePhone &&
                        !_validatePassword &&
                        !_validatePasswordCheck) {
                      if (functions.memberNew.email ==
                          functions.memberNew.emailCheck) {
                        _validateSameEmail = true;
                      } else {
                        const snackBar = SnackBar(
                            content:
                                Text("Erreur de saisie, email incorrect."));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (functions.memberNew.password ==
                          functions.memberNew.passwordCheck) {
                        _validateSamePassword = true;
                      } else {
                        const snackBar = SnackBar(
                            content: Text(
                                "Erreur de saisie, mot de passe incorrect incorrect."));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (_validateSamePassword == true &&
                          _validateSameEmail == true) {
                        functions.addUser();
                        const snackBar = SnackBar(
                            content: Text(
                                "Utilisateur ajouté, en attente de validation par un administrateur."));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    "Créer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
