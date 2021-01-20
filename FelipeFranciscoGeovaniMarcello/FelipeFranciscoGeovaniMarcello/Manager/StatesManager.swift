//
//  StatesManager.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/01/21.
//  Copyright © 2021 Applause Codes. All rights reserved.
//

import CoreData

class StatesManager {
	
	static let shared = StatesManager()
	
	var states: [State] = []
	
	private init() { }
	
	func getStates(withContext context: NSManagedObjectContext) {
		
		let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "stateName", ascending: true)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		do {
			states = try context.fetch(fetchRequest)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func deleteState(at index: Int, context: NSManagedObjectContext) {
		
		let stateToBeDeleted = states[index]
		context.delete(stateToBeDeleted)
		
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
		
	}
	
}

