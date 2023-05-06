//
//  Sequance + Extension.swift
//  Node
//
//  Created by Anton Cherkasov on 02.05.2023.
//

import Foundation

extension Collection {

	/// Returns first index where value is equal to the passed value
	///
	/// - Parameters:
	///    - keyPath: KeyPath of the value
	///    - value: Desired value
	/// - Returns: First index
	func firstIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equalsTo value: T) -> Index? {
		return firstIndex { $0[keyPath: keyPath] == value }
	}
}
