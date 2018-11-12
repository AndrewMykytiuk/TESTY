//
//  SavedViewController.swift
//  TESTY
//
//  Created by User on 27/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var savedUserTableView: UITableView!
    var men:Results<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Saved"
        
        let realm = try! Realm()
        
        men = realm.objects(User.self)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        savedUserTableView.reloadData()
    }


    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return men!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.titleLabel.text = men![indexPath.row].name
        cell.subtitleLabel.text = men![indexPath.row].phone
        let image = UIImage(data: men![indexPath.row].image!)
        cell.imagePhotoView.image = image
        //cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditUserViewController") as! EditUserViewController
        
        vc.infoDictionary["name"] = men![indexPath.row].name
        vc.infoDictionary["phone"] = men![indexPath.row].phone
        vc.infoDictionary["image"] = men![indexPath.row].image
        vc.infoDictionary["email"] = men![indexPath.row].mail
        
        vc.typeOfImage = true
        vc.numberOfUser = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(men![indexPath.row])
                    }
                
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }

}

