//
//  TotalViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

	@IBOutlet weak var totalAmountOfProductsInDollarLabel: UILabel!
	@IBOutlet weak var totalAmountOfTaxesInDollarLabel: UILabel!
	@IBOutlet weak var totalAmountInDollarLabel: UILabel!
	
	@IBOutlet weak var americanDollarExchangeRate: UILabel!
	@IBOutlet weak var totalAmountOfProductsWithTaxesInRealLabel: UILabel!
	@IBOutlet weak var totalAmountOfIofInRealLabel: UILabel!
	@IBOutlet weak var totalAmountInRealLabel: UILabel!
	
	@IBOutlet weak var iofTitleLabel: UILabel!
	
	let userDefaults = UserDefaults.standard
	
	var products: [Product] = []

	lazy var exchangeRateDolarAndReal: Double = { userDefaults.double(forKey: "AmericanDollarExchangeRate") }()
	lazy var iofAsPercentage: Double          = { userDefaults.double(forKey: "IOF") }()
	
	var pricesInDollars: [Double] = []
	var taxesInDollars: [Double] = []
	var taxedProductInDollars: [Double] = []
	var iofsInDollars: [Double] = []
	
	var totalAmountOfProductsInDollarAsDouble = 0.00
	var totalAmountOfTaxesInDollarAsDouble = 0.00
	var totalAmountInDollarAsDouble = 0.00
	var totalAmountOfIofInDollarAsDouble = 0.00
	
	var totalAmountOfProductsWithTaxesInRealAsDouble = 0.00
	var totalAmountOfIofInRealAsDouble = 0.00
	var totalAmountInReal = 0.00
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		fetchProducts(withContext: context)
		mapProducts()
		setLabels()
	}

	func mapProducts() {
		
		_ = products.map {
			
			let priceInDollars = $0.priceInDollars
			let taxAsPercentage = $0.state?.tax ?? 0.00
			let paymentWithCreditCard = $0.paymentWithCreditCard // To calculate IOF
			
			let taxInDollars = priceInDollars * taxAsPercentage
			
			self.pricesInDollars.append(priceInDollars)
			self.taxesInDollars.append(taxInDollars)
			self.taxedProductInDollars.append(priceInDollars + taxInDollars)
			
			if paymentWithCreditCard {
				self.iofsInDollars.append((priceInDollars + taxInDollars) * (iofAsPercentage / 100))
			}
			
		}
		
		totalAmountInDollarAsDouble = taxedProductInDollars.reduce(0, +)
		totalAmountOfIofInDollarAsDouble = iofsInDollars.reduce(0, +)
		totalAmountOfIofInRealAsDouble = totalAmountOfIofInDollarAsDouble * exchangeRateDolarAndReal
		totalAmountOfProductsWithTaxesInRealAsDouble = totalAmountInDollarAsDouble * exchangeRateDolarAndReal
		totalAmountInReal = totalAmountOfProductsWithTaxesInRealAsDouble + totalAmountOfIofInRealAsDouble
		
	}
	
	func setLabels() {
		
		totalAmountOfProductsWithTaxesInRealAsDouble = totalAmountInDollarAsDouble * exchangeRateDolarAndReal
		
		
		
		totalAmountOfProductsInDollarLabel.text = calculator.convertDoubleToCurrency(double: pricesInDollars.reduce(0, +),
																					 withLocale: .enUS,
																					 returningStringWithCurrencySymbol: true)
		
		totalAmountOfTaxesInDollarLabel.text = calculator.convertDoubleToCurrency(double: taxesInDollars.reduce(0, +),
																				  withLocale: .enUS,
																				  returningStringWithCurrencySymbol: true)
		
		totalAmountInDollarLabel.text = calculator.convertDoubleToCurrency(double: totalAmountInDollarAsDouble,
																		   withLocale: .enUS,
																		   returningStringWithCurrencySymbol: true)
		
		americanDollarExchangeRate.text = calculator.convertDoubleToCurrency(double: exchangeRateDolarAndReal,
																			 withLocale: .ptBR,
																			 returningStringWithCurrencySymbol: true)
		
		totalAmountOfProductsWithTaxesInRealLabel.text = calculator.convertDoubleToCurrency(double: totalAmountOfProductsWithTaxesInRealAsDouble,
																							withLocale: .ptBR,
																							returningStringWithCurrencySymbol: true)
		
		totalAmountOfIofInRealLabel.text = calculator.convertDoubleToCurrency(double: totalAmountOfIofInRealAsDouble,
																			  withLocale: .ptBR,
																			  returningStringWithCurrencySymbol: true)
		
		totalAmountInRealLabel.text = calculator.convertDoubleToCurrency(double: totalAmountInReal,
																		 withLocale: .ptBR,
																		 returningStringWithCurrencySymbol: true)
		
		iofTitleLabel.text = "IOF (\(iofAsPercentage)% para cartão)"
		
	}

}

extension TotalViewController {
	
	func fetchProducts(withContext context: NSManagedObjectContext) {
		let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
		do {
			products = try context.fetch(fetchRequest)
		} catch {
			print(error.localizedDescription)
		}
	}
	
}



