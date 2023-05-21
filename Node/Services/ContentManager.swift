//
//  ContentManager.swift
//  Node
//
//  Created by Anton Cherkasov on 20.05.2023.
//

import Foundation
import UniformTypeIdentifiers

/// Interface of the app content manager
protocol ContentManagerProtocol {
	/// Returns data for typeName
	func data(ofType typeName: String) throws -> Data
	/// Read data of the specific type
	func read(from data: Data, ofType typeName: String) throws
}

/// App content manager
final class ContentManager {

	private (set) var dataProvider: DataProviderProtocol

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - dataProvider: App data provider
	init(dataProvider: DataProviderProtocol = DataProvider()) {
		self.dataProvider = dataProvider
	}
}

// MARK: - ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {

	func data(ofType typeName: String) throws -> Data {
		guard let uti = UTType(typeName) else {
			throw ContentError.unknownFileFormat
		}

		let loader = try makeLoader(from: uti)
		return try loader.getData(from: dataProvider)
	}

	func read(from data: Data, ofType typeName: String) throws {

		guard let uti = UTType(typeName) else {
			throw ContentError.unknownFileFormat
		}

		let loader = try makeLoader(from: uti)
		self.dataProvider.clearStorage()
		try loader.load(data: data, to: dataProvider)
	}
}

// MARK: - Helpers
private extension ContentManager {

	func makeLoader(from uti: UTType) throws -> DataLoaderProtocol {
		switch uti {
			case .plainText: return TextLoader()
			default:
				throw ContentError.unsupportedUniformTypeIdentifier
		}
	}
}

// MARK: - Nested data structs
extension ContentManager {

	enum ContentError: Error {
		case unknownFileFormat
		case unsupportedUniformTypeIdentifier
	}
}
