//
//  Toast.swift
//  TESTY
//
//  Created by User on 04/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit
import JAMSVGImage


//var toastView = UIView()
//let imageView = UIImageView()


extension UIViewController {
    
    
    enum CloseType {
        case Pop, Dissmiss
    }
    
    
    func showToast(with text: String?, toastType: ToastType) {
        let toastView = UIView()
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 90, height: 1))
        let toastImage = toastType.image
        toastLabel.font = UIFont(name: "NotoSans-Bold", size: 13)
        toastLabel.text = text
        toastLabel.textColor = .white
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.sizeToFit()
        
        let imageView = UIImageView(image: toastImage)
        imageView.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        imageView.clipsToBounds = true
        toastView.addSubview(imageView)
        
        toastLabel.center = CGPoint(x: imageView.frame.maxX + toastLabel.bounds.width / 2 + 15, y: imageView.center.y)
        toastView.addSubview(toastLabel)
        
        toastView.frame = CGRect(x: 0, y: self.view.frame.maxY + imageView.bounds.size.height + 30, width: toastLabel.frame.maxX + 15, height: toastLabel.frame.maxY + 15 > imageView.frame.maxY + 15 ? toastLabel.frame.maxY + 30 : imageView.frame.maxY + 15)
        toastView.center = CGPoint(x: self.view.bounds.width / 2, y: UIScreen.main.bounds.height + toastView.bounds.size.height / 2)
        toastView.layer.cornerRadius = toastView.bounds.height / 2
        toastLabel.center.y = toastView.bounds.height / 2
        imageView.center.y = toastView.bounds.height / 2
        let viewController = UIApplication.shared.keyWindow!.rootViewController!
        viewController.view.addSubview(toastView)
        toastView.backgroundColor = toastType.color
        
        UIView.animate(withDuration: 0.3) {
            toastView.center.y = UIScreen.main.bounds.height - toastView.bounds.height * 1.5
        }
        self.fallToastView(toastView: toastView, imageView: imageView)
    }
    
    func showToastInSelfController(with text: String?, toastType: ToastType, viewController: UIViewController) {
        let toastView = UIView()
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 90, height: 1))
        let toastImage = toastType.image
        toastLabel.font = UIFont(name: "NotoSans-Bold", size: 13)
        toastLabel.text = text
        toastLabel.textColor = .white
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.sizeToFit()
        
        let imageView = UIImageView(image: toastImage)
        imageView.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        imageView.clipsToBounds = true
        toastView.addSubview(imageView)
        
        toastLabel.center = CGPoint(x: imageView.frame.maxX + toastLabel.bounds.width / 2 + 15, y: imageView.center.y)
        toastView.addSubview(toastLabel)
        
        toastView.frame = CGRect(x: 0, y: self.view.frame.maxY + imageView.bounds.size.height + 30, width: toastLabel.frame.maxX + 15, height: toastLabel.frame.maxY + 15 > imageView.frame.maxY + 15 ? toastLabel.frame.maxY + 30 : imageView.frame.maxY + 15)
        toastView.center = CGPoint(x: self.view.bounds.width / 2, y: UIScreen.main.bounds.height + toastView.bounds.size.height / 2)
        toastView.layer.cornerRadius = toastView.bounds.height / 2
        toastLabel.center.y = toastView.bounds.height / 2
        imageView.center.y = toastView.bounds.height / 2
        viewController.view.addSubview(toastView)
        toastView.backgroundColor = toastType.color
        
        UIView.animate(withDuration: 0.3) {
            toastView.center.y = viewController.view.bounds.maxY - toastView.bounds.height * 1.5
        }
        self.fallToastView(toastView: toastView, imageView: imageView)
    }
    
    func presentAsPopup(_ vc: UIViewController, _ animated: Bool, completion: (()->Void)?) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: animated, completion: completion)
    }
    
    func showToast(with text: String?, toastType: ToastType, textSize: CGFloat?) {
        let toastView = UIView()
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 90, height: 1))
        let toastImage = toastType.image
        toastLabel.font = UIFont(name: "NotoSans-Bold", size: textSize == nil ? 13 : textSize!)
        toastLabel.text = text
        toastLabel.textColor = .white
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.sizeToFit()
        
        let imageView = UIImageView(image: toastImage)
        imageView.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        imageView.clipsToBounds = true
        toastView.addSubview(imageView)
        
        toastLabel.center = CGPoint(x: imageView.frame.maxX + toastLabel.bounds.width / 2 + 15, y: imageView.center.y)
        toastView.addSubview(toastLabel)
        
        toastView.frame = CGRect(x: 0, y: self.view.frame.maxY + imageView.bounds.size.height + 30, width: toastLabel.frame.maxX + 15, height: toastLabel.frame.maxY + 15 > imageView.frame.maxY + 15 ? toastLabel.frame.maxY + 30 : imageView.frame.maxY + 15)
        toastView.center = CGPoint(x: self.view.bounds.width / 2, y: UIScreen.main.bounds.height + toastView.bounds.size.height / 2)
        toastView.layer.cornerRadius = toastView.bounds.height / 2
        toastLabel.center.y = toastView.bounds.height / 2
        imageView.center.y = toastView.bounds.height / 2
        let viewController = UIApplication.shared.keyWindow!.rootViewController!
        viewController.view.addSubview(toastView)
        toastView.backgroundColor = toastType.color
        
        UIView.animate(withDuration: 0.3) {
            toastView.center.y = UIScreen.main.bounds.height - toastView.bounds.height * 1.5
        }
        self.fallToastView(toastView: toastView, imageView: imageView)
    }
    
   
}

extension UIViewController {
    
    enum ToastType {
        case Info, Attention
        
        var image: UIImage {
            
            switch self {
            case .Info:
                return UIImage(named: "info")!
            case .Attention:
                return UIImage(named: "done")!
            }
            
        }
        
        var color: UIColor {
            switch self {
            case .Info:
                return UIColor.infoToastColor
            case .Attention:
                return UIColor.attentionToastColor
            }
        }
    }
}
