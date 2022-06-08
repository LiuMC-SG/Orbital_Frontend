import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Graph model that contains all graph nodes and edges
class GraphModel {
  final List<GraphNode> nodes = [];
  final List<GraphEdge> edges = [];
  static final GraphModel blankGraphModel = GraphModel({
    'nodes': [
      {
        'id': -1,
        'label': 'master',
      },
    ],
    'edges': [],
  });

  // Generate graph model from json data
  GraphModel(Map<String, dynamic> json) {
    var _nodes = json['nodes'];
    for (var _node in _nodes) {
      GraphNode? generatedNode = GraphNode.generate(_node);
      if (generatedNode != null) {
        nodes.add(generatedNode);
      }
    }

    var _edges = json['edges'];
    for (var _edge in _edges) {
      GraphEdge? generatedEdge = GraphEdge.generate(_edge);
      if (generatedEdge != null) {
        edges.add(generatedEdge);
      }
    }
  }

  @override
  String toString() {
    return '{nodes: $nodes, edges: $edges}';
  }

  // Output all nodes and edges to json
  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((element) => element.toJson()),
      'edges': edges.map((element) => element.toJson()),
    };
  }

  // Add node to graph if it doesn't already exist
  void addNode(GraphNode graphNode) {
    if (getNodeId(graphNode.label) == -1) {
      nodes.add(graphNode);
      edges.add(GraphEdge(graphNode.id, -1));
    }
  }

  // Add edge to graph if it doesn't already exist
  void addEdge(GraphEdge graphEdge) {
    if (getEdgeId(graphEdge.from, graphEdge.to) == -1) {
      edges.add(graphEdge);
    }
  }

  // Obtain node id from moduleCode. Returns -1 if node doesn't exist.
  int getNodeId(String moduleCode) {
    for (var node in nodes) {
      if (node.label == moduleCode) {
        return node.id;
      }
    }
    return -1;
  }

  // Check if edge exists between two nodes. Returns -1 if edge doesn't exist.
  int getEdgeId(int from, int to) {
    for (var edge in edges) {
      if (edge.from == from && edge.to == to) {
        return 1;
      }
    }
    return -1;
  }

  // Remove module from graph with moduleCode. Remove node with the moduleCode.
  // Remove all edges associated with the moduleCode as well.
  void removeMod(String moduleCode) {
    int id = getNodeId(moduleCode);
    if (id != -1) {
      nodes.removeWhere((element) => element.id == id);
      edges.removeWhere((element) => element.from == id || element.to == id);

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      documentReference.set(
        {'graphModel': toJson()},
        SetOptions(merge: true),
      );
    }
  }

  // Obtain the maximum node id
  int maxId() {
    return nodes.fold(
        -1, (previousValue, element) => max(previousValue, element.id));
  }
}

// Graph node class
class GraphNode {
  final int id;
  final String label;
  GraphNode(this.id, this.label);

  // Generate graph node from json data
  static GraphNode? generate(Map<String, dynamic> node) {
    if (!node.containsKey('id') || !node.containsKey('label')) {
      return null;
    }
    if (node['id'] != null && node['label'] != null) {
      return GraphNode(
        node['id'] ?? 0,
        node['label'] ?? 0,
      );
    }
    return null;
  }

  @override
  String toString() {
    return '{id: $id, label: $label}';
  }

  // Output node to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

// Graph edge class
class GraphEdge {
  final int from;
  final int to;
  GraphEdge(this.from, this.to);

  // Generate graph edge from json data
  static GraphEdge? generate(Map<String, dynamic> edge) {
    if (!edge.containsKey('from') || !edge.containsKey('to')) {
      return null;
    }
    if (edge['from'] != null && edge['to'] != null) {
      return GraphEdge(
        edge['from'] ?? 0,
        edge['to'] ?? 0,
      );
    }
    return null;
  }

  @override
  String toString() {
    return '{from: $from, to: $to}';
  }

  // Output edge to json
  Map<String, int> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}
