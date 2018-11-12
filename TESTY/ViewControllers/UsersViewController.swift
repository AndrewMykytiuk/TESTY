//
//  UsersViewController.swift
//  TESTY
//
//  Created by User on 27/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var userDictionary:[String:[String]] = [:]
    var names:[String] = []
    var phones:[String] = []
    var images:[String] = []
    var emails:[String] = []
    
    let userCount: Int = 77
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let pageNumber = Int.random(in: 0 ... 10)
        
        NetworkManager.getUsers(userCount, page: pageNumber, completion: {
            (dict, error) in
            
            if let err = error {
                print(err)
            }
            
            DispatchQueue.main.async {
                self.userDictionary = dict
                MBProgressHUD.hide(for: self.view, animated: true)
                self.names = self.userDictionary["names"] ?? []
                self.images = self.userDictionary["images"] ?? []
                self.phones = self.userDictionary["phones"] ?? []
                self.emails = self.userDictionary["emails"] ?? []
                self.usersTableView.reloadData()
            }
            
            
        })
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(userDictionary.count)
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.titleLabel.text = names[indexPath.row]
        cell.subtitleLabel.text = phones[indexPath.row]
        cell.imagePhotoView.sd_setImage(with: URL(string: images[indexPath.row]))
        //cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditUserViewController") as! EditUserViewController
       
        vc.infoDictionary["name"] = names[indexPath.row]
        vc.infoDictionary["phone"] = phones[indexPath.row]
        vc.infoDictionary["image"] = images[indexPath.row]
        vc.infoDictionary["email"] = emails[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

