//
//  ConfigurableField.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Cocoa

/// Interface of the table field
protocol ConfigurableField: NSView {

	associatedtype Configuration

	/// Basic initialization
	///
	/// - Parameters:
	///    - configuration: Initial configuration
	init(_ configuration: Configuration)

	/// Update field
	///
	/// - Parameters:
	///    - configuration: New configuration
	func configure(_ configuration: Configuration)

}
