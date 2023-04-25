//
//  ObjectMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

@testable import Node

final class ObjectMock: ReferenceIdentifiable {

	var id: String

	init(id: String) {
		self.id = id
	}
}
