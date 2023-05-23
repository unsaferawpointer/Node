//
//  Destination.swift
//  Node
//
//  Created by Anton Cherkasov on 07.05.2023.
//

import Hierarchy

enum Destination<Object> {

	case onRoot

	case intoRoot(offset: Int)

	case onTarget(_ target: Object)

	case intoTarget(_ target: Object, offset: Int)
}

// MARK: - Equatable
extension Destination: Equatable where Object: ReferenceIdentifiable {

	static func == (lhs: Destination<Object>, rhs: Destination<Object>) -> Bool {
		switch (lhs, rhs) {
			case (.onRoot, .onRoot):
				return true
			case (.intoRoot(let lhsIndex), .intoRoot(let rhsIndex)):
				return lhsIndex == rhsIndex
			case (.onTarget(let lhsObject), .onTarget(let rhsObject)):
				return lhsObject.id == rhsObject.id
			case (.intoTarget(let lhsObject, let lhsIndex), .intoTarget(let rhsObject, let rhsIndex)):
				return lhsObject.id == rhsObject.id && lhsIndex == rhsIndex
			default:
				return false
		}
	}
}

extension Destination {

	func map<T>(_ block: (Object) -> T?) -> Destination<T>? {
		switch self {
			case .onRoot: 					return .onRoot
			case .intoRoot(let offset):		return .intoRoot(offset: offset)
			case .onTarget(let object):
				guard let converted = block(object) else {
					return nil
				}
				return .onTarget(converted)
			case .intoTarget(let object, let offset):
				guard let converted = block(object) else {
					return nil
				}
				return .intoTarget(converted, offset: offset)
		}
	}

	func optionalCast<T>(to type: T.Type) -> Destination<T>? {
		switch self {
			case .onRoot: 					return .onRoot
			case .intoRoot(let offset):		return .intoRoot(offset: offset)
			case .onTarget(let object):
				guard let converted = object as? T else {
					return nil
				}
				return .onTarget(converted)
			case .intoTarget(let object, let offset):
				guard let converted = object as? T else {
					return nil
				}
				return .intoTarget(converted, offset: offset)
		}
	}
}
