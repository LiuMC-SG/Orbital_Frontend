class GraphModel {
  final List<GraphNode> nodes = [];
  final List<GraphEdge> edges = [];
  static final GraphModel blankGraphModel = GraphModel({
    'nodes': [],
    'edges': [],
  });

  GraphModel(Map<String, dynamic> json) {
    var _nodes = json['nodes'];
    for (Map<String, dynamic> _node in _nodes) {
      GraphNode? generatedNode = GraphNode.generate(_node);
      if (generatedNode != null) {
        nodes.add(generatedNode);
      }
    }

    var _edges = json['edges'];
    for (Map<String, int> _edge in _edges) {
      GraphEdge? generatedEdge = GraphEdge.generate(_edge);
      if (generatedEdge != null) {
        edges.add(generatedEdge);
      }
    }
  }

  @override
  String toString() {
    return "{nodes: $nodes, edges: $edges}";
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((element) => element.toJson()),
      'edges': edges.map((element) => element.toJson()),
    };
  }
}

class GraphNode {
  final int id;
  final String label;
  GraphNode(this.id, this.label);

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
    return "{id: $id, label: $label}";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

class GraphEdge {
  final int from;
  final int to;
  GraphEdge(this.from, this.to);

  static GraphEdge? generate(Map<String, int> edge) {
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
    return "{from: $from, to: $to}";
  }

  Map<String, int> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}
