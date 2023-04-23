//
//  Bindable.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

/// Bindable value
class Bindable<Value: Equatable> {

	typealias Listener = (Value) -> Bool

	private var listeners = [Listener]()

	private (set) var lastValue: Value?

	/// Basic initialization
	///
	/// - Parameters:
	///    - value: Initial value
	init(_ value: Value? = nil) {
		lastValue = value
	}
}

// MARK: - Public interface
extension Bindable {

	func update(with value: Value) {
		guard value != lastValue else {
			return
		}
		lastValue = value
		listeners = listeners.filter { $0(value) }
	}

	func bind<O: AnyObject, T>(
		_ sourceKeyPath: KeyPath<Value, T>,
		to object: O,
		_ objectKeyPath: ReferenceWritableKeyPath<O, T>
	) {
		addObservation(for: object) { object, observed in
			let value = observed[keyPath: sourceKeyPath]
			object[keyPath: objectKeyPath] = value
		}
	}
}

// MARK: - Helpers
private extension Bindable {

	func addObservation<O: AnyObject>(for object: O, handler: @escaping (O, Value) -> Void) {
		// If we already have a value available, we'll give the
		// handler access to it directly.
		lastValue.map { handler(object, $0) }

		// Each observation closure returns a Bool that indicates
		// whether the observation should still be kept alive,
		// based on whether the observing object is still retained.
		listeners.append { [weak object] value in
			guard let object = object else {
				return false
			}

			handler(object, value)
			return true
		}
	}

	func bind<O: AnyObject, T>(
		_ sourceKeyPath: KeyPath<Value, T>,
		to object: O,
		// This line is the only change compared to the previous
		// code sample, since the key path we're binding *to*
		// might contain an optional.
		_ objectKeyPath: ReferenceWritableKeyPath<O, T?>
	) {
		addObservation(for: object) { object, observed in
			let value = observed[keyPath: sourceKeyPath]
			object[keyPath: objectKeyPath] = value
		}
	}
}
