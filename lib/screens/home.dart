import 'package:church_finder/gps.dart';
import 'package:church_finder/screens/add_church.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

class datta {
  final String name1;
  final String lon;
  final String lat;
  final String h_lon;
  final String h_lat;

  const datta(this.name1, this.lon, this.lat, this.h_lat, this.h_lon);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  // final Stream<QuerySnapshot> _DataStream = FirebaseFirestore.instance
  //     .collection('Churches')
  //     .where("searchKeywords", arrayContains: name)
  //      .snapshots(includeMetadataChanges: true);

  final loc.Location location = loc.Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        leading: Icon(
          Icons.church_rounded,
          size: 50,
        ),
        toolbarHeight: 90,
        title: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: Text("MY CHURCH FINDER",
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
        backgroundColor: Color.fromARGB(255, 238, 90, 231),
        elevation: 2,
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 31, 255),
        child: StreamBuilder<QuerySnapshot>(
          stream: (name != "" && name != null)
              ? FirebaseFirestore.instance
                  .collection('Churches')
                  .where("searchkeywords", arrayContains: name)
                  .where("state", isEqualTo: true)
                  .snapshots(includeMetadataChanges: true)
              : FirebaseFirestore.instance
                  .collection("Churches")
                  .where("state", isEqualTo: true)
                  .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
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
                      subtitle: Text(data['place']),
                      trailing: Icon(Icons.more_vert),
                      onTap: () async {
                        final loc.LocationData _locationResult =
                            await location.getLocation();
                        final dattta = datta(
                          data['Name'].toString(),
                          data['longitude'].toString(),
                          data['latitude'].toString(),
                          _locationResult.latitude.toString(),
                          _locationResult.longitude.toString(),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => gpsHome(dattta: dattta)),
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
              context, MaterialPageRoute(builder: (context) => addChurch()));
        },
        backgroundColor: Color.fromARGB(255, 76, 86, 175),
        child: const Icon(Icons.church_outlined),
      ),
    );
  }
}
