import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/module_data.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/screens/module_graph/add_modules_screen.dart';
import 'package:helpus/utilities/constants.dart';
import 'package:helpus/widgets/app_drawer.dart';

// Module graph screen
class ModuleGraphScreen extends StatefulWidget {
  const ModuleGraphScreen({Key? key}) : super(key: key);
  @override
  ModuleGraphScreenState createState() => ModuleGraphScreenState();
}

class ModuleGraphScreenState extends State<ModuleGraphScreen> {
  Graph graph = Graph();
  final SugiyamaConfiguration _configuration = SugiyamaConfiguration();
  Profile profile = Profile.blankProfile();
  late Future<bool> future;

  @override
  void initState() {
    super.initState();
    future = setInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Graph'),
      ),
      drawer: AppDrawer.getDrawer(context, profile, 1),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: generateGraph(),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(20),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddModulesScreen(
                                profile: profile,
                              )),
                    ).then((value) {
                      setState(() {
                        future = setInitial();
                      });
                    });
                  },
                  backgroundColor: FirebaseColors.firebaseNavy,
                  tooltip: 'Add module',
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // Obtain profile information from firestore. Then, set the graph to the data
  // obtained.
  Future<bool> setInitial() async {
    await Profile.generate(FirebaseAuth.instance.currentUser!.uid, profile);

    _configuration.nodeSeparation = 10; // X Separation
    _configuration.levelSeparation = 20; // Y Separation

    Paint transparent = Paint()..color = Colors.transparent;
    Paint standard = Paint()..color = Colors.black;

    // Add all edges
    for (GraphEdge edge in profile.graphModel.edges) {
      graph.addEdge(
        Node.Id(edge.from),
        Node.Id(edge.to),
        paint: edge.to == -1 ? transparent : standard,
      );
    }

    return true;
  }

  // Generate graph that is displayed
  Widget generateGraph() {
    if (profile.graphModel.nodes.isNotEmpty &&
        profile.graphModel.edges.isNotEmpty) {
      return InteractiveViewer(
        constrained: false,
        minScale: 0.01,
        maxScale: 6,
        child: GraphView(
          graph: graph,
          algorithm: SugiyamaAlgorithm(_configuration),
          builder: builder,
        ),
      );
    } else {
      return const Center(
        child: Text('No graph detected'),
      );
    }
  }

  // Build the node
  Widget builder(Node node) {
    int id = node.key!.value;
    if (id == -1) {
      return masterNodeWidget();
    }
    List<GraphNode> nodes = profile.graphModel.nodes;
    String nodeValue =
        nodes.firstWhere((graphNode) => graphNode.id == id).label;
    return nodeWidget(nodeValue);
  }

  // Blank node widget
  Widget masterNodeWidget() {
    return const Text('');
  }

  // Standard node widget
  Widget nodeWidget(String value) {
    return ElevatedButton(
      onPressed: () {
        nodeOnPressed(value);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(value),
      ),
    );
  }

  // Dialog box to prompt user on whether they want to delete the module.
  void nodeOnPressed(String moduleCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to remove this module'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      removeModule(moduleCode);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Remove module from graph
  void removeModule(String moduleCode) async {
    int nodeId = profile.graphModel.getNodeId(moduleCode);
    profile.graphModel.removeMod(moduleCode);
    setState(() {
      graph.removeNode(Node.Id(nodeId));
      for (GraphEdge edge in profile.graphModel.edges) {
        if (edge.from == nodeId || edge.to == nodeId) {
          graph.removeEdge(Edge(
            Node.Id(edge.from),
            Node.Id(edge.to),
          ));
        }
      }
    });

    List<ModuleGrading> moduleGrading = profile.moduleGrading;
    moduleGrading.removeWhere((element) => element.moduleCode == moduleCode);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    debugPrint('1');
    debugPrint(profile.graphModel.toJson().toString());
    await documentReference.set(
      {
        'moduleGrading': moduleGrading
            .map(
              (e) => e.toJson(),
            )
            .toList(),
        'graphModel': profile.graphModel.toJson(),
      },
      SetOptions(merge: true),
    );
    debugPrint('2');
  }
}
