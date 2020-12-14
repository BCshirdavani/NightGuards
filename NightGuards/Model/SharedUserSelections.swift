//
//  SharedUserSelections.swift
//  NightGuards
//
//  Created by shy macbook on 12/7/20.
//

import Foundation
import Combine

// singleton: https://medium.com/better-programming/the-best-way-to-use-environment-objects-in-swiftui-d9a88b1e253f
class SharedUserSelections: ObservableObject {

//	private init(){}
//
//	static let shared = SharedUserSelections()

	@Published var modelHasAnchor: Bool = false

	public func setHasAnchor(newStatus: Bool) {
		modelHasAnchor = newStatus
	}

	// TODO: load models in another view
	// TODO: save anchors in CoreData, not singleton
	// TODO: save world map in FileManager
	// other data persistence: https://www.iosapptemplates.com/blog/ios-development/data-persistence-ios-swift
}
