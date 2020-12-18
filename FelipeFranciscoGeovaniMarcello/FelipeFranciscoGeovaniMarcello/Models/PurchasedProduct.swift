//
//  PurchasedProduct.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import Foundation

struct PurchasedProduct {
	
	var productName: String
	var imageName: String
	var priceInDollars: Double
	
	init(productName: String,
		 imageName: String,
		 priceInDollars: Double) {
		self.productName = productName
		self.imageName = imageName
		self.priceInDollars = priceInDollars
	}
	
}
