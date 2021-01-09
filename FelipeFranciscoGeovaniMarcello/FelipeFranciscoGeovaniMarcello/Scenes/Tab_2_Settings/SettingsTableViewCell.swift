//
//  SettingsTableViewCell.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var percentageLabel: UILabel!

	func configure(withSettingsCellModel settingsCellModel: SettingsCellModel) {
		
		titleLabel.text = settingsCellModel.labelText

		// let inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
		// inputAccessoryView.backgroundColor = UIColor.red
		
		// ---------------------------------------------------------------------------------
		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton  = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonWasTapped) )

		
		let toolBar = UIToolbar()
		
		//let customAccessoryView = UIInputView(frame: CGRect(x: 0, y: 0, width: 0, height: 44), inputViewStyle: .keyboard)
		
		
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		//toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		toolBar.setItems([spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
	
		textField.inputAccessoryView = toolBar
		textField.text = settingsCellModel.textFieldText
		textField.keyboardType = .decimalPad

		percentageLabel.isHidden = settingsCellModel.percentageLabelIsHidden ? true : false
		
	}
	
	@objc func doneButtonWasTapped() {
		textField.resignFirstResponder()
	}
	
}
