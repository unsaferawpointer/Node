//
//  TableSupportable.swift
//  Node
//
//  Created by Anton Cherkasov on 26.04.2023.
//

import Foundation

/// Interface of the outlineview
protocol TableSupportable: AnyObject {

	/// Returns current selected objects
	func getSelection() -> [Editor.NodeModel]

	/// Insert rows to specific destination
	///
	/// - Parameters:
	///    - indexes: Inserted indexes
	///    - destination: Destination of the insertion
	func insert(_ indexes: IndexSet, destination: Any?)

	/// Remove indexes in parent
	func remove(_ indexes: IndexSet, parent: Any?)

	/// Update object
	func update(_ object: Any?)

	/// Start batch updating
	func startUpdating()

	/// End batch updating
	func endUpdating()

	/// Expand row associated with specific object
	///
	/// - Parameters:
	///    - object: Expanded object
	///    - animate: Animation flag
	func expand(_ object: AnyObject?, withAnimation animate: Bool)

	/// Select rows  associated with specific objects
	///
	/// - Parameters:
	///    - objects: Selected objects
	func select(_ objects: [AnyObject])
}
