//
//  ComprasTableViewController.swift
//  FelipeFranciscoGeovaniMarcello
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import UIKit
import CoreData


// ⚠️ TODO
protocol ProductProtocol: class {
	var productName: String { get set }
	var imageName: String { get set }
	var priceInDollars: Double { get set }
}

class ComprasTableViewController: UITableViewController {
	
	// MARK: - Properties

	private(set) lazy var label: UILabel = {
		let label = UILabel()
		label.text = "Sua lista está vazia!"
		label.textAlignment = .center
		return label
	}()

	var mockedProducts: [AnyObject] = []
	var fetchedResultsController: NSFetchedResultsController<Product>!
	
	// MARK: - Outlets

	
	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Compras"
		configureTableView()
		fetchProducts()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - Methods
	func configureTableView() {
		tableView.separatorStyle = .none
	}
	
	func fetchProducts() {
		
		let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
		let sortDescriptorAsProductName = NSSortDescriptor(key: "productName", ascending: true)
		
		fetchRequest.sortDescriptors = [sortDescriptorAsProductName]
		
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
															  managedObjectContext: context,
															  sectionNameKeyPath: nil,
															  cacheName: nil)
		
		fetchedResultsController.delegate = self
		
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print(error.localizedDescription)
		}
		
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

		let count = fetchedResultsController.fetchedObjects?.count ?? 0

		if count == 0 {
			tableView.backgroundView = label
			return 0
		} else {
			return 1
		}
		
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell", for: indexPath) as? ProductTableViewCell,
			let product = fetchedResultsController.fetchedObjects?[indexPath.row]
		else {
			return UITableViewCell()
		}

		cell.setCellWith(product, andCounter: indexPath.row)

		return cell
	}
	

	
    /*

    */

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
    
	
	editProductSegue
	addProductSegue
*/

    // MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "editProductSegue" {
			let nextViewController = segue.destination as! ProdutoViewController
			if let products = fetchedResultsController.fetchedObjects {
				nextViewController.product = products[tableView.indexPathForSelectedRow!.row]
			}
		}
    }
    

}

// MARK: - CoreData Extension

extension ComprasTableViewController: NSFetchedResultsControllerDelegate {
	
	// Performe some action when value did change
	
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
