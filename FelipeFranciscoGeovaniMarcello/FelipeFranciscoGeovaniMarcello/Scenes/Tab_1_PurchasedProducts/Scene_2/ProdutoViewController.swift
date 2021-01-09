//
//  ProdutoViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

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
	@IBOutlet weak var placeholderImage: UIImageView!
	@IBOutlet weak var imageButton: UIButton!
	@IBOutlet weak var paymentWithCreditCardSwitch: UISwitch!
	@IBOutlet weak var cadastrarButton: UIButton!
	@IBOutlet weak var bluredViewWithPicker: UIView!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var product: Product!
	var selectedState: StateOfUSA?
	let pickerViewBottomConstraintConstant: CGFloat = -260

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Cadastrar Produto"
		setupProductNameTextField()
		setupPriceInDollarsTextField()
		setupCadastrarButton()
		setupStateOfUSATextField()
		setupPickerView()
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		hideBluredViewWithPicker()
		view.endEditing(true)
	}
	
	// MARK: - Methods
	
	func getKeyboardBackgroundColor(forTextField textField: UITextField) -> UIColor {
		let gray = UIColor(red: 214/255, green: 216/255, blue: 221/255, alpha: 1)
		var backgroundColor: UIColor
		switch textField.keyboardAppearance {
			case .default:
				print("COR default")
				backgroundColor = gray
			case .dark:
				print("COR dark")
				backgroundColor = .systemGray
			case .light:
				print("COR light")
				backgroundColor = .systemGray6
			@unknown default:
				print("COR unknown")
				backgroundColor = .systemGray6
		}
		return backgroundColor
	}
	
	func setupProductNameTextField() {

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

	}
	
	func setupPriceInDollarsTextField() {
		
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

	func setupCadastrarButton() {
		cadastrarButton.backgroundColor = .systemGray5
	}
	
	func setupStateOfUSATextField() {
		stateOfUsaTextField.delegate = self
	}
	
	func setupPickerView() {
		pickerView.dataSource = self
		pickerView.delegate = self
		bluredViewWithPicker.isHidden = true
	}
	
	@objc
	func okButtonWasTapped() {
		view.endEditing(true)
	}
	
	@objc
	func nextButtonWasTapped() {
		view.endEditing(true)
		showBluredViewWithPicker()
	}

    // MARK: - Actions
	@IBAction func imageButtonWasTapped(_ sender: UIButton) {
		// TODO: - ⚠️
		// Ao clicar na imagem de presente, o usuário poderá escolher se deseja inserir a foto do produto através da Biblioteca de fotos ou da Câmera, só mostrando câmera caso ela exista no device.
	}
	
	@IBAction func okPickerBarButtonItemWasTapped(_ sender: UIBarButtonItem) {
		hideBluredViewWithPicker()
	}
	
	
//	@IBAction func addButtonWasTapped(_ sender: UIButton) {
//		// TODO: - ⚠️
//		// Clicando no botão +, o usuário será levado para a tela de Ajustes, onde poderá cadastrar os Estados que serão selecionados pelo UITextField “Estado da compra”.
//
//	}
	
	
	
	
	@IBAction func cadastrarButtonWasTapped(_ sender: UIButton) {
		if product == nil {
			addNewProduct()
		} else {
			editProduct()
		}
	}
	

	
	// MARK: - Handler Methods
	private func addNewProduct() {
		
		let isProductImageSelected = placeholderImage.image != UIImage(named: "placeholderImage")
		
		if productNameTextField.text?.isEmpty ?? true    { return showAlert(forRequiredData: .productNameTextField) }
        
		guard let selectedState = selectedState else     { return showAlert(forRequiredData: .stateOfUSATextField) }
		
		if priceInDollarsTextField.text?.isEmpty ?? true { return showAlert(forRequiredData: .priceinDollarsTextField) }

		guard isProductImageSelected else { return showAlert(forRequiredData: .producImage) }
		
		// Product:
		// --------------------------

		product = Product(context: context)

		product.productName = productNameTextField.text
		product.state = selectedState
		let priceinDollars = priceInDollarsTextField.text ?? ""
		product.priceInDollars = Double(priceinDollars) ?? 0.00
		
		// State:
		// --------------------------
		
		 //state = State(context: context)
		 //state.state = .california // ⚠️ TODO
		
		
		do {
			try context.save()
		} catch {
			print(error.localizedDescription) // ⚠️ TODO
		}
		
		navigationController?.popViewController(animated: true)
	
	}
	
	private func editProduct() {
		
	}
	
	func showAlert(forRequiredData requiredData: RequiredDataForProdutoViewController) {

		let alertController = UIAlertController(title: requiredData.title,
												message: requiredData.message,
												preferredStyle: .alert)

		// add okAction
		alertController.addAction( UIAlertAction( title: "fechar", style: .default, handler: nil) )

		// add preencherAction
		switch requiredData {
			case .productNameTextField:    alertController.addAction( UIAlertAction(title: "preencher", style: .default){ _ in self.productNameTextField.becomeFirstResponder() }    )
			case .stateOfUSATextField:     alertController.addAction( UIAlertAction(title: "preencher", style: .default){ _ in self.stateOfUsaTextField.becomeFirstResponder() }     )
			case .priceinDollarsTextField: alertController.addAction( UIAlertAction(title: "preencher", style: .default){ _ in self.priceInDollarsTextField.becomeFirstResponder() } )
			case .producImage: break
		}

		present(alertController, animated: true, completion: nil)

	}



	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
			showBluredViewWithPicker()
			
			case priceInDollarsTextField:
			print("priceInDollarsTextField")
			
			default:
			print("DEFAULT")
		}
		
		
		
	}
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension ProdutoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return StateOfUSA.allCases.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let states = StateOfUSA.allCases
		return states[row].rawValue
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let states = StateOfUSA.allCases
		selectedState = states[row]
		stateOfUsaTextField.text = selectedState?.rawValue
	}
	
}

// MARK: - UIPickerView animations (show and hide)
extension ProdutoViewController {
	
	func hideBluredViewWithPicker() {
		pickerViewBottomConstraint.constant = pickerViewBottomConstraintConstant
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 1.0,
			initialSpringVelocity: 1.0,
			options: .curveEaseInOut,
			animations: { self.view.layoutIfNeeded() }
		) { _ in
			self.bluredViewWithPicker.isHidden = true
		}
	}
	
	func showBluredViewWithPicker() {
		bluredViewWithPicker.isHidden = false
		pickerViewBottomConstraint.constant = 0
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 1.0,
			initialSpringVelocity: 1.0,
			options: .curveEaseInOut,
			animations: { self.view.layoutIfNeeded() }
		)
	}
	
}
