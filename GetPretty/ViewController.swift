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



class ViewController: UIViewController
{
    
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var input: UITextField!
    
    @IBAction func action(_ sender: UIButton)
    {
        output.text = "Hello, " + (input.text)!
        let text: String = (input.text)!   // find out the difference between let and var
        entitySearch(userQuery: text)
    }
    
    func entitySearch(userQuery: String)
    {
        //Acquire an API key
        let subscriptionKey = "2e5287c6606e4f348d52340d1f52d1de"
        
        let host = "https://api.cognitive.microsoft.com"
        let path = "/bing/v7.0/entities"
        
        let mkt = "en-Us"
        //var query = "barber shops near me" //query to request from bings entity search
        
        //Figure out how out how to URL encode the query string
        //For now hard code encoding the query by replacing spaces with +'s
        var encodedQuery = "Barbershops+In+" + userQuery // testing a more specific query!
        
        //Append the encoded string to a string of parameters
        let params  = "?mkt=" + mkt + "&q=" + encodedQuery
        
        //Set up the URL
        let url = URL(string: host+path+params)
        
        
        //Set up the HTTP Connection using Alamofire NOT COMPLETE, ATTACH THE API KEY
        
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
                let bingEntObject:Dictionary = json as! Dictionary<String,Any>  // json key is always a string, value could be of any type
                let placesObject:Dictionary = bingEntObject["places"] as! Dictionary<String,Any>
                let valueObject:Dictionary = placesObject["value"] as! Dictionary<String,Any>
                let value:String = valueObject["name"] as! String
                print (value)
            }
            if let data = response.data, let _ = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
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
}

