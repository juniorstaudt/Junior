//
//  StateTableViewController.swift
//  ShopList
//
//  Created by Junior Staudt on 06/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

class StateTableViewController: UITableViewController {

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    var statesManager = StateManager.shared
    let config = Configuration.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    func formatView() {
        tfDolar.text = String(config.dolar)
        tfIOF.text = String(config.iof)
    }
    
    func loadStates() {
        statesManager.loadStates(with: context)
        tableView.reloadData()
    }
    
    @IBAction func addState(_ sender: Any) {
        showAlert(with: nil)
    }
    
    func showAlert(with state: State?) {
        let title = state == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + "estado da compra", message: nil, preferredStyle: .alert)
        
        // campo para informar o estado
        alert.addTextField { (textField) in
            textField.placeholder = "Informe o estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        //campo para informar o imposto
        alert.addTextField { (textField) in
            textField.placeholder = "Informe o imposto"
            if let taxRate = state?.taxRate {
                textField.text = String(taxRate)
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let state = state ?? State(context: self.context)
            let tax2 = alert.textFields?[1].text.flatMap(Double.init)
            state.name = alert.textFields?[0].text
            state.taxRate = tax2!
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesManager.states.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = statesManager.states[indexPath.row]
        showAlert(with: state)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            statesManager.deleteState(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let state = statesManager.states[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = String(state.taxRate)
        return cell
    }
}
