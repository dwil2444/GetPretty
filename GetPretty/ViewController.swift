//
//  ViewController.swift
//  GetPretty
//
//  Created by Dane Williamson on 5/26/18.
//  Copyright © 2018 zygium. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var tableView: UITableView!
    var cellContent: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = cellContent[indexPath.row]
        return cell
    }
    @IBOutlet weak var input: UITextField!

    @IBAction func action(_ sender: UIButton)
    {
        let text: String = (input.text)!
        entitySearch(userQuery: text)
        tableView.reloadData()
    }
    func entitySearch(userQuery: String)  // user input as argument
    {
        let subscriptionKey = "0a3d1b921926499a9f1ee8b34e071e24"
        let host = "https://api.cognitive.microsoft.com"
        let path = "/bing/v7.0/entities"
        let mkt = "en-Us"
        let query = "Barbershops In " + userQuery
        let encodeQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let params  = "?mkt=" + mkt + "&q=" + encodeQuery!
        let url = URL(string: host+path+params)
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": subscriptionKey
        ]
        Alamofire.request(url!, method: .get, headers: headers).responseJSON
        {
            response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            if let json = response.result.value
            {
                print("JSON: \(json)")
                let bingEntObject:Dictionary = json as! Dictionary<String,Any>
                let placesObject:Dictionary = bingEntObject["places"] as! Dictionary<String,Any>
                let valueObject:NSArray = placesObject["value"] as! NSArray
                for value in valueObject
                {
                    var barberObj:Dictionary = value as! Dictionary<String,Any>
                    let barberShop:String = barberObj["name"] as! String
                    self.cellContent.append(barberShop)
                }
            }
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

