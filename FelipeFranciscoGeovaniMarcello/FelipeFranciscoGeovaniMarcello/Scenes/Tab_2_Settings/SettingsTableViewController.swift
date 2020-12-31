//
//  SettingsTableViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

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
			case .dolar:       return "Dólar"
			case .iof:         return "IOF"
			case .stateAndTax: return "Estados e Impostos"
		}
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch SettingsSections.getSection(section) {
			case .dolar:       return 1
			case .iof:         return 1
			case .stateAndTax: return StateOfUSA.allCases.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
	
		let states = StateOfUSA.allCases
		let state  = states[indexPath.row].rawValue
		let tax    = "9.99" // TODO: - ⚠️
		
		let cellForSectionDolar = SettingsCellModel(labelText: "Cotação do Dolar (R$):", textFieldText: "5,00")
		let cellForSectionIOF = SettingsCellModel(labelText: "IOF:", textFieldText: "0,00", percentageLabelIsHidden: false)
		let cellForSectionStateAndTax = SettingsCellModel(labelText: state, textFieldText: tax,    percentageLabelIsHidden: false)
		
		switch SettingsSections.getSection(indexPath.section) {
			case .dolar:
				cell.configure(withSettingsCellModel: cellForSectionDolar)
			case .iof:
				cell.configure(withSettingsCellModel: cellForSectionIOF)
			case .stateAndTax:
				cell.configure(withSettingsCellModel: cellForSectionStateAndTax)
		}
		
		return cell

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
