// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unrelated_type_equality_checks
import "package:flutter/material.dart";
import "package:rubis/sizeConfig.dart";
import "package:rubis/class/memberClass.dart";
import "package:rubis/utils/functions.dart" as functions;

class ManageMember extends StatefulWidget {
  const ManageMember({Key key}) : super(key: key);

  @override
  ManageMemberState createState() => ManageMemberState();
}

class ManageMemberState extends State<ManageMember> {
  List<List<Member>> allMembers;

  @override
  void initState() {
    allMembers = functions.allMembers;
    super.initState();
  }

  List<Color> colors = [Colors.white, Colors.white, Colors.white, Colors.white];

  @override
  Widget build(BuildContext context) {
    List<List<Member>> allMembers = functions.allMembers;
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
        title: const Text("Gérer les membres"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return list(context, index, allMembers, colors);
        },
      ),
    );
  }

  Widget list(BuildContext context, int index, List<List<Member>> allMembers,
      List<Color> colors) {
    var menuTitle = [
      "Nouveaux membres",
      "Membres inactifs",
      "Membres actifs",
      "Membres du bureau"
    ];
    var menuIcon = [
      Icons.access_time_filled_rounded,
      Icons.bedroom_parent_rounded,
      Icons.catching_pokemon_rounded,
      Icons.admin_panel_settings_outlined
    ];

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              colors[index] = Theme.of(context).colorScheme.onSecondary;
            } else {
              colors[index] = Colors.white;
            }
          });
        },
        trailing: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colors[index],
        ),
        leading: Icon(menuIcon[index], color: colors[index]),
        title: Text(menuTitle[index],
            style: TextStyle(
                color: colors[index],
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: allMembers[index].isNotEmpty
                ? SizeConfig.safeBlockVertical * 25
                : SizeConfig.safeBlockVertical * 15,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
                  allMembers[index].isNotEmpty ? allMembers[index].length : 1,
              itemBuilder: (BuildContext context, int jindex) =>
                  buildMember(context, index, jindex, allMembers[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMember(
      BuildContext context, int index, int jindex, List<Member> members) {
    var elseTitle = [
      "Pas de nouveaux membres",
      "Pas de membres inactifs",
      "Pas de membres actifs",
      "Pas de membres du bureau"
    ];

    if (members.isNotEmpty) {
      String title = functions.capitalize(members[jindex].pseudo);
      String sub = "\n" +
          functions.capitalize(members[jindex].firstname) +
          " " +
          functions.capitalize(members[jindex].lastname) +
          "\nDéplacer le membre vers ->";

      return SizedBox(
        width: SizeConfig.safeBlockHorizontal * 45,
        height: SizeConfig.safeBlockVertical * 25,
        child: Card(
          elevation: 4.0,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _showText(context, members[jindex]);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  title: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(sub),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (index != 1)
                      IconButton(
                        onPressed: () async {
                          await functions.changeMemberRole(
                              members[jindex].pseudo, 2);
                          await functions.getMembersList();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.bedroom_parent_rounded,
                          size: 35,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    if (index != 2)
                      IconButton(
                        onPressed: () async {
                          await functions.changeMemberRole(
                              members[jindex].pseudo, 3);
                          await functions.getMembersList();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.catching_pokemon_rounded,
                          size: 35,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    if (index != 3)
                      IconButton(
                        onPressed: () async {
                          await functions.changeMemberRole(
                              members[jindex].pseudo, 4);
                          await functions.getMembersList();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 35,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                  ]),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: SizeConfig.safeBlockHorizontal * 45,
        height: SizeConfig.safeBlockVertical * 15,
        child: Card(
          elevation: 4.0,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                title: Text(elseTitle[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showText(BuildContext context, Member member) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Pseudo: ${member.pseudo}\nPrénom: ${member.firstname}\nNom: ${member.lastname}\nEmail: ${member.email}\nTéléphone: ${member.phone}\nRole: ${member.role}"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}
