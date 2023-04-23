//
//  Checkbox.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

import Cocoa

final class Checkbox: NSView, ConfigurableField {

	typealias Configuration = CheckboxConfiguration

	private var configuration: Configuration {
		didSet {
			bind()
		}
	}

	private var isDone: Bool = false {
		didSet {
			button.state = isDone ? .on : .off
		}
	}

	// MARK: - UI-Properties

	lazy private var button: NSButton = {
		let view = NSButton(checkboxWithTitle: "",
							target: self,
							action: #selector(buttonDidChangeState(_:)))
		view.allowsMixedState = false
		return view
	}()

	lazy private var textfield: NSTextField = {
		let view = NSTextField(string: "")
		view.drawsBackground = false
		view.isBordered = false
		view.isBezeled = false
		view.bezelStyle = .roundedBezel
		view.lineBreakStrategy = .standard
		view.lineBreakMode = .byTruncatingTail
		view.maximumNumberOfLines = 1
		view.cell?.sendsActionOnEndEditing = true
		view.cell?.target = self
		view.cell?.action = #selector(controlTextDidChange)
		view.cell?.focusRingType = .default
		view.font = NSFont.preferredFont(forTextStyle: .headline)
		return view
	}()

	// MARK: - ConfigurableField

	init(_ configuration: Configuration) {
		self.configuration = configuration
		super.init(frame: .zero)
		bind()
		configureConstraints()
	}

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
	}

	@available(*, unavailable, message: "Use init(_:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - NSView life-cycle
extension Checkbox {

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: - Helpers
extension Checkbox {

	func bind() {
		configuration.value.bind(\Bool.self, to: self, \.isDone)
		configuration.title.bind(\String.self, to: textfield, \.stringValue)
	}

	func configureConstraints() {
		[button, textfield].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
				button.trailingAnchor.constraint(equalTo: textfield.leadingAnchor, constant: -8.0),
				button.centerYAnchor.constraint(equalTo: centerYAnchor),

				textfield.centerYAnchor.constraint(equalTo: centerYAnchor),
				textfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0)
			]
		)
	}
}

// MARK: - Actions
extension Checkbox {

	@objc
	func buttonDidChangeState(_ sender: NSButton) {
		let state = sender.state
		configuration.value.update(with: state == .on)
	}
}

// MARK: - NSTextFieldDelegate
extension Checkbox {

	@objc
	func controlTextDidChange() {
		configuration.title.update(with: textfield.stringValue)
	}
}
