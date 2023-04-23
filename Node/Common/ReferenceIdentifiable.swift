//
//  ReferenceIdentifiable.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

/// Uniquely defines an instance of a reference type/
protocol ReferenceIdentifiable: AnyObject { }

extension ReferenceIdentifiable {

	/// Uniquely defines an instance of a reference type
	var refId: ObjectIdentifier {
		return ObjectIdentifier(self)
	}
}
