//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mostafijur Rahaman on 1/3/17.
//  Copyright © 2017 Mostafijur Rahaman. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        /*let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
         
        store2.name = "Walmart"

        let store3 = Store(context: context)
        store3.name = "Apple"

        let store4 = Store(context: context)
        store4.name = "Amazon"

        let store5 = Store(context: context)
        store5.name = "Google Store"
        
        ad.saveContext()*/
        
        getStores()
        
        if itemToEdit != nil{
            loadItemData()
        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Updated when selected
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            //Handle the error
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        
        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text{
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImg(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    if stores[index].name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while index < stores.count
            }
        }
    }
    
}
