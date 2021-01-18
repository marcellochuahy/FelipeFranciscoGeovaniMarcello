//
//  ProductTableViewCell.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 19/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
	
	let currencyExchangeRate = 5.00 // ⚠️ TODO

	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var priceInDollars: UILabel!
	@IBOutlet weak var priceInReais: UILabel!
	@IBOutlet weak var productCounter: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
	
	func setCellWith(_ product: Product, andCounter counter: Int) {
		productImageView.image = product.image as? UIImage ?? UIImage(named: "placeholderImage")
		productName.text = product.productName
		priceInDollars.text = "US$ \(product.priceInDollars)" // ⚠️ TODO
		priceInReais.text = "R$ \(product.priceInDollars * currencyExchangeRate)" // ⚠️ TODO
		productCounter.text = "#\(counter + 1)"
	}

}
