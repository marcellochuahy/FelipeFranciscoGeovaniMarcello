//
//  SettingsTableViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 31/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
	
	// MARK: - Properties
	
	let statesManager = StatesManager.shared
	
	let userDefaults = UserDefaults.standard
	
	private(set) lazy var americanDollarExchangeRate: Double = {
		return userDefaults.double(forKey: "AmericanDollarExchangeRate")
	}()
	
	private(set) lazy var iof: Double = {
		return userDefaults.double(forKey: "IOF")
	}()

	
	private(set) lazy var label: UILabel = {
		let label = UILabel()
		label.text = "Lista de estados vazia!"
		label.textAlignment = .center
		return label
	}()
	
	var showDismissButtonAsLeftBarButtonItem = false
	
	// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
		getStates()
		setupTableView()
		setupBarButtonItems()
    }
	
	// MARK: - Methods
	
	func setupBarButtonItems() {
		
		if showDismissButtonAsLeftBarButtonItem {
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
															   target: self,
															   action: #selector(dismissButtonWasTapped))
		} else {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Adcionar estado",
															   style: .plain,
															   target: self, action: #selector(addStateButtonWasTapped))
		}
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem
		
	}
	
	func setupTableView() {
		tableView.separatorStyle = .none
	}

	func getStates() {
		statesManager.getStates(withContext: context)
		tableView.reloadData()
	}
	
	@objc
	func dismissButtonWasTapped () {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc
	func addStateButtonWasTapped() {
		showAlert(withState: nil)
	}
	
	func showAlert(withState state: State?) {
		
		let actionAsString = (state == nil ? "Adcionar" : "Editar")
		
		let title = actionAsString + " estado americano"
	
		let alertController = UIAlertController(title: title,
												message: nil,
												preferredStyle: .alert)
		
		alertController.addTextField { textField in
			textField.placeholder = "Nome do estado"
			textField.autocapitalizationType = .words
			if let state = state { textField.text = state.stateName }
		}
		
		let action = UIAlertAction(title: actionAsString, style: .default) { (action: UIAlertAction) in
			self.saveStateAndGetRefreshedStates(withAlertController: alertController, andState: state)
		}
		
		alertController.addAction(action)
		
		present(alertController, animated: true, completion: nil)
	
	}
	
	func saveStateAndGetRefreshedStates(withAlertController alertController: UIAlertController, andState state: State?) {
		
		let state = state ?? State(context: self.context)
		state.stateName = alertController.textFields?.first?.text
		
		do {
			try self.context.save()
			self.getStates()
		} catch {
			print(error.localizedDescription)
		}
		
	}

    // MARK: - Table view data source
	


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

// MARK: - Table view data source
extension SettingsTableViewController {
	
	enum SettingsSections: CaseIterable {
		
		case dollar
		case iof
		case stateAndTax
		
		static func numberOfSections() -> Int { self.allCases.count }
		static func getSection(_ section: Int) -> SettingsSections { self.allCases[section] }
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return SettingsSections.numberOfSections()
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))
		
		let label = UILabel()
		label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
		label.text = "Impostos por estado americano"
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 18)
		
		headerView.addSubview(label)
		
		switch SettingsSections.getSection(section) {
			case .dollar:
				return nil
			case .iof:
				return nil
			case .stateAndTax:
				return headerView
		}
		
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch SettingsSections.getSection(section) {
			case .dollar:
				return 0
			case .iof:
				return 0
			case .stateAndTax:
				return 44
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch SettingsSections.getSection(section) {
			case .dollar:
				return 1
			case .iof:
				return 1
			case .stateAndTax:
				if statesManager.states.count == 0 {
					tableView.backgroundView = label
				}
				return statesManager.states.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
		
		switch SettingsSections.getSection(indexPath.section) {
			
			case .dollar:
				
				let textFieldText = calculator.convertDoubleToString(double: americanDollarExchangeRate)
				
				let cellForSectionDolar = SettingsCellModel(labelText: "Cotação do Dolar (R$):",
															textFieldText: textFieldText,
															percentageLabelIsHidden: true,
															kindOfSettingsData: .dollar)
				
				cell.configure(delegate: self, withSettingsCellModel: cellForSectionDolar)
			
			case .iof:
				
				let textFieldText = calculator.convertDoubleToString(double: iof)
				
				let cellForSectionIOF = SettingsCellModel(labelText: "IOF:",
														  textFieldText: textFieldText,
														  percentageLabelIsHidden: false,
														  kindOfSettingsData: .iof)
				
				cell.configure(delegate: self, withSettingsCellModel: cellForSectionIOF)
			
			case .stateAndTax:
				
				let state = statesManager.states[indexPath.row].stateName ?? ""
				let tax   = String(statesManager.states[indexPath.row].tax)
				
				let cellForSectionStateAndTax = SettingsCellModel(labelText: state,
																  textFieldText: tax,
																  percentageLabelIsHidden: false,
																  kindOfSettingsData: .state)
				
				cell.configure(delegate: self, withSettingsCellModel: cellForSectionStateAndTax)
			
		}
		
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		switch SettingsSections.getSection(indexPath.section) {
			case .dollar:
				return false
			case .iof:
				return false
			case .stateAndTax:
				return true
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
	
}

// MARK: - SettingsTableViewCellDelegate
extension SettingsTableViewController: SettingsTableViewCellDelegate {

	func textField(_ textField: UITextField, valueHasChanged: Bool, for kindOfSettingsData: KindOfSettingsData) {
		
		switch kindOfSettingsData {
			case .dollar:
				guard let americanDollarExchangeRateAsString = textField.text else { return }
				let americanDollarExchangeRateAsDouble = calculator.convertStringToDouble(string: americanDollarExchangeRateAsString)
				saveDollar(americanDollarExchangeRateAsDouble: americanDollarExchangeRateAsDouble)
			case .iof:
				guard let iofAsString = textField.text else { return }
				let iofAsDouble = calculator.convertStringToDouble(string: iofAsString)
				saveIof(iofAsDouble: iofAsDouble)
			case .state:
				print("⚠️ state")
		}
		
		
	}
	
	func saveDollar(americanDollarExchangeRateAsDouble: Double) {
		print("Saving key AmericanDollarExchangeRateAsDouble: \(americanDollarExchangeRateAsDouble)")
		userDefaults.set(americanDollarExchangeRateAsDouble, forKey: "AmericanDollarExchangeRate")
	}
	
	func saveIof(iofAsDouble: Double) {
		print("Saving key IOF: \(iofAsDouble)")
		userDefaults.set(iofAsDouble, forKey: "IOF")
	}

}

// MARK: - CoreData
extension SettingsTableViewController: NSFetchedResultsControllerDelegate {
		
		func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
						didChange anObject: Any,
						at indexPath: IndexPath?,
						for type: NSFetchedResultsChangeType,
						newIndexPath: IndexPath?) {
			
			switch type {
				case .delete:
					break
				default:
					tableView.reloadData()
			}
			
		}
		
}
