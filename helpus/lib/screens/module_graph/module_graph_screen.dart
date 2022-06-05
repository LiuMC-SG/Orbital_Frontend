import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:helpus/models/graph_model.dart';
import 'package:helpus/models/profile_data.dart';
import 'package:helpus/utilities/constants.dart';

class ModuleGraphScreen extends StatefulWidget {
  final Profile profile;
  const ModuleGraphScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);
  @override
  _ModuleGraphScreenState createState() => _ModuleGraphScreenState();
}

class _ModuleGraphScreenState extends State<ModuleGraphScreen> {
  final Graph _graph = Graph();
  final SugiyamaConfiguration _configuration = SugiyamaConfiguration();
  GraphModel? _graphModel;
  @override
  void initState() {
    super.initState();
    _configuration.nodeSeparation = 20; // X Separation
    _configuration.levelSeparation = 20; // Y Separation

    _graphModel = widget.profile.graphModel;

    Paint _transparent = Paint()..color = Colors.transparent;
    Paint _standard = Paint()..color = Colors.black;

    // Add all edges
    for (GraphEdge _edge in _graphModel!.edges) {
      _graph.addEdge(
        Node.Id(_edge.from),
        Node.Id(_edge.to),
        paint: _edge.to == -1 ? _transparent : _standard,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.pushNamed(
      //         context,
      //         RoutesText.addModules,
      //       );
      //     },
      //     backgroundColor: FirebaseColors.firebaseNavy,
      //     child: const Icon(
      //       Icons.add,
      //     ),
      //     tooltip: 'Add module',
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget generateGraph() {
    debugPrint(_graphModel.toString());
    if (_graphModel!.nodes.isNotEmpty && _graphModel!.edges.isNotEmpty) {
      return InteractiveViewer(
        constrained: false,
        minScale: 0.01,
        maxScale: 6,
        child: GraphView(
          graph: _graph,
          algorithm: SugiyamaAlgorithm(_configuration),
          builder: builder,
        ),
      );
    } else {
      return const Text('No graph detected');
    }
  }

  Widget builder(Node node) {
    int id = node.key!.value;
    if (id == -1) {
      return masterNodeWidget();
    }
    List<GraphNode> nodes = _graphModel!.nodes;
    String nodeValue =
        nodes.firstWhere((graphNode) => graphNode.id == id).label;
    return nodeWidget(nodeValue);
  }

  Widget masterNodeWidget() {
    return const Text('');
  }

  Widget nodeWidget(String value) {
    return ElevatedButton(
      onPressed: nodeOnPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(value),
      ),
    );
  }

  void nodeOnPressed() {}
}
