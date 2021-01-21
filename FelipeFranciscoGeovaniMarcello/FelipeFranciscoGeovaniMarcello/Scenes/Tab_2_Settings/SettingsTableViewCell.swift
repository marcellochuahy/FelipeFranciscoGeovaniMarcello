//
//  SettingsTableViewCell.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

enum KindOfSettingsData {
	case dollar
	case iof
	case state
}

protocol SettingsTableViewCellDelegate: class {
	func textField(_ textField: UITextField, valueHasChanged: Bool, inCellWithSettingsCellModel settingsCellModel: SettingsCellModel)
}

class SettingsTableViewCell: UITableViewCell {
	
	weak var delegate: SettingsTableViewCellDelegate?

	let userDefaults = UserDefaults.standard
	
	var settingsCellModel: SettingsCellModel?
	
	var toolBar: UIToolbar {
		let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBarButtonItem  = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonWasTapped) )
		let toolBar = UIToolbar()
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		toolBar.setItems([spaceBarButtonItem, doneBarButtonItem], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
		return toolBar
	}

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var percentageLabel: UILabel!

	func configureCell(withDelegate delegate: SettingsTableViewController, andSettingsCellModel settingsCellModel: SettingsCellModel) {

		self.delegate = delegate
		
		self.settingsCellModel = settingsCellModel

		switch settingsCellModel.kindOfSettingsData {
			
			case .dollar:
				
				let americanDollarExchangeRateAsDouble = userDefaults.double(forKey: "AmericanDollarExchangeRate")
				let americanDollarExchangeRateAsString = calculator.convertDoubleToString(double: americanDollarExchangeRateAsDouble, withLocale: nil)

				titleLabel.text = "Cotação do Dolar (R$):"
				textField.text  = americanDollarExchangeRateAsString
				percentageLabel.isHidden = true
			
			case .iof:
				
				let iofAsDouble = userDefaults.double(forKey: "IOF")
				let iosAsString = calculator.convertDoubleToString(double: iofAsDouble, withLocale: nil)
					
				titleLabel.text = "IOF:"
				textField.text  = iosAsString
				percentageLabel.isHidden = false
			
			case .state:
				
				guard
					let state = settingsCellModel.state,
					let stateName = state.stateName else { return }
				
				let taxAsDouble = state.tax
				let taxAsString = calculator.convertDoubleToString(double: taxAsDouble, withLocale: nil)
				
				titleLabel.text = "Imposto em " + stateName
				textField.text  = taxAsString
				percentageLabel.isHidden = false
	
		}

		textField.inputAccessoryView = toolBar
		textField.keyboardType = .decimalPad
		
	}
	
	@objc func doneButtonWasTapped() {
		guard let settingsCellModel = settingsCellModel else { return }
		delegate?.textField(textField, valueHasChanged: true, inCellWithSettingsCellModel: settingsCellModel)
		textField.resignFirstResponder()
	}
	
}
