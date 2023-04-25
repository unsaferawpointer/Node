//
//  NSScrollView.swift
//  JSON
//
//  Created by Anton Cherkasov on 12.04.2023.
//

import Cocoa

extension NSScrollView {

	static let `default`: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .noBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = true
		view.drawsBackground = false
		return view
	}()
}
