//
//  VCStore.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VCStore: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refStores: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtTotalSales: UITextField!
    @IBOutlet weak var txtPopularity: UITextField!
    
    @IBOutlet weak var tblStore: UITableView!
    
    var storesList = [StoreModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = storesList[indexPath.row]
        let alertController = UIAlertController(title: store.name, message: "Give new values to update store", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = store.id
            let name = alertController.textFields?[0].text
            let city = alertController.textFields?[1].text
            let totalSales = alertController.textFields?[2].text
            let popularity = alertController.textFields?[3].text
            
            self.updateAction(id: id!,
                                   name: name!,
                                   city: city!,
                                   totalSales: totalSales!,
                                   popularity: popularity!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteStore(id: store.id!)
        }
        
        alertController.addTextField{(textField) in
            textField.text = store.name
        }
        alertController.addTextField{(textField) in
            textField.text = store.city
        }
        alertController.addTextField{(textField) in
            textField.text = store.totalSales
        }
        alertController.addTextField{(textField) in
            textField.text = store.popularity
        }
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func updateAction(id: String, name: String, city: String, totalSales: String, popularity: String){
        let store = [
            "id": id,
            "Name": name,
            "City": city,
            "TotalSales": totalSales,
            "Popularity": popularity
        ]
        refStores.child(id).setValue(store)
        
        clean()
    }
    
    func deleteStore(id: String){
        refStores.child(id).setValue(nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellStore", for: indexPath) as! TVCStores
        
        let store: StoreModel
        
        store = storesList[indexPath.row]
        
        cell.lblName.text = store.name
        cell.lblCity.text = store.city
        cell.lblTotalSales.text = store.totalSales
        cell.lblPopularity.text = store.popularity
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refStores = Database.database().reference().child("stores")
        
        refStores.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0{
                self.storesList.removeAll()
                for stores in snapshot.children.allObjects as![DataSnapshot]{
                    let storesObject = stores.value as? [String: AnyObject]
                    let storeName = storesObject?["Name"]
                    let storeCity = storesObject?["City"]
                    let storeTotalSales = storesObject?["TotalSales"]
                    let storePopularity = storesObject?["Popularity"]
                    let storeId = storesObject?["id"]
                    
                    let branchOffice = StoreModel(id: storeId as! String?, name: storeName as! String?, city: storeCity as! String?, totalSales: storeTotalSales as! String?, popularity: storePopularity as! String?)
                    
                    self.storesList.append(branchOffice)
                }
                self.tblStore.reloadData()
            }
        })
    }
    
    func addMp3() {
        let key = refStores.childByAutoId().key
        let mp3 = ["id":key,
                            "Name":txtName.text! as String,
                            "City":txtCity.text! as String,
                            "TotalSales":txtTotalSales.text! as String,
                            "Popularity":txtPopularity.text! as String]
        refStores.child(key!).setValue(mp3)
        
        clean()
    }
    
    func clean(){
        txtName.text! = ""
        txtCity.text! = ""
        txtTotalSales.text! = ""
        txtPopularity.text! = ""
    }
    
    @IBAction func btnAddMp3(_ sender: UIButton) {
        addMp3()
    }
    
}
