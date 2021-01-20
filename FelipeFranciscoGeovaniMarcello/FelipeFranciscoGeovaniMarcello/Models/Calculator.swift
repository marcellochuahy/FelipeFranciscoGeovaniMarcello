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
	
	private init() {
		numberFormatter.usesGroupingSeparator = true
	}
	
	var exchangeRateDolarAndReal: Double = 5.0
	var iofAsPercentage: Double = 0.00
	var stateTaxAsPercentage: Double = 0.0
	var priceInDolar: Double = 0.0
	
	var priceInReal: Double { priceInDolar * exchangeRateDolarAndReal }
	var productTaxInDolar: Double { priceInDolar * stateTaxAsPercentage / 100 }
	var productIofInDolar: Double { (priceInDolar + productTaxInDolar) *  iofAsPercentage / 100 }
	
	func convertStringToDouble(string: String) -> Double {
		numberFormatter.numberStyle = .none
		return numberFormatter.number(from: string)?.doubleValue ?? 0.00
	}
	
	func convertDoubleToString(double: Double) -> String {
		numberFormatter.locale = Locale(identifier: "pt_BR")
		numberFormatter.minimumFractionDigits = 2
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:double)) ?? "0,00"
	}
	
	func convertDoubleToCurrency(double: Double,
								 withLocale customLocale: CustomLocale,
								 returningStringWithCurrencySymbol: Bool) -> String {

		if returningStringWithCurrencySymbol {
			numberFormatter.currencySymbol = customLocale.currencySymbol
		} else {
			numberFormatter.currencySymbol = ""
		}

		numberFormatter.locale = customLocale.locale
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
