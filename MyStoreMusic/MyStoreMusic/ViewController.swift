//
//  ViewController.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refMp3s: DatabaseReference!
    
    @IBOutlet weak var txtSong: UITextField!
    @IBOutlet weak var txtArtist: UITextField!
    @IBOutlet weak var txtAlbum: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtRating: UITextField!
    
    @IBOutlet weak var tblMp3List: UITableView!
    
    var mp3sList = [Mp3ListModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mp3 = mp3sList[indexPath.row]
        let alertController = UIAlertController(title: mp3.song, message: "Give new values to update mp3", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = mp3.id
            let song = alertController.textFields?[0].text
            let artist = alertController.textFields?[1].text
            let album = alertController.textFields?[2].text
            let year = alertController.textFields?[3].text
            let rating = alertController.textFields?[4].text
            
            self.updateMp3(id: id!,
                                   song: song!,
                                   artist: artist!,
                                   album: album!,
                                   year: year!,
                                   rating: rating!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteStocktaking(id: mp3.id!)
        }
        
        alertController.addTextField{(textField) in
            textField.text = mp3.song
        }
        alertController.addTextField{(textField) in
            textField.text = mp3.artist
        }
        alertController.addTextField{(textField) in
            textField.text = mp3.album
        }
        alertController.addTextField{(textField) in
            textField.text = mp3.year
        }
        alertController.addTextField{(textField) in
            textField.text = mp3.rating
        }
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func updateMp3(id: String, song: String, artist: String, album: String, year: String, rating: String){
        let stocktaking = [
            "id": id,
            "Song": song,
            "Artist": artist,
            "Album": album,
            "Year": year,
            "Rating": rating
        ]
        refMp3s.child(id).setValue(stocktaking)
        
        clean()
    }
    
    func deleteStocktaking(id: String){
        refMp3s.child(id).setValue(nil)
        //tblStocktaking.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mp3sList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMp3List", for: indexPath) as! TVCMp3List
        
        let mp3: Mp3ListModel
        
        mp3 = mp3sList[indexPath.row]
        
        cell.lblSong.text = mp3.song
        cell.lblArtist.text = mp3.artist
        cell.lblAlbum.text = mp3.album
        cell.lblYear.text = mp3.year
        cell.lblRating.text = mp3.rating
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refMp3s = Database.database().reference().child("mp3List")
        
        refMp3s.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0{
                self.mp3sList.removeAll()
                for mp3s in snapshot.children.allObjects as![DataSnapshot]{
                    let mp3sObject = mp3s.value as? [String: AnyObject]
                    let mp3Song = mp3sObject?["Song"]
                    let mp3Artist = mp3sObject?["Artist"]
                    let mp3Album = mp3sObject?["Album"]
                    let mp3Year = mp3sObject?["Year"]
                    let mp3Rating = mp3sObject?["Rating"]
                    let mp3Id = mp3sObject?["id"]
                    
                    let stocktaking = Mp3ListModel(id: mp3Id as! String?, song: mp3Song as! String?, artist: mp3Artist as! String?, album: mp3Album as! String?, year: mp3Year as! String?, rating: mp3Rating as! String?)
                    
                    self.mp3sList.append(stocktaking)
                }
                self.tblMp3List.reloadData()
            }
        })
    }
    
    func addMp3() {
        let key = refMp3s.childByAutoId().key
        let mp3 = ["id":key,
                           "Song":txtSong.text! as String,
                           "Artist":txtArtist.text! as String,
                           "Album":txtAlbum.text! as String,
                           "Year":txtYear.text! as String,
                           "Rating":txtRating.text! as String]
        refMp3s.child(key!).setValue(mp3)
        
        clean()
    }
    
    func clean(){
        txtSong.text! = ""
        txtArtist.text! = ""
        txtAlbum.text! = ""
        txtYear.text! = ""
        txtRating.text! = ""
    }
    
    @IBAction func btnAddMp3(_ sender: UIButton) {
        addMp3()
    }
    
    
}

