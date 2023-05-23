//
//  Editor.Assembly.swift
//  Node
//
//  Created by Anton Cherkasov on 20.04.2023.
//

import Cocoa

extension Editor {

	/// Assemply for Editor module
	final class Assembly {

		/// Build Editor module
		///
		/// - Parameters:
		///    - dataProvider: DataProvider
		/// - Returns: ViewController of the module
		static func build(_ dataProvider: DataProviderProtocol) -> NSViewController {
			let interactor = Editor.Interactor(dataProvider: dataProvider)
			let presenter = Editor.Presenter(interactor: interactor)
			return Editor.ViewController { viewController in
				viewController.output = presenter
				presenter.view = viewController
			}
		}
	}
}
