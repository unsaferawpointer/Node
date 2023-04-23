//
//  TreeDelegate.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Foundation

/// Delegate of the tree data structure. Helps to update the NSOutlineView
protocol TreeDelegate: AnyObject {
	func treeInsertedNewObjects(to indexSet: IndexSet, in parent: AnyObject?)
}
