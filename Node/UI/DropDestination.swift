//
//  DropDestination.swift
//  Node
//
//  Created by Anton Cherkasov on 07.05.2023.
//

enum DropDestination {

	case onRoot

	case intoRoot(offset: Int)

	case onTarget(_ target: Any)

	case intoTarget(_ target: Any, offset: Int)
}
