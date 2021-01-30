//
//  ProdutoViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit
import CoreData

enum RequiredDataForProdutoViewController {
	
	case productNameTextField
	case producImage
	case stateOfUSATextField
	case priceinDollarsTextField

	var title: String? {
		switch self {
			case .productNameTextField:    return "Ups.\nProduto em branco."
			case .producImage:             return "Ups.\nFoto em branco."
			case .stateOfUSATextField:     return "Ups.\nEstado em branco."
			case .priceinDollarsTextField: return "Ups.\nPreço em branco."
		}
	}
	
	var message: String? {
		switch self {
			case .productNameTextField:    return "Por favor, preencha o campo \"nome do produto\"."
			case .producImage:             return "Por favor, inclua uma foto do produto comprado."
			case .stateOfUSATextField:     return "Por favor, preencha o estado americano onde o produto foi comprado."
			case .priceinDollarsTextField: return "Por favor, preencha o campo \"preço do produto em dolares\"."
		}
	}
	
}

class ProdutoViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var productNameTextField: UITextField!
	@IBOutlet weak var stateOfUsaTextField: UITextField!
	@IBOutlet weak var priceInDollarsTextField: UITextField!
	@IBOutlet weak var productOrPlaceholderImage: UIImageView!
	@IBOutlet weak var imageButton: UIButton!
	@IBOutlet weak var paymentWithCreditCardSwitch: UISwitch!
	@IBOutlet weak var addOrEditButton: UIButton!
	
	@IBOutlet weak var parentViewWithAmericanStatePicker: UIView!
	@IBOutlet weak var americanStatePickerView: UIPickerView!
	@IBOutlet weak var americanStatePickerViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	
	let statesManager = StatesManager.shared
	let userDefaults = UserDefaults.standard
	
	var product: Product?
	var state: State?
	let pickerViewBottomConstraintConstant: CGFloat = -260

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

		setTitleAndButton()
		setupProductNameTextField()
		setupStateOfUSATextField()
		setupPriceInDollarsTextField()
		setupAddOrEditButton()
		setupPickerView()

		loadProductDataIfProductIsNotNil()
		
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		statesManager.getStates(withContext: context)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		hideBluredViewWithPicker()
		view.endEditing(true)
	}
	
	// MARK: - Methods
	
	private func setTitleAndButton() {
		
		if let product = product {
			title = product.productName
			addOrEditButton.setTitle("Editar", for: .normal)
		} else {
			title = "Cadastrar Produto"
			addOrEditButton.setTitle("Cadastrar", for: .normal)
		}

	}

	private func setupProductNameTextField() {

		let keyboardBackgroundColor = getKeyboardBackgroundColor(forTextField: productNameTextField)
		
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
		toolBar.barTintColor = keyboardBackgroundColor
		toolBar.setItems([okButton, flexibleSpace, nextButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
		
		productNameTextField.delegate = self
		productNameTextField.inputAccessoryView = toolBar
		productNameTextField.autocapitalizationType = .words

	}
	
	private func setupPriceInDollarsTextField() {
		
		let toolBar = UIToolbar()
		let okButton = UIBarButtonItem(title: "ok",
									   style: .done,
									   target: self,
									   action: #selector(okButtonWasTapped))
		
		toolBar.barStyle = UIBarStyle.default
		toolBar.setItems([okButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		toolBar.sizeToFit()
		
		priceInDollarsTextField.delegate = self
		priceInDollarsTextField.keyboardType = .decimalPad
		priceInDollarsTextField.inputAccessoryView = toolBar
	}

	private func setupStateOfUSATextField() {
		stateOfUsaTextField.delegate = self
	}
	
	private func setupAddOrEditButton() {
		addOrEditButton.backgroundColor = .systemGray5
	}

	private func setupPickerView() {
		
		americanStatePickerView.dataSource = self
		americanStatePickerView.delegate = self

		if
			let state = product?.state,
			let row = statesManager.states.firstIndex(of: state) {
			americanStatePickerView.selectRow(row, inComponent: 0, animated: false)
		}

		parentViewWithAmericanStatePicker.isHidden = true
		
	}
	
	private func loadProductDataIfProductIsNotNil() {
		
		if let product = product {
			
			let priceInDollarsAsDouble = product.priceInDollars
			
			let formattedPriceAsDollar = calculator.convertDoubleToCurrency(double: priceInDollarsAsDouble,
																			withLocale: .enUS,
																			returningStringWithCurrencySymbol: false)
			
			productNameTextField.text        = product.productName
			productOrPlaceholderImage.image  = product.image as? UIImage
			stateOfUsaTextField.text         = product.state?.stateName
			priceInDollarsTextField.text     = formattedPriceAsDollar
			paymentWithCreditCardSwitch.isOn = product.paymentWithCreditCard
			
		}
		
	}
	
	@objc
	private func okButtonWasTapped() {
		view.endEditing(true)
	}
	
	@objc
	private func nextButtonWasTapped() {
		view.endEditing(true)
		
		// TODO: - ⚠️
		// showBluredViewWithAmericanStatePicker()
	}
	
	// MARK: - Handler methods
	
	private func getKeyboardBackgroundColor(forTextField textField: UITextField) -> UIColor {
		
		let gray = UIColor(red: 214/255, green: 216/255, blue: 221/255, alpha: 1)
		var backgroundColor: UIColor
		
		switch textField.keyboardAppearance {
			case .default:
				backgroundColor = gray
			case .dark:
				backgroundColor = .systemGray
			case .light:
				backgroundColor = .systemGray6
			@unknown default:
				backgroundColor = .systemGray6
		}
		
		return backgroundColor
		
	}
	
    // MARK: - Actions
	@IBAction func imageButtonWasTapped(_ sender: UIButton) {
		showAlertControllerAsActionSheet(viewController: self)
	}

	@IBAction func addOrEditButtonWasTapped(_ sender: UIButton) {
		if product == nil {
			addNewProduct()
		} else {
			editProduct()
		}
	}

	private func addNewProduct() {
		product = Product(context: context)
		saveProduct()
	}
	
	private func editProduct() {
		saveProduct()
	}
	
	private func saveProduct() {
		
		if let product = product {
		
			let isProductImageSelected = productOrPlaceholderImage.image != UIImage(named: "placeholderImage")
			
			if    productNameTextField.text?.isEmpty ?? true { return showAlert(forMissingRequiredData: .productNameTextField) }
			guard isProductImageSelected else                { return showAlert(forMissingRequiredData: .producImage) }
			if     stateOfUsaTextField.text?.isEmpty ?? true { return showAlert(forMissingRequiredData: .stateOfUSATextField) }
			if priceInDollarsTextField.text?.isEmpty ?? true { return showAlert(forMissingRequiredData: .priceinDollarsTextField) }

			let priceInDollarsAsString = priceInDollarsTextField.text ?? "0.00"
			let priceInDollarsAsDouble = calculator.convertStringToDouble(numberAsString: priceInDollarsAsString)

			product.productName           = productNameTextField.text
			product.image                 = productOrPlaceholderImage.image
			product.state                 = state
			product.priceInDollars        = priceInDollarsAsDouble
			product.paymentWithCreditCard = paymentWithCreditCardSwitch.isOn
			
			do {
				try context.save()
			} catch {
				print(error.localizedDescription)
			}
			
			navigationController?.popViewController(animated: true)
			
		} else {
			print("Unknowed error")
		}
		
	}
	
	private func showAlert(forMissingRequiredData requiredData: RequiredDataForProdutoViewController) {

		let alertController = UIAlertController(title: requiredData.title,
												message: requiredData.message,
												preferredStyle: .alert)

		alertController.addAction( UIAlertAction( title: "fechar", style: .default, handler: nil) )

		let productNameAction = UIAlertAction(title: "preencher", style: .default){ _ in self.productNameTextField.becomeFirstResponder() }
		let stateOfUsaAction = UIAlertAction(title: "preencher", style: .default){ _ in self.stateOfUsaTextField.becomeFirstResponder() }
		let priceInDollarsAction = UIAlertAction(title: "preencher", style: .default){ _ in self.priceInDollarsTextField.becomeFirstResponder() }
		
		switch requiredData {
			case .productNameTextField:    alertController.addAction(productNameAction)
			case .stateOfUSATextField:     alertController.addAction(stateOfUsaAction)
			case .priceinDollarsTextField: alertController.addAction(priceInDollarsAction)
			case .producImage: break
		}

		present(alertController, animated: true, completion: nil)

	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "addStateSegue" {
			let destinationNavigationController = segue.destination as! UINavigationController
			let settingsTableViewController = destinationNavigationController.topViewController as! SettingsTableViewController
			settingsTableViewController.showDismissButtonAsLeftBarButtonItem = true
		}
	}

}

// MARK: - UITextFieldDelegate
extension ProdutoViewController: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		switch textField {
			
			case productNameTextField:
			print("productNameTextField")
			
			case stateOfUsaTextField:
			print("stateOfUsaTextField")
			textField.resignFirstResponder()
			showBluredViewWithAmericanStatePicker()
			
			case priceInDollarsTextField:
			print("priceInDollarsTextField")
			
			default:
			print("DEFAULT")
		}

	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if
		!(productNameTextField.text?.isEmpty    ?? true) &&
		!(stateOfUsaTextField.text?.isEmpty     ?? true) &&
		!(priceInDollarsTextField.text?.isEmpty ?? true) {
			addOrEditButton.backgroundColor = .systemBlue
		}
	}
	
}

// MARK: - UIPickerView animations (show and hide)
extension ProdutoViewController {
	
	func hideBluredViewWithPicker() {
		americanStatePickerViewBottomConstraint.constant = pickerViewBottomConstraintConstant
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 1.0,
			initialSpringVelocity: 1.0,
			options: .curveEaseInOut,
			animations: { self.view.layoutIfNeeded() }
		) { _ in
			self.parentViewWithAmericanStatePicker.isHidden = true
		}
	}
	
	func showBluredViewWithAmericanStatePicker() {
		parentViewWithAmericanStatePicker.isHidden = false
		americanStatePickerViewBottomConstraint.constant = 0
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 1.0,
			initialSpringVelocity: 1.0,
			options: .curveEaseInOut,
			animations: { self.view.layoutIfNeeded() }
		)
	}
	
	
	@IBAction func americanStatePickerOKBarButtonItemWasTapped(_ sender: UIBarButtonItem) {
		hideBluredViewWithPicker()
	}
	
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension ProdutoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return statesManager.states.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return statesManager.states[row].stateName
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		state = statesManager.states[row]
		product?.state = state
		stateOfUsaTextField.text = state?.stateName
	}
	
}

// MARK: - UIImagePickerController
extension ProdutoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func showAlertControllerAsActionSheet(viewController: UIViewController) {
		
		let alertControllerAsActionSheet = UIAlertController(title: "Selecionar foto",
															 message: "De onde você quer escolher a foto",
															 preferredStyle: .actionSheet)
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
				self.getImage(fromSourceType: .camera)
			})
			alertControllerAsActionSheet.addAction(cameraAction)
		}
		
		let photoLibraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
			self.getImage(fromSourceType: .photoLibrary)
		}
		alertControllerAsActionSheet.addAction(photoLibraryAction)
	
		let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
		alertControllerAsActionSheet.addAction(cancelAction)
		
		present(alertControllerAsActionSheet, animated: true, completion: nil)
		
	}
	
	func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = sourceType
		imagePickerController.delegate = self
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
//	func imagePickerController(_ picker: UIImagePickerController,
//							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//		if let image = info[.originalImage] as? UIImage {
//			// TODO
//		} else {
//			print("Something went wrong")
//		}
//	}
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		let image = info[.originalImage] as? UIImage
		
		productOrPlaceholderImage.image = image
		
		dismiss(animated: true, completion: nil)
		
	}
	
	

}
