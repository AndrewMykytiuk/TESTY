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
    var isAllDataDownloaded = false
    var isPreloading = false
    
    let preloadLimit: Int = 20
    var pageNumber = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users"
        
        usersTableView.register(UINib(nibName: "PreloadingTableViewCell", bundle: nil), forCellReuseIdentifier: "PreloadingTableViewCell")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        NetworkManager.getUsers(preloadLimit, page: pageNumber, completion: {
            (dict, error) in
            
            if let err = error {
                print(err)
            }
            
            DispatchQueue.main.async {
                self.pageNumber += 1
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
    
    private func loadUsers(isUpdate: Bool = true) {
        
        if isPreloading || isAllDataDownloaded {
            return
        }
        
        isPreloading = true
        
        NetworkManager.getUsers(self.preloadLimit, page: self.pageNumber, completion: {
            (dict, error) in
            
            self.isPreloading = false
            self.pageNumber += 1
            if self.pageNumber >= 10 {
                self.isAllDataDownloaded = true
            }
            
            if let err = error {
                self.showHUD(progressLabel: err)
            }
            else {
                DispatchQueue.main.async {
                if isUpdate {
                    self.userDictionary = dict
                    self.names = self.userDictionary["names"] ?? []
                    self.images = self.userDictionary["images"] ?? []
                    self.phones = self.userDictionary["phones"] ?? []
                    self.emails = self.userDictionary["emails"] ?? []
                } else {
                    let dictNames = dict["names"] ?? []
                    let dictImages = dict["images"] ?? []
                    let dictPhones = dict["phones"] ?? []
                    let dictEmails = dict["emails"] ?? []
                    
                    self.names.append(contentsOf: dictNames)
                    self.images.append(contentsOf: dictImages)
                    self.phones.append(contentsOf: dictPhones)
                    self.emails.append(contentsOf: dictEmails)
                    
                    self.userDictionary["names"] = self.names
                    self.userDictionary["images"] = self.images
                    self.userDictionary["phones"] = self.phones
                    self.userDictionary["emails"] = self.emails
                }
                self.usersTableView.reloadData()
                }
            }
            
        })
      
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return isAllDataDownloaded ? 0 : 1
        }
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = DataManager.setupPreloadingCell(tableView, indexPath)
            return cell
        }
        
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
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DataManager.scrollViewPaginationSetup(scrollView) {
            self.loadUsers(isUpdate: false)
        }
    }

}

