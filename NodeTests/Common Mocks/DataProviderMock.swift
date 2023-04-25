//
//  DataProviderMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import Foundation
@testable import Node

final class DataProviderMock {

	var numberOfChildrenOfModelStub: Int = 0
	var childStub: Model = .init(isDone: .random(), text: UUID().uuidString)

}

// MARK: - DataProviderProtocol
extension DataProviderMock: DataProviderProtocol {

	func numberOfChildrenOfModel(model: Model?) -> Int {
		numberOfChildrenOfModelStub
	}

	func child(index: Int, ofModel model: Model?) -> Any {
		childStub
	}
}
