//
//  UIViewController+Calculator.swift.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/01/21.
//  Copyright © 2021 Applause Codes. All rights reserved.
//

import UIKit

extension UIViewController {
	
	var calculator: Calculator {
		return Calculator.shared
	}
	
}

extension UITableViewCell {
	
	var calculator: Calculator {
		return Calculator.shared
	}
	
}
