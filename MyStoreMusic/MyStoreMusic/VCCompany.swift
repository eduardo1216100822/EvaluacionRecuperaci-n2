//
//  VCCompany.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VCCompany: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refCompanys: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPopularity: UITextField!
    
    
    @IBOutlet weak var tblCompany: UITableView!
    
    var companysList = [CompanyModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companysList[indexPath.row]
        let alertController = UIAlertController(title: company.name, message: "Give new values to update company", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = company.id
            let name = alertController.textFields?[0].text
            let city = alertController.textFields?[1].text
            let popularity = alertController.textFields?[2].text
            
            self.updateCompany(id: id!,
                                   name: name!,
                                   city: city!,
                                   popularity: popularity!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteStocktaking(id: company.id!)
        }
        
        alertController.addTextField{(textField) in
            textField.text = company.name
        }
        alertController.addTextField{(textField) in
            textField.text = company.city
        }
        alertController.addTextField{(textField) in
            textField.text = company.popularity
        }
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func updateCompany(id: String, name: String, city: String, popularity: String){
        let stocktaking = [
            "id": id,
            "Name": name,
            "City": city,
            "Popularity": popularity
        ]
        refCompanys.child(id).setValue(stocktaking)
        
        clean()
    }
    
    func deleteStocktaking(id: String){
        refCompanys.child(id).setValue(nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companysList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompany", for: indexPath) as! TVCCompanys
        
        let companys: CompanyModel
        
        companys = companysList[indexPath.row]
        
        cell.lblName.text = companys.name
        cell.lblCity.text = companys.city
        cell.lblPopularity.text = companys.popularity
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refCompanys = Database.database().reference().child("companys")
        
        refCompanys.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0{
                self.companysList.removeAll()
                for companys in snapshot.children.allObjects as![DataSnapshot]{
                    let companysObject = companys.value as? [String: AnyObject]
                    let companyName = companysObject?["Name"]
                    let companyCity = companysObject?["City"]
                    let companyPopularity = companysObject?["Popularity"]
                    let companyId = companysObject?["id"]
                    
                    let warehouse = CompanyModel(id: companyId as! String?, name: companyName as! String?, city: companyCity as! String?, popularity: companyPopularity as! String?)
                    
                    self.companysList.append(warehouse)
                }
                self.tblCompany.reloadData()
            }
        })
    }
    
    func addCompany() {
        let key = refCompanys.childByAutoId().key
        let company = ["id":key,
                           "Name":txtName.text! as String,
                           "City":txtCity.text! as String,
                           "Popularity":txtPopularity.text! as String]
        refCompanys.child(key!).setValue(company)
        
        clean()
    }
    
    func clean(){
        txtName.text! = ""
        txtCity.text! = ""
        txtPopularity.text! = ""
    }
    
    @IBAction func btnAddCompany(_ sender: UIButton) {
        addCompany()
    }
    
    
}
