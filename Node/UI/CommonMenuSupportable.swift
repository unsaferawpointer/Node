//
//  CommonMenuSupportable.swift
//  Node
//
//  Created by Anton Cherkasov on 26.04.2023.
//

import Foundation

@objc
protocol CommonMenuSupportable {

	/// Create new object
	///
	/// - Parameters:
	///    - sender: Sender of the action
	func newObject(_ sender: Any?)

	/// Delete objects
	///
	/// - Parameters:
	///    - sender: Sender of the action
	func deleteObjects(_ sender: Any?)
}
