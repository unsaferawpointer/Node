//
//  DataLoaderProtocol.swift
//  Node
//
//  Created by Anton Cherkasov on 20.05.2023.
//

import Foundation

/// Interface of the app data loader
protocol DataLoaderProtocol {
	/// Read data and write it to data provider
	func load(data: Data, to dataProvider: DataProviderProtocol) throws
	/// Returns data for typeName
	func getData(from dataProvider: DataProviderProtocol) throws -> Data
}
