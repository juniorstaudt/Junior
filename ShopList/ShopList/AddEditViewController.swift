//
//  AddEditViewController.swift
//  ShopList
//
//  Created by Junior Staudt on 05/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfProductDescription: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfDolarProductPrice: UITextField!
    @IBOutlet weak var swCreditCard: UISwitch!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btProductImageButton: UIButton!
    
    
    var product: Product!
    var stateManager = StateManager.shared
    var creditCard: Bool!
    var dolarTax: Double = Configuration.shared.dolar
    var iofTax: Double = Configuration.shared.iof
    
    lazy var pickerView: UIPickerView = {
       let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if product != nil {
            title = "Editar produto"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfProductDescription.text = product.productDescription
            if let state = product.purchasedState, let index = stateManager.states.firstIndex(of: state) {
                tfState.text = state.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivProduct.image = product.image as? UIImage
            tfDolarProductPrice.text = String(product.price)
            if product.image != nil {
                btProductImageButton.setTitle(nil, for: .normal)
            }
        }
        prepareStateForTextField()
    }
    
    func prepareStateForTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
                toolbar.items = [btCancel, btDone]
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }
    
    @objc func done() {
        tfState.text = stateManager.states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateManager.loadStates(with: context)
    }
    
    @IBAction func addState(_ sender: Any) {
    }
    
    @IBAction func addEditProduct(_ sender: Any) {
        if product == nil {
            product = Product(context: context)
        }

        
        
        
        
        product.productDescription = tfProductDescription.text
        product.price = Double(tfDolarProductPrice.text!)!
        product.creditCard = swCreditCard.isOn
        //product.dolarTaxValue = product.price * product.purchasedState!.taxRate
        product.dolarTotal = product.price + product.dolarTaxValue
        product.realTotal = product.iofValue + (product.dolarTotal * dolarTax)
        if swCreditCard.isOn == true {
            product.iofValue = (product.dolarTotal * dolarTax) * iofTax/100
        } else {
            product.iofValue = 0
        }
        product.image = ivProduct.image
        if creditCard == true {
            swCreditCard.isOn = true
        } else {
            swCreditCard.isOn = false
        }
        if tfState.text!.isEmpty {
            let state = stateManager.states[pickerView.selectedRow(inComponent: 0)]
            product.purchasedState = state
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func setCreditCard(_ sender: UISwitch) {
        if sender.isOn == true {
            creditCard = true
        } else {
            creditCard = false
        }
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: "Escolher foto do produto", message: "De onde deseja escolher?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
}
        
        func selectPicture(sourceType: UIImagePickerController.SourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.navigationBar.tintColor = UIColor(named: "second")
            present(imagePicker, animated: true, completion: nil)
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

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateManager.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = stateManager.states[row]
        return state.name
        }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivProduct.image = image
        btProductImageButton.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
