//
//  ProductTableViewCell.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 19/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
	
	let userDefaults = UserDefaults.standard

	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var priceInDollars: UILabel!
	@IBOutlet weak var priceInReais: UILabel!
	@IBOutlet weak var productCounter: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setCellWith(_ product: Product, andCounter counter: Int) {
		
		let priceInDollarsAsDouble = product.priceInDollars
		let americanDollarExchangeRate = userDefaults.double(forKey: "AmericanDollarExchangeRate")
		let priceInRealBrasileiroAsDouble = priceInDollarsAsDouble * americanDollarExchangeRate
	
		let formattedPriceAsDollar = calculator.convertDoubleToCurrency(double: priceInDollarsAsDouble,
																		withLocale: .enUS,
																		returningStringWithCurrencySymbol: true)
		
		let formattedPriceAsRealBrasileiro = calculator.convertDoubleToCurrency(double: priceInRealBrasileiroAsDouble,
																				withLocale: .ptBR,
																				returningStringWithCurrencySymbol: true)
		
		productImageView.image = product.image as? UIImage ?? UIImage(named: "placeholderImage")
		productName.text       = product.productName
		priceInDollars.text    = formattedPriceAsDollar
		priceInReais.text      = formattedPriceAsRealBrasileiro
		productCounter.text    = "#\(counter + 1)"
		
	}

}
