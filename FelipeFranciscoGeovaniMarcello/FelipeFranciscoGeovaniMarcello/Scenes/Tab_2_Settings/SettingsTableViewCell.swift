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
	func textField(_ textField: UITextField, titleLabel: String, valueHasChanged: Bool, for kindOfSettingsData: KindOfSettingsData)
}

class SettingsTableViewCell: UITableViewCell {
	
	weak var delegate: SettingsTableViewCellDelegate?

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var percentageLabel: UILabel!
	
	var kindOfSettingsData: KindOfSettingsData?

	func configure(delegate: SettingsTableViewController, withSettingsCellModel settingsCellModel: SettingsCellModel) {
		
		self.delegate = delegate
		
		kindOfSettingsData = settingsCellModel.kindOfSettingsData
		
		titleLabel.text = settingsCellModel.labelText

		let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton  = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonWasTapped) )

		let toolBar = UIToolbar()
		toolBar.barStyle = .default
		toolBar.isTranslucent = true
		toolBar.setItems([spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
	
		textField.inputAccessoryView = toolBar
		textField.text = settingsCellModel.textFieldText
		textField.keyboardType = .decimalPad

		percentageLabel.isHidden = settingsCellModel.percentageLabelIsHidden ? true : false
		
	}
	
	@objc func doneButtonWasTapped() {

		guard let kindOfSettingsData = kindOfSettingsData, let titleLabelText = titleLabel.text else { return }
		delegate?.textField(textField, titleLabel: titleLabelText, valueHasChanged: true, for: kindOfSettingsData)
		
		textField.resignFirstResponder()
		
	}
	
}
