//
//  State+Extension.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 20/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import Foundation

extension State {
	
	var state: StateOfUSA {
		
		get {
			return StateOfUSA(rawValue: self.stateName!)!
		}

		set {
			self.stateName = newValue.rawValue
		}
		
	}
}
