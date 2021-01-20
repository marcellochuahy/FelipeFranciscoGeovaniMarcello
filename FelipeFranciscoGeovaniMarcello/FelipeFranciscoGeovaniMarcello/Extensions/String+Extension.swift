//
//  String+Extension.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 20/01/21.
//  Copyright © 2021 Applause Codes. All rights reserved.
//

import Foundation

extension String {
	
	static let numberFormatter = NumberFormatter()
	
	var doubleValue: Double {
		
		String.numberFormatter.decimalSeparator = "."
		
		if let result =  String.numberFormatter.number(from: self) {
			return result.doubleValue
		} else {
			String.numberFormatter.decimalSeparator = ","
			if let result = String.numberFormatter.number(from: self) {
				return result.doubleValue
			}
		}
		
		return 0
		
	}
	
}
