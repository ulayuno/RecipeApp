//
//  ViewController.swift
//  AppRecetas
//
//  Created by Uriel on 23/11/17.
//  Copyright © 2017 Uriel Layuno. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var tableJSON: UITableView!
    var arrayRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapping()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableJSON.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        This function performs the request in order to get the list of recipes
     */
    func doRequest() {
        if var title = textField.text {
            if title.contains(" ") {
                title = title.replacingOccurrences(of: " ", with: "+")
            }
            Alamofire.request("http://www.recipepuppy.com/api/?q=\(title)").responseJSON { (responseData) -> Void in
                if let value = responseData.result.value {
                    let jsonVar = JSON(value)
                    if let resData = jsonVar["results"].arrayObject {
                        self.arrayRes = resData as! [[String:AnyObject]]
                    }
                    if self.arrayRes.count > 0 {
                        self.tableJSON.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        var recipe = arrayRes[indexPath.row]
        cell.textLabel?.text = recipe["title"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRes.count
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    /**
     This function calls doRequest when the user enters characters in the textField
     
     - Parameter textField: textField where the user enters the chars
    */
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.doRequest()
    }
    
}

extension UIViewController {
    
    /**
        This function hides the keyboard when the user taps anywhere on the screen
    */
    func hideKeyboardWhenTapping() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}







