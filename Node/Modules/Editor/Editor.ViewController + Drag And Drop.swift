//
//  Editor.ViewController + DragAndDrop.swift
//  Node
//
//  Created by Anton Cherkasov on 07.05.2023.
//

import Cocoa
import UniformTypeIdentifiers

// MARK: - Drag & Drop support
extension Editor.ViewController {

	func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
		let row = table.row(forItem: item)
		guard row != -1 else {
			return nil
		}
		let pasterboardItem = NSPasteboardItem()
		writeData(of: row, to: pasterboardItem)
		return pasterboardItem
	}

	public func outlineView(
		_ outlineView: NSOutlineView,
		validateDrop info: NSDraggingInfo,
		proposedItem item: Any?,
		proposedChildIndex index: Int
	) -> NSDragOperation {

		let source = draggingSource(draggingInfo: info)

		// Supports only local reorder
		if source == .local {
			let canMove = output.canMove(objects(from: info), to: item)
			return canMove ? .move : []
		}

		return []
	}

	public func outlineView(
		_ outlineView: NSOutlineView,
		acceptDrop info: NSDraggingInfo,
		item: Any?,
		childIndex index: Int
	) -> Bool {

		let objects = objects(from: info)
		let destination = dropDestination(target: item, index: index)

		output?.moveItems(objects, to: destination)
		return true
	}
}

// MARK: - Helpers
extension Editor.ViewController {

	func writeData(of row: Int, to pasterboardItem: NSPasteboardItem) {
		guard let indexData = try? NSKeyedArchiver.archivedData(withRootObject: row, requiringSecureCoding: true) else {
			fatalError("Cant archived data of the row = \(row)")
		}
		pasterboardItem.setData(indexData, forType: .rows)
	}

	func dropDestination(target: Any?, index: Int) -> Destination<Any> {
		switch target {
			case .some(let target):
				return index == -1 ? .onTarget(target) : .intoTarget(target, offset: index)
			case .none:
				return index == -1 ? .onRoot : .intoRoot(offset: index)

		}
	}

	func draggingSource(draggingInfo info: NSDraggingInfo) -> DraggingSource {
		if let source = info.draggingSource as? NSOutlineView, source === table {
			return .local
		} else if info.draggingSource != nil {
			return .internal
		}
		return .external
	}

	func objects(from draggingInfo: NSDraggingInfo) -> [AnyObject] {
		guard let pasteboardItems = draggingInfo.draggingPasteboard.pasteboardItems else {
			return []
		}
		var rows: [Int] = []
		for item in pasteboardItems {
			guard
				let data = item.data(forType: .rows),
				let row = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: data)?.intValue
			else {
				continue
			}
			rows.append(row)
		}
		return rows.compactMap { table.item(atRow: $0) } as? [AnyObject] ?? []
	}

}

extension NSPasteboard.PasteboardType {
	static var rows = NSPasteboard.PasteboardType("private.table.indexes")
}
