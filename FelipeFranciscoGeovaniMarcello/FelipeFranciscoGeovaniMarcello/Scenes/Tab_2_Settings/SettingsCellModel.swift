//
//  SettingsCellModel.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import Foundation

struct SettingsCellModel {
	
	let labelText: String
	let textFieldText: String
	let percentageLabelIsHidden: Bool
	
	init(
		labelText: String,
		textFieldText: String,
		percentageLabelIsHidden: Bool = true
	) {
		self.labelText = labelText
		self.textFieldText = textFieldText
		self.percentageLabelIsHidden = percentageLabelIsHidden
	}
	
}
