//
//  Editor.ViewController.swift
//  Node
//
//  Created by Anton Cherkasov on 15.04.2023.
//

import Cocoa

/// Interface of the editor view
protocol EditorView: AnyObject, TableSupportable {
	/// Reload all data
	func reloadData()
}

extension Editor {

	/// ViewController of the Editor module
	final class ViewController: NSViewController {

		// MARK: - DI

		var output: (EditorTableAdapter & ViewControllerOutput & Presenter)!

		// MARK: - UI-Properties

		lazy var scrollview: NSScrollView	 = NSScrollView.makeDefault()

		lazy var table: NSOutlineView		 = NSOutlineView.makeDefault()

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - configure: Configuration closure. Setup module here.
		init(_ configure: (Editor.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureUserInterface()
			configureConstraints()
		}

		@available(*, unavailable, message: "Use init()")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

	}
}

// MARK: - NSViewController life-cycle
extension Editor.ViewController {

	override func loadView() {
		view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		output?.viewControllerDidChangeState(.didLoad)
	}
}

// MARK: - EditorView
extension Editor.ViewController: EditorView {

	func reloadData() {
		table.reloadData()
	}
}

// MARK: - TableSupportable
extension Editor.ViewController: TableSupportable {

	func getSelection() -> [Any] {
		return table.effectiveSelection.compactMap {
			table.item(atRow: $0)
		}
	}

	func insert(_ indexes: IndexSet, destination: Any?) {
		table.insertItems(at: indexes, inParent: destination, withAnimation: [.effectFade, .slideRight])
	}

	func remove(_ indexes: IndexSet, parent: Any?) {
		table.removeItems(at: indexes, inParent: parent, withAnimation: [.effectFade, .slideLeft])
	}

	func update(_ object: Any?) {
		table.reloadItem(object)
	}

	func startUpdating() {
		table.beginUpdates()
	}

	func endUpdating() {
		table.endUpdates()
	}

	func expand(_ object: AnyObject?, withAnimation animate: Bool) {
		if animate {
			table.animator().expandItem(object, expandChildren: false)
		} else {
			table.expandItem(object, expandChildren: false)
		}
	}

	func select(_ objects: [AnyObject]) {
		let indexes = objects.map { table.row(forItem: $0) }
		table.selectRowIndexes(IndexSet(indexes), byExtendingSelection: false)
	}
}

// MARK: - Helpers
private extension Editor.ViewController {

	func configureUserInterface() {
		let column = NSTableColumn(identifier: .mainColumn)
		column.resizingMask = [.autoresizingMask, .userResizingMask]
		table.addTableColumn(column)

		table.delegate = self
		table.dataSource = self

		table.setDraggingSourceOperationMask([.copy, .delete], forLocal: false)
		table.registerForDraggedTypes([.rows])

		table.menu = Editor.ContextMenuFactory.build()
	}

	func configureConstraints() {
		scrollview.documentView = table

		view.addSubview(scrollview)
		scrollview.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		)
	}
}

// MARK: - NSMenuItemValidation
extension Editor.ViewController: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let action = menuItem.action else {
			return false
		}
		return output?.validateMenuItem(selector: action) ?? false
	}
}

// MARK: - CommonMenuSupportable
extension Editor.ViewController: CommonMenuSupportable {

	func newObject(_ sender: Any?) {
		output?.userClickedAddMenuItem()
	}

	func deleteObjects(_ sender: Any?) {
		output?.userClickedDeleteMenuItem()
	}
}

private extension NSUserInterfaceItemIdentifier {
	static let mainColumn = NSUserInterfaceItemIdentifier(rawValue: "main")
}
