//
//  ViewController.swift
//  Json post
//
//  Created by Swapnil Kadam on 23/06/20.
//  Copyright © 2020 Swapnil Kadam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txt_UserId: UITextField!
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_body: UITextField!
    
    @IBAction func btn_postData(_ sender: UIButton)
    {
        
        self.setupPostMethod()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
    
    extension ViewController{
        func setupPostMethod(){
            guard let uid = self.txt_UserId.text else { return }
            guard let title = self.txt_title.text else { return }
            guard let body = self.txt_body.text else { return }
            
            if let url = URL(string: "https://jsonplaceholder.typicode.com/posts/"){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                //   request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
                let parameters: [String : Any] = [
                    "userId": uid,
                    "title": title,
                    "body": body
                ]
                
                request.httpBody = parameters.percentEscaped().data(using: .utf8)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data else {
                        if error == nil{
                            print(error?.localizedDescription ?? "Unknown Error")
                        }
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse{
                        guard (200 ... 299) ~= response.statusCode else {
                            print("Status code :- \(response.statusCode)")
                            print(response)
                            return
                        }
                    }
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    }.resume()
            }
        }
    }
    

    
    extension Dictionary {
        func percentEscaped() -> String {
            return map { (key, value) in
                let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return escapedKey + "=" + escapedValue
                }
                .joined(separator: "&")
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

