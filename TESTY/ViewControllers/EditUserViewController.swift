//
//  EditUserViewController.swift
//  TESTY
//
//  Created by User on 07/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SDWebImage
import MBProgressHUD

class EditUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var editUserTableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user:User?
    var infoDictionary:[String:Any] = [:]
    var editTF = false
    var typeOfImage = false
    var numberOfUser = 0
    var userEmail = ""
    
    private let firstNameRow = 0
    private let lastNameRow = 1
    private let emailRow = 2
    private let phoneRow = 3
    private let maxLength = 30
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit user profile"
        
        userEmail = infoDictionary["email"] as? String ?? " "
        
        if typeOfImage == false {
            if let img = infoDictionary["image"], let url = URL(string: img as! String) {
            userImageView.sd_setImage(with: url)
        }
        } else {
            let image = UIImage(data: infoDictionary["image"] as! Data)
            userImageView.image = image
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        view.endEditing(true)
        
        do {
            
            let data = UIImagePNGRepresentation(userImageView.image!)
            let user = User()
            user.image = data
            
            let firstName = IndexPath(row: firstNameRow, section: 0)
            let secondName = IndexPath(row: lastNameRow, section: 0)
            let firstNameCell = editUserTableView.cellForRow(at:firstName) as! EditUserTableViewCell
            let lastNameCell = editUserTableView.cellForRow(at:secondName) as! EditUserTableViewCell
            if firstNameCell.infoTextField.text != "" && lastNameCell.infoTextField.text != "" {
                if DataManager.isOnlySpecSymbols(in: firstNameCell.infoTextField) == false, DataManager.isOnlySpecSymbols(in: lastNameCell.infoTextField) == false {
                if DataManager.isOnlyLettersText(in: firstNameCell.infoTextField) == true,
                    DataManager.isOnlyLettersText(in: lastNameCell.infoTextField) == true {
                   user.name = firstNameCell.infoTextField.text!
                   user.name.append(" \(lastNameCell.infoTextField.text!)")
                } else {
                    self.showHUD(progressLabel: "Write only letters in names fields")
                    return
                }
            } else {
                self.showHUD(progressLabel: "Write letters in names fields")
                return
            }
            } else {
                self.showHUD(progressLabel: "Names info can't be empty")
                return
            }
            
            let email = IndexPath(row: emailRow, section: 0)
            let emailCell = editUserTableView.cellForRow(at:email) as! EditUserTableViewCell
            
            if emailCell.infoTextField.text != "" {
                if DataManager.isValidForEmail(emailCell.infoTextField) == true {
                    user.mail = emailCell.infoTextField.text!
                } else {
                    self.showHUD(progressLabel: "Write valid email")
                    return
                }
            } else {
                self.showHUD(progressLabel: "Email info can't be empty")
                return
            }
            
            let phone = IndexPath(row: phoneRow, section: 0)
            let phoneCell = editUserTableView.cellForRow(at:phone) as! EditUserTableViewCell
            
            if phoneCell.infoTextField.text != "" {
                if (phoneCell.infoTextField.text?.count)! > 6 {
                if DataManager.isOnlyNumsText(in: phoneCell.infoTextField) == true {
                    user.phone = phoneCell.infoTextField.text!
                } else {
                    self.showHUD(progressLabel:"Write correct phone number")
                    return
                }
            } else {
                self.showHUD(progressLabel: "Phone have at least 6 sumbols")
                return
            }
            } else {
                self.showHUD(progressLabel: "Phone info can't be empty")
                return
            }
        
            let realm = try Realm()
            if typeOfImage == false {
            try realm.write {
                realm.add(user)
            }
            } else {

                let updateUser = DataManager.getUserFromDB(mail: userEmail)
                try! realm.write {
                    updateUser?.image = data
                    updateUser?.name = user.name
                    updateUser?.mail = user.mail
                    updateUser?.phone = user.phone
                }
            }
    }
        catch let error as NSError{
            self.showHUD(progressLabel: error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePhotoButtonAction(_ sender: Any) {
        showActionSheet(vc: self)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserTableViewCell", for: indexPath) as! EditUserTableViewCell
        let name = infoDictionary["name"]
        
        let fullNameArr = (name as! String).components(separatedBy: " ")
        
        var firstName:String = ""
        var lastName:String = ""
        
        if fullNameArr.count > 2 {
            firstName = fullNameArr[0]
            for name in 1..<fullNameArr.count {
                lastName.append("\(name) ")
            }
            
        } else {
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
        }
        
        if indexPath.row == 0 {
        cell.label.text = "First name"
        cell.infoTextField.text = firstName
        cell.infoTextField.tag = indexPath.row
        } else if indexPath.row == 1 {
            cell.label.text = "Last name"
            cell.infoTextField.text = lastName
            cell.infoTextField.tag = indexPath.row
        } else if indexPath.row == 2 {
            cell.label.text = "Email"
            cell.infoTextField.text = infoDictionary["email"] as? String
            cell.infoTextField.tag = indexPath.row
        } else {
            cell.label.text = "Phone"
            cell.infoTextField.text = infoDictionary["phone"] as? String
            cell.infoTextField.tag = indexPath.row
        }
        cell.selectionStyle = .none
        
        return cell
        
    }
   
    //MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = image
        } else {print("Something went wrong")}
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if maxLength > 0 {
            let newLength = textField.text!.count + string.count - range.length
            return newLength <= maxLength
        }
        return true
    }
    
}

extension EditUserViewController {
    
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
        progressHUD.label.textColor = UIColor(red: 178, green: 34, blue: 34, alpha: 1.0)
        progressHUD.animationType = .zoomOut
        progressHUD.mode = .text
        progressHUD.hide(animated: true, afterDelay: 2.0)
        
    }
    
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
}
