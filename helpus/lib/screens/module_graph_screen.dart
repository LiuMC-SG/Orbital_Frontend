import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:helpus/models/graph_model.dart';

class ModuleGraphScreen extends StatefulWidget {
  const ModuleGraphScreen({Key? key}) : super(key: key);
  @override
  _ModuleGraphScreenState createState() => _ModuleGraphScreenState();
}

class _ModuleGraphScreenState extends State<ModuleGraphScreen> {
  final Graph _graph = Graph();
  SugiyamaConfiguration _configuration = SugiyamaConfiguration();
  GraphModel? _graphModel;
  @override
  void initState() {
    _configuration.nodeSeparation = 20; // X Separation
    _configuration.levelSeparation = 20; // Y Separation

    // Add all edges
    if (_graphModel != null) {
      for (GraphEdge _edge in _graphModel!.edges) {
        _graph.addEdge(
          Node.Id(_edge.from),
          Node.Id(_edge.to),
        );
      }
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
    );
  }

  Widget generateGraph() {
    if (_graphModel != null) {
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
      return const Text("No graph detected");
    }
  }

  Widget builder(Node node) {
    int id = node.key!.value;

    List<GraphNode> nodes = _graphModel!.nodes;
    String nodeValue =
        nodes.firstWhere((graphNode) => graphNode.id == id).label;
    return nodeWidget(nodeValue);
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
