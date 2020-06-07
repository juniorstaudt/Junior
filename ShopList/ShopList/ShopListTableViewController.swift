//
//  ShopListTableViewController.swift
//  ShopList
//
//  Created by Junior Staudt on 05/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ShopListTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Product>!
    var label = UILabel()
    let searchController = UISearchController(searchResultsController: nil)
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        loadShopList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "productSegue" {
            let vc = segue.destination as! ProductViewController
            if let products = fetchedResultController.fetchedObjects {
                vc.product = products[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadShopList(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "productDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "productDescription contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        //exibe a mensagem de lista vazia caso contagem igual a zero
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopTableViewCell

        guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: product)

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(product)
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

extension ShopListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
        
    }
}

extension ShopListTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadShopList()
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadShopList(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
