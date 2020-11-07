//
//  ViewController.swift
//  URLSessionPOST
//
//  Created by Mohamed on 11/7/20.
//  Copyright © 2020 Mohamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func login(){
        
        guard let title = textFieldTitle.text else {return}
        guard let email = textFieldEmail.text else {return}
        guard let phone = textFieldPhone.text else {return}
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        let parameters: [String: Any] = [
            "title": title,
            "email": email,
            "phone": phone
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = parameters.percentEncoded()
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else {return}
            guard let response = response as? HTTPURLResponse else {return}
            guard (200...299) ~= response.statusCode else {
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {return}
            
            print(jsonResponse)
            
        }.resume()
        
    }
    
    
    
    //MARK:- IBActions
    @IBAction func buttonPost(_ sender: UIButton) {
    
        login()
        print("POST")
    }
    
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
