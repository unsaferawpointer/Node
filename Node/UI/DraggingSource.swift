//
//  DraggingSource.swift
//  Node
//
//  Created by Anton Cherkasov on 22.05.2023.
//

enum DraggingSource {
	/// Destination view equals source view
	case local
	/// Destination app equals source app
	case `internal`
	/// Source is external application
	case external
}
