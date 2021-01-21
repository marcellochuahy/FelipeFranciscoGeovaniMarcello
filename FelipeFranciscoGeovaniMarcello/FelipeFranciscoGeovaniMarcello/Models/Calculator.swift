//
//  Calculator.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/01/21.
//  Copyright © 2021 Applause Codes. All rights reserved.
//

import Foundation

enum CustomLocale: String {
	
	case enUS
	case ptBR
	
	var locale: Locale {
		switch self {
			case .enUS: return Locale(identifier: "en_US")
			case .ptBR: return Locale(identifier: "pt_BR")
		}
	}
	
	var currencySymbol: String {
		switch self {
			case .enUS: return "US$"
			case .ptBR: return "R$"
		}
	}
	
}

class Calculator {
	
	static let shared = Calculator()
	
	let numberFormatter = NumberFormatter()
	
	let userDefaults = UserDefaults.standard
	
	private init() {
		numberFormatter.usesGroupingSeparator = true
	}

	lazy var exchangeRateDolarAndReal: Double = { userDefaults.double(forKey: "AmericanDollarExchangeRate") }()
	lazy var iofAsPercentage: Double          = { userDefaults.double(forKey: "IOF") }()
	
	var stateTaxAsPercentage: Double = 0.0
	var priceInDolar: Double = 0.0
	
	var priceInReal: Double { priceInDolar * exchangeRateDolarAndReal }
	var productTaxInDolar: Double { priceInDolar * stateTaxAsPercentage / 100 }
	var productIofInDolar: Double { (priceInDolar + productTaxInDolar) *  iofAsPercentage / 100 }
	
	func convertStringToDouble(numberAsString: String) -> Double {
		let numberAsStringWithCommaDecimalSeparator = String(format:"%.2f", numberAsString.doubleValue)
		return Double(numberAsStringWithCommaDecimalSeparator) ?? 0.00
	}
	
	func convertDoubleToString(double: Double, withLocale customLocale: CustomLocale?) -> String {
		numberFormatter.locale = customLocale?.locale
		numberFormatter.minimumFractionDigits = 2
		numberFormatter.maximumFractionDigits = 2
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:double)) ?? "0,00"
	}
	
	func convertDoubleToCurrency(double: Double,
								 withLocale customLocale: CustomLocale?,
								 returningStringWithCurrencySymbol: Bool) -> String {

		if returningStringWithCurrencySymbol {
			numberFormatter.currencySymbol = customLocale?.currencySymbol ?? ""
		} else {
			numberFormatter.currencySymbol = ""
		}

		numberFormatter.locale = customLocale?.locale
		numberFormatter.numberStyle = .currency
		numberFormatter.alwaysShowsDecimalSeparator = true
		
		return numberFormatter.string(for: double) ?? "ERROR"
	}
	
	func calculateTotal(isPaymentMethodCreditCard: Bool) -> Double {
		var total = priceInDolar + productTaxInDolar
		if isPaymentMethodCreditCard {
			total += productIofInDolar
		}
		return total
	}
	
}
