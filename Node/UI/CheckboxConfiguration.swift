//
//  CheckboxConfiguration.swift
//  Node
//
//  Created by Anton Cherkasov on 23.04.2023.
//

/// Configuration of the checkbox
struct CheckboxConfiguration: FieldConfiguration {

	typealias Field = Checkbox

	/// State of the checkbox
	var value: Bindable<Bool>

	/// Title of the checkbox
	var title: Bindable<String>
}
