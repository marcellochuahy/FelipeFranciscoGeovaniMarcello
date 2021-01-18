//
//  SettingsTableViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
	
	var statesManager = StatesManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
		
		getStates()
	
		tableView.separatorStyle = .none

        // TODO -  ocultar se modally
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(fechar))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	func getStates() {
		statesManager.getStates(withContext: context)
		tableView.reloadData()
	}
	
	@objc
	func fechar() {
		self.dismiss(animated: true, completion: nil)
	}

    // MARK: - Table view data source
	
	enum SettingsSections: CaseIterable {
		
		case dolar
		case iof
		case stateAndTax
		
		static func numberOfSections() -> Int { self.allCases.count }
		static func getSection(_ section: Int) -> SettingsSections { self.allCases[section] }
		
	}
	
    override func numberOfSections(in tableView: UITableView) -> Int {
		return SettingsSections.numberOfSections()
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		switch SettingsSections.getSection(section) {
			case .dolar:       return nil //"Dólar"
			case .iof:         return nil // "IOF"
			case .stateAndTax: return "Estados e Impostos"
		}

	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))
		headerView.backgroundColor = .red
		
		let label = UILabel()
		label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
		label.text = "Notification Times"
		label.backgroundColor = .green
		//label.font = UIFont().futuraPTMediumFont(16) // my custom font
		//label.textColor = UIColor.charcolBlackColour() // my custom colour
		
		headerView.addSubview(label)
		
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch SettingsSections.getSection(section) {
			case .dolar:       return 1
			case .iof:         return 1
			case .stateAndTax: return statesManager.states.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
	
		// let states = StateOfUSA.allCases
		// let state  = states[indexPath.row].rawValue
		// let tax    = "9.99" // TODO: - ⚠️

		switch SettingsSections.getSection(indexPath.section) {
			case .dolar:
				
				let cellForSectionDolar = SettingsCellModel(labelText: "Cotação do Dolar (R$):",
															textFieldText: "5,00")
				
				cell.configure(withSettingsCellModel: cellForSectionDolar)
			
			case .iof:
				
				let cellForSectionIOF = SettingsCellModel(labelText: "IOF:",
														  textFieldText: "0,00",
														  percentageLabelIsHidden: false)
				
				cell.configure(withSettingsCellModel: cellForSectionIOF)
			
			case .stateAndTax:
				
				let state = statesManager.states[indexPath.row].stateName ?? ""
				let tax   = String(statesManager.states[indexPath.row].tax)
				
				let cellForSectionStateAndTax = SettingsCellModel(labelText: state,
																  textFieldText: tax,
																  percentageLabelIsHidden: false)
				
				cell.configure(withSettingsCellModel: cellForSectionStateAndTax)
			
			
			tableView.backgroundView = label
			
			
			
			
		}

		return cell

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		switch SettingsSections.getSection(indexPath.section) {
			case .dolar:       return false
			case .iof:         return false
			case .stateAndTax: return true
		}
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
