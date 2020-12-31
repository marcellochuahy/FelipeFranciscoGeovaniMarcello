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
		textField.text = settingsCellModel.textFieldText
		textField.keyboardType = .decimalPad
		percentageLabel.isHidden = settingsCellModel.percentageLabelIsHidden ? true : false
	}
	
}
