//
//  AppUtils.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

class AppUtils: NSObject {

    func getJSONFromDict(dict:[String:Any])->String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    func getJSONFromArray(dict:[[String:Any]])->String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    // Create a toast message view
    func createToast(message: String, parentView: UIView) {
        let toastLabel = UILabel()
        toastLabel.tag = 101010101
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Chalkboard SE Regular", size: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        parentView.addSubview(toastLabel)
        parentView.bringSubviewToFront(toastLabel)
        toastLabel.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -40).isActive = true
        toastLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseInOut, animations: {
                toastLabel.alpha = 0.0
           }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
           })
    }
    
    // Remove toast message view
    func removeCurrentToast(view: UIView){
        if let currentToastView = view.viewWithTag(101010101) {
            currentToastView.removeFromSuperview()
        }
    }
    
}
