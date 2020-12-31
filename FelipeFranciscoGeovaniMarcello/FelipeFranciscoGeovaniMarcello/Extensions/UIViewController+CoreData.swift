//
//  UIViewController+CoreData.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 18/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
	
	var context: NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		return context
	}
	
}
