//
//  TotalViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class TotalViewController: UIViewController {

	@IBOutlet weak var totalAmountOfProductsInDollarLabel: UILabel!
	@IBOutlet weak var totalAmountOfTaxesInDollarLabel: UILabel!
	@IBOutlet weak var totalAmountInDollarLabel: UILabel!
	
	@IBOutlet weak var americanDollarExchangeRate: UILabel!
	@IBOutlet weak var totalAmountOfProductsWithTaxesInRealLabel: UILabel!
	@IBOutlet weak var totalAmountOfIofInRealLabel: UILabel!
	@IBOutlet weak var totalAmountInRealLabel: UILabel!
	
	let userDefaults = UserDefaults.standard
	lazy var exchangeRateDolarAndReal: Double = { userDefaults.double(forKey: "AmericanDollarExchangeRate") }()
	lazy var iofAsPercentage: Double          = { userDefaults.double(forKey: "IOF") }()
	
	var totalAmountOfProductsInDollar = 0.00
	var totalAmountOfTaxesInDollar = 0.00
	var totalAmountInDollar = 0.00
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		americanDollarExchangeRate.text = calculator.convertDoubleToCurrency(double: exchangeRateDolarAndReal,
																						  withLocale: .ptBR,
																						  returningStringWithCurrencySymbol: true)
		
		
	
	}

}
