//
//  FieldConfiguration.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Cocoa

protocol FieldConfiguration {

	associatedtype Field: ConfigurableField where Field.Configuration == Self

}

extension FieldConfiguration {

	/// Make field based on this configuration
	func makeField() -> NSView {
		return Field(self)
	}
}
