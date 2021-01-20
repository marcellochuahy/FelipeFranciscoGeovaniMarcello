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
	let kindOfSettingsData: KindOfSettingsData
	
	init(
		labelText: String,
		textFieldText: String,
		percentageLabelIsHidden: Bool = true,
		kindOfSettingsData: KindOfSettingsData
	) {
		self.labelText = labelText
		self.textFieldText = textFieldText
		self.percentageLabelIsHidden = percentageLabelIsHidden
		self.kindOfSettingsData = kindOfSettingsData
	}
	
}
