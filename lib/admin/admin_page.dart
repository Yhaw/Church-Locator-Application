import 'package:church_finder/admin/details.dart';
import 'package:church_finder/admin/pending.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class datta {
  final String name1;
  final String lon;
  final String lat;

  const datta(this.name1, this.lon, this.lat);
}

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        leading: Icon(
          Icons.admin_panel_settings_outlined,
          size: 50,
        ),
        toolbarHeight: 90,
        title: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: Text("ADMIN PORTAL",
                  style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 45,
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Church Here'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 66, 99, 245),
        elevation: 2,
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 76, 121, 245),
        child: StreamBuilder<QuerySnapshot>(
          stream: (name != "" && name != null)
              ? FirebaseFirestore.instance
                  .collection('Churches')
                  .where("searchkeywords", arrayContains: name)
                  .snapshots(includeMetadataChanges: true)
              : FirebaseFirestore.instance
                  .collection("Churches")
                  .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 255, 255),
                semanticsValue: "Loading ...",
              ));
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        data['imageUrl'],
                      ),
                      title: Text(data['Name']),
                      subtitle: Text(data['state'].toString()),
                      trailing: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Churches')
                                .doc(data["Name"])
                                .delete();
                          },
                          icon: Icon(Icons.delete)),
                      onTap: () async {
                        final dattta = datta(
                          data['Name'].toString(),
                          data['longitude'].toString(),
                          data['latitude'].toString(),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => details(dattta: dattta)),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => pendHome()));
        },
        backgroundColor: Color.fromARGB(255, 76, 86, 175),
        child: const Icon(Icons.pending_actions_outlined),
      ),
    );
  }
}
