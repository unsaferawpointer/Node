//
//  Configurable.swift
//  Node
//
//  Created by Anton Cherkasov on 26.04.2023.
//

import Foundation

protocol Configurable: AnyObject { }

extension Configurable {
	func configure(_ block: (Self) -> Void) -> Self {
		block(self)
		return self
	}
}

extension NSObject: Configurable { }
