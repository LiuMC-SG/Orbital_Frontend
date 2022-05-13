class GraphModel {
  final List<GraphNode> nodes = [];
  final List<GraphEdge> edges = [];
  GraphModel(Map<String, dynamic> json) {
    List<Map<String, dynamic>> _nodes = json['nodes'];
    for (Map<String, dynamic> _node in _nodes) {
      GraphNode? generatedNode = GraphNode.generate(_node);
      if (generatedNode != null) {
        nodes.add(generatedNode);
      }
    }

    List<Map<String, int>> _edges = json['edges'];
    for (Map<String, int> _edge in _edges) {
      GraphEdge? generatedEdge = GraphEdge.generate(_edge);
      if (generatedEdge != null) {
        edges.add(generatedEdge);
      }
    }
  }
}

class GraphNode {
  final int id;
  final String label;
  GraphNode(this.id, this.label);

  static GraphNode? generate(Map<String, dynamic> node) {
    if (node['id'] != null && node['label'] != null) {
      return GraphNode(
        node['id'] ?? 0,
        node['label'] ?? 0,
      );
    }
    return null;
  }
}

class GraphEdge {
  final int from;
  final int to;
  GraphEdge(this.from, this.to);

  static GraphEdge? generate(Map<String, int> edge) {
    if (edge['from'] != null && edge['to'] != null) {
      return GraphEdge(
        edge['from'] ?? 0,
        edge['to'] ?? 0,
      );
    }
    return null;
  }
}
