//
//  DataManager.swift
//  TESTY
//
//  Created by User on 12/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift


class DataManager {
    
    //MARK: - Database
    
    class func getUserFromDB(mail: String)->User? {
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).first { $0.mail == mail}
            return user
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Validation
    
    class func isValidForEmail(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else {
            return false
        }
        let stricterFilterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with:text)
    }
    
    class func isWhitespacesExcists(in textField: UITextField)->Bool {
        return textField.text!.rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
    
    class func isNumsExcists(in textField: UITextField)->Bool {
        return textField.text!.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    class func isLettersExcists(in textField: UITextField)->Bool {
        return textField.text!.rangeOfCharacter(from: .letters) != nil
    }
    
    class func isOnlyNumsText(in textField: UITextField)->Bool {
        return !isLettersExcists(in: textField) && !isSpecSymbolsExcists(in: textField)
    }
    
    class func isOnlyLettersText(in textField: UITextField)->Bool {
        return !isNumsExcists(in: textField) && !isSpecSymbolsExcists(in: textField) && !isPunctuationSymbolsExcists(in: textField)
    }
    
    class func isSpecSymbolsExcists(in textField: UITextField)->Bool {
        return textField.text!.rangeOfCharacter(from: .symbols) != nil
    }
    
    class func isPunctuationSymbolsExcists(in textField: UITextField)->Bool {
        return textField.text!.rangeOfCharacter(from: .punctuationCharacters) != nil
    }
    
    class func isOnlySpecSymbols(in textFiled: UITextField)->Bool {
        let isValid = !isLettersExcists(in: textFiled) && !isNumsExcists(in: textFiled)
        return isValid
    }
    
    
}
