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

	private(set) lazy var label: UILabel = {
		let label = UILabel()
		label.text = "Lista de estados vazia!"
		label.textAlignment = .center
		return label
	}()
	
	private(set) lazy var toolBar: UIToolbar = {
		
		let toolBar = UIToolbar()
		
		let okButton = UIBarButtonItem(title: "ok",
									   style: .done,
									   target: self,
									   action: #selector(okButtonWasTapped))
		
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
											target: nil,
											action: nil)
		
		let nextButton = UIBarButtonItem(title: "next",
										 style: .done,
										 target: self,
										 action: #selector(nextButtonWasTapped))
		
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = false
		// TODO: - toolBar.barTintColor = keyboardBackgroundColor
		toolBar.setItems([okButton, flexibleSpace, nextButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
		
		return toolBar
		
	}()
	
	private(set) lazy var americanStatePickerView: UIPickerView = {
		let datePicker = UIPickerView()
		datePicker.dataSource = self
		datePicker.delegate = self
		return datePicker
	}()

	var americanStateNameStateTextFieldPicker: UITextField?
	var americanStateTaxTextFieldPicker: UITextField?

	var showDismissButtonAsLeftBarButtonItem = false
	
	// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
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
		showConfigurationStateNameAndTaxAlert(withState: nil)
	}
	
	func showConfigurationStateNameAndTaxAlert(withState state: State?) {
		
		let actionAsString = (state == nil ? "Adcionar" : "Editar")
		
		let title = actionAsString + " estado americano"
	
		let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		
		let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
		
		let AddOrEditButton = UIAlertAction(title: actionAsString, style: .default) { (action: UIAlertAction) in
			self.saveStateAndGetRefreshedStates(withAlertController: alertController, andState: state)
		}
		
		
		alertController.addTextField { textField in
			
			if let state = state {
				textField.text = state.stateName
			}
			
			textField.placeholder = "Nome do estado"
			textField.inputAccessoryView = self.toolBar
			textField.inputView = self.americanStatePickerView
			textField.delegate = self
			
			self.americanStateNameStateTextFieldPicker = textField
	
		}

		alertController.addTextField { textField in
			
			if let state = state {
				textField.text = self.calculator.convertDoubleToString(double: state.tax, withLocale: nil)
			}
			
			textField.placeholder = "Imposto do estado"
			textField.keyboardType = .decimalPad
			textField.delegate = self
			
			self.americanStateTaxTextFieldPicker = textField

		}

		alertController.addAction(cancelButton)
		
		alertController.addAction(AddOrEditButton)
		
		present(alertController, animated: true, completion: nil)
	
	}
	
	func saveStateAndGetRefreshedStates(withAlertController alertController: UIAlertController, andState state: State?) {
		
		let state = state ?? State(context: self.context)
		let stateName = alertController.textFields?[0].text
		let taxAsString = alertController.textFields?[1].text ?? "0.00"
		let taxAsDouble = calculator.convertStringToDouble(numberAsString: taxAsString)
		
		state.stateName = stateName
		state.tax = taxAsDouble

		do {
			try self.context.save()
			self.getStates()
		} catch {
			print(error.localizedDescription)
		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	@objc
	private func okButtonWasTapped() {
		view.endEditing(true)
		americanStateNameStateTextFieldPicker?.resignFirstResponder()
	}
	
	@objc
	private func nextButtonWasTapped() {
		americanStateTaxTextFieldPicker?.becomeFirstResponder()
	}
	
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
				let cellForSectionDolar = SettingsCellModel(kindOfSettingsData: .dollar, state: nil)
				cell.configureCell(withDelegate: self, andSettingsCellModel: cellForSectionDolar)
			
			case .iof:
				let cellForSectionIOF = SettingsCellModel(kindOfSettingsData: .iof, state: nil)
				cell.configureCell(withDelegate: self, andSettingsCellModel: cellForSectionIOF)
			
			case .stateAndTax:
				let state = statesManager.states[indexPath.row]
				let cellForSectionStateAndTax = SettingsCellModel(kindOfSettingsData: .state, state: state)
				cell.configureCell(withDelegate: self, andSettingsCellModel: cellForSectionStateAndTax)
			
		}
		
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if SettingsSections.getSection(indexPath.section) == .stateAndTax {
			let state = statesManager.states[indexPath.row]
			showConfigurationStateNameAndTaxAlert(withState: state)
			tableView.deselectRow(at: indexPath, animated: false)
		}
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
			switch SettingsSections.getSection(indexPath.section) {
				case .stateAndTax:
					statesManager.deleteState(at: indexPath.row, context: context)
				default:
					break
			}
		
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
}

// MARK: - SettingsTableViewCellDelegate
extension SettingsTableViewController: SettingsTableViewCellDelegate {
	
	func textField(_ textField: UITextField, valueHasChanged: Bool, inCellWithSettingsCellModel settingsCellModel: SettingsCellModel) {
	
		switch settingsCellModel.kindOfSettingsData {
			
			case .dollar:
				
				guard let americanDollarExchangeRateAsString = textField.text else { return }
				let americanDollarExchangeRateAsDouble = calculator.convertStringToDouble(numberAsString: americanDollarExchangeRateAsString)
				saveDollar(americanDollarExchangeRateAsDouble: americanDollarExchangeRateAsDouble)
			
			case .iof:
				
				guard let iofAsString = textField.text else { return }
				let iofAsDouble = calculator.convertStringToDouble(numberAsString: iofAsString)
				saveIof(iofAsDouble: iofAsDouble)
			
			case .state:
				
				guard
					let state = settingsCellModel.state,
				    let taxAsString = textField.text else { return }
				
				let taxAsDouble = calculator.convertStringToDouble(numberAsString: taxAsString)
	
				saveStateTax(state, withNewTax: taxAsDouble)
			
		}
	
	}

	private func saveDollar(americanDollarExchangeRateAsDouble: Double) {
		print("Saving key AmericanDollarExchangeRateAsDouble: \(americanDollarExchangeRateAsDouble)")
		userDefaults.set(americanDollarExchangeRateAsDouble, forKey: "AmericanDollarExchangeRate")
	}
	
	private func saveIof(iofAsDouble: Double) {
		print("Saving key IOF: \(iofAsDouble)")
		userDefaults.set(iofAsDouble, forKey: "IOF")
	}
	
	func saveStateTax(_ state: State, withNewTax taxAsDouble: Double) {

		state.tax = taxAsDouble

		do {
			try self.context.save()
			self.getStates()
		} catch {
			print(error.localizedDescription)
		}
		
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

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension SettingsTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return StateOfUSA.allCases.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return StateOfUSA.allCases[row].rawValue
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.americanStateNameStateTextFieldPicker?.text = StateOfUSA.allCases[row].rawValue
	}
	
}

extension SettingsTableViewController: UITextFieldDelegate {
	
	
}
