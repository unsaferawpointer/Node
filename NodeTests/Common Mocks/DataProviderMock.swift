//
//  DataProviderMock.swift
//  NodeTests
//
//  Created by Anton Cherkasov on 25.04.2023.
//

import Foundation
@testable import Node

final class DataProviderMock {

	var invocations: [Action] = []

	var numberOfChildrenOfModelStub: Int = 0
	var childStub: Model = .init(isDone: .random(), text: UUID().uuidString)

	var insertionStub: (IndexSet, Editor.NodeModel?)?
	var deletionStub: (IndexSet, Editor.NodeModel?)?

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

// MARK: - DataProviderOperation
extension DataProviderMock: DataProviderOperation {

	func remove(_ models: [Editor.NodeModel], handler: (IndexSet, Editor.NodeModel?) -> Void) {
		let action: Action = .remove(models)
		invocations.append(action)
		guard let deletionStub else {
			return
		}
		handler(deletionStub.0, deletionStub.1)
	}

	func insert(
		_ models: [Editor.NodeModel],
		to destination: Editor.NodeModel?,
		at index: Int?, handler: (IndexSet, Editor.NodeModel?) -> Void
	) {
		let action: Action = .insert(models, destination: destination, index: index)
		invocations.append(action)
		guard let insertionStub else {
			return
		}
		handler(insertionStub.0, insertionStub.1)
	}
}

extension DataProviderMock {

	enum Action {
		case insert(_ models: [Editor.NodeModel], destination: Editor.NodeModel?, index: Int?)
		case remove(_ models: [Editor.NodeModel])
	}
}
