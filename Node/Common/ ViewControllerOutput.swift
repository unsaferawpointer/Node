//
//  ViewControllerOutput.swift
//  Node
//
//  Created by Anton Cherkasov on 20.04.2023.
//

/// Basic interface of the view output
protocol ViewControllerOutput {

	/// ViewController did change state
	///
	/// - Parameters:
	///    - state: New state of the viewcontroller
	func viewControllerDidChangeState(_ state: ViewLifeCycle)
}

/// State of the viewcontroller
enum ViewLifeCycle {
	case didLoad
	case willAppear
	case didAppear
	case willDissappear
	case didDissappear
}
