//
//  ProdutoViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit

class ProdutoViewController: UIViewController {
	
	lazy var felizNatal: Bool = { true }()
	
	// MARK: - Outlets
	@IBOutlet weak var productNameTextField: UITextField!
	@IBOutlet weak var stateOfUSATextField: UITextField!
	@IBOutlet weak var priceinDollarsTextField: UITextField!
	@IBOutlet weak var placeholderImage: UIImageView!
	@IBOutlet weak var imageButton: UIButton!
	@IBOutlet weak var paymentWithCreditCardSwitch: UISwitch!
	@IBOutlet weak var cadastrarButton: UIButton!
	
	@IBOutlet weak var bluredViewWithPicker: UIView!
	@IBOutlet weak var pickerView: UIPickerView!
	
	// MARK: - Properties
	var product: Product!
	var selectedState: StateOfUSA?

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Cadastrar Produto"
		setupStateOfUSATextField()
		setupPickerView()
    }
	
	// MARK: - Methods
	
	func setupStateOfUSATextField() {
		stateOfUSATextField.delegate = self
	}
	
	func setupPickerView() {
		pickerView.dataSource = self
		pickerView.delegate = self
		bluredViewWithPicker.isHidden = true
	}

    // MARK: - Actions
	@IBAction func imageButtonWasTapped(_ sender: UIButton) {
		// TODO: - ⚠️
		// Ao clicar na imagem de presente, o usuário poderá escolher se deseja inserir a foto do produto através da Biblioteca de fotos ou da Câmera, só mostrando câmera caso ela exista no device.
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
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		bluredViewWithPicker.isHidden = true
	}
	
	// MARK: - Handler Methods
	private func addNewProduct() {
		
		// Product:
		// --------------------------
		
		guard let productName = productNameTextField.text else { return showAlert() }
		guard let selectedState = selectedState else { return showAlert() }
		guard let priceinDollars = priceinDollarsTextField.text else { return showAlert() }

		product = Product(context: context)
		
		product.productName = productName
		product.state = selectedState
		product.priceInDollars = Double(priceinDollars) ?? 0.00
		
		// State:
		// --------------------------
		
		// state = State(context: context)
		// state.state = .california // ⚠️ TODO
		
		
		do {
			try context.save()
		} catch {
			print(error.localizedDescription) // ⚠️ TODO
		}
		
		navigationController?.popViewController(animated: true)
	
	}
	
	private func editProduct() {
		
	}
	
	func showAlert() {
		print("ALERT: ")
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

extension ProdutoViewController: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		bluredViewWithPicker.isHidden = false
	}
}

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
		// TODO: - ⚠️
		stateOfUSATextField.text = states[row].rawValue
	}
	
	
}
