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
	let searchController = UISearchController(searchResultsController: nil)
	
	// MARK: - Outlets

	
	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Compras"
		configureNavigationItem()
		configureSearchController()
		configureTableView()
		//fetchProducts()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchProducts()
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - Methods
	
	func configureNavigationItem() {
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		navigationItem.searchController = searchController
	}
	
	func configureTableView() {
		tableView.separatorStyle = .none
	}
	
	func fetchProducts(withFilter filter: String = "") {
		
		let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
		let sortDescriptorAsProductName = NSSortDescriptor(key: "productName", ascending: true)
		
		if !filter.isEmpty {
			let predicate = NSPredicate(format: "productName contains [c] %@", filter) // [c]: Case insensitive
			fetchRequest.predicate = predicate
		}
		
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
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRowsInSection = fetchedResultsController.fetchedObjects?.count ?? 0
		if numberOfRowsInSection == 0 {
			label.text = "Sua lista está vazia!"
			tableView.backgroundView = label
		} else {
			label.text = ""
			tableView.backgroundView = label
		}
        return numberOfRowsInSection
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

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			guard let product = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
			
			context.delete(product)
			
			do {
				try context.save()
			} catch {
				print(error.localizedDescription)
			}

        }
		
    }

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
				guard let indexPath = indexPath else { return }
				tableView.deleteRows(at: [indexPath], with: .fade)
			default:
				tableView.reloadData()
		}
		
	}
	
}

extension ComprasTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		fetchProducts(withFilter: searchBar.text ?? "")
		tableView.reloadData()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		fetchProducts()
		tableView.reloadData()
	}

	func updateSearchResults(for searchController: UISearchController) {
		// Intencionally not implemented
	}
	
}
