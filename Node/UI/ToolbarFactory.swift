//
//  ToolbarFactory.swift
//  Node
//
//  Created by Anton Cherkasov on 28.04.2023.
//

import Cocoa

/// Toolbar factory interface
protocol ToolbarFactoryProtocol {
	var defaultItemIdentifiers: [NSToolbarItem.Identifier] { get }
	var allowedItemIdentifiers: [NSToolbarItem.Identifier] { get }
	func makeItem(_ itemIdentifier: NSToolbarItem.Identifier) -> NSToolbarItem?
}

/// Toolbar factory
final class ToolbarFactory { }

// MARK: - ToolbarFactoryProtocol
extension ToolbarFactory: ToolbarFactoryProtocol {

	var defaultItemIdentifiers: [NSToolbarItem.Identifier] {
		return [.newObject]
	}

	var allowedItemIdentifiers: [NSToolbarItem.Identifier] {
		return [.newObject]
	}

	func makeItem(_ itemIdentifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
		switch itemIdentifier {
			case .newObject:
				return NSToolbarItem(itemIdentifier: .newObject).configure {
					$0.isNavigational = false
					$0.label = "Add"
					$0.visibilityPriority = .high
					$0.view = NSButton().configure {
						$0.bezelStyle = .texturedRounded
						$0.image = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)
						$0.target = nil
						$0.action = #selector(CommonMenuSupportable.newObject(_:))
					}
				}
			default:
				return nil
		}
	}
}

private extension NSToolbarItem.Identifier {

	static let newObject = NSToolbarItem.Identifier("newObject")
}
