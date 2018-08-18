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

class ViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var input: UITextField!
    
    
    
    @IBAction func action(_ sender: UIButton)
    {
        output.text = "Hello, " + (input.text)!
        let text: String = (input.text)!   // find out the difference between let and var
        
        entitySearch(userQuery: text)
    }
    
    func entitySearch(userQuery: String)  // user input as argument
    {
        //Acquire an API key
        let subscriptionKey = "0a3d1b921926499a9f1ee8b34e071e24"
        
        
        let host = "https://api.cognitive.microsoft.com"
        let path = "/bing/v7.0/entities"
        
        let mkt = "en-Us"
        //var query = "barber shops near me" //query to request from bings entity search
        
        let query = "Barbershops In " + userQuery // testing a more specific query!
        
        //takes the query and 'encodes' it into a url compatible string
        let encodeQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //Append the encoded string to a string of parameters
        let params  = "?mkt=" + mkt + "&q=" + encodeQuery!
        
        //Set up the URL
        let url = URL(string: host+path+params)
    
        //Set up the HTTP Connection using Alamofire
        //
        //
        
        //Create custom header for authorization
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": subscriptionKey
        ]
        
        
        Alamofire.request(url!, method: .get, headers: headers).responseJSON
        {
            response in
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result

            if let json = response.result.value
            {
                /*Pull out places object and then value array*/
                print("JSON: \(json)") // serialized json response
                
                //Creating initial dictionary out of JSON object
                let bingEntObject:Dictionary = json as! Dictionary<String,Any>  // json key is always a string, value could be of any type
                let placesObject:Dictionary = bingEntObject["places"] as! Dictionary<String,Any> // keep deserializing the json keys
                let valueObject:NSArray = placesObject["value"] as! NSArray
                var value = valueObject[0]  // there are 5 results for Durham, I just selected the first one
                var barberObj:Dictionary = value as! Dictionary<String,Any>
                
                //Get Name
                let barberShop:String = barberObj["name"] as! String  // until we are left with a final json object, we select the string we want
                
                //Get location
                
                
                self.output.text = barberShop // display the first result to the user.
                
                
            }
            
            
//           if let data = response.data, let _ = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
            
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

