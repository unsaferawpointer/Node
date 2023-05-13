//
//  ObjectMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import Hierarchy
@testable import Node

final class ObjectMock: ReferenceIdentifiable {

	var value: String

	init(value: String) {
		self.value = value
	}
}
