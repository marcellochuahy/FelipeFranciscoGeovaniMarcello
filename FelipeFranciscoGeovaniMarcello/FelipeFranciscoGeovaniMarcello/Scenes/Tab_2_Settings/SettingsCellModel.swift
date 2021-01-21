//
//  SettingsCellModel.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import Foundation

struct SettingsCellModel {
	
	let kindOfSettingsData: KindOfSettingsData
	let state: State?

	init(kindOfSettingsData: KindOfSettingsData, state: State?) {
		self.kindOfSettingsData = kindOfSettingsData
		self.state = state
	}
	
}
