//
//  editUsernameController.swift
//  LINK
//
//  Created by APPLE on 19/07/22.
//

import UIKit

class EditUsernameController: UIViewController{

    private var arrayOfCells: [EditUsernameTableCell] = []
    
    
    @IBOutlet weak var SocialMedialogo : UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var platformName : UILabel!
    
    var currentUsername: String!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var SocialsDataSource : [Social]!
    var index: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        
        platformName.text = SocialsDataSource[index].platform
        SocialMedialogo.image = UIImage(named: SocialsDataSource[index].platform as! String)
        usernameTF.text = currentUsername
        
        //platformName.text = platformNameTemp
        
        //SocialMedialogo.image = socialMediaLogoTemp
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "DidAddUsernames")
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func saveUsernames(_ sender: Any) {
        
        //TODO: Save usernames
        
        //Checks if any Textfield is non-empty and changes DidAddUsernames value to true
        
//        for i in 0..<arrayOfCells.count {
//            if arrayOfCells[i].username.hasText == true{
//                UserDefaults.standard.set(true, forKey: "DidAddUsernames")
//            } else{
//                continue
//            }
//        }
        SocialsDataSource[index].username = usernameTF.text
        print(SocialsDataSource[index].platform as! String)
        do{
            try context.save()
        }
        catch{
            
        }
 
            //Posts a notification to call Collection View reload data upon dismissing screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        var request = URLRequest(url: URL(string: "https://meetsy-alpha.vercel.app/api/social/update?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg")!)
        // Configure POST Request
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = HTTP.updateCodableSocials(userId: "yaj456", username: SocialsDataSource[index].username as! String, platform: SocialsDataSource[index].platform as! String)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // Show error page
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
            }
            print(data)
            
            
            // check if status code == 201
            // stop loading screen and continue with app stuff
                
        }
        // Start task
        task.resume()

        
        dismiss(animated: true)
    }
    @IBAction func removeSocial(_ sender: Any) {
        
        var request = URLRequest(url: URL(string: "https://meetsy-alpha.vercel.app/api/social/delete?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg")!)
        // Configure POST Request
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = HTTP.deleteCodableSocials(userId: UDM.shared.getUserId(), platform: SocialsDataSource[index].platform!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // Show error page
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 204{
                    //WORKS
                }
                
            }
            
            // check if status code == 201
            // stop loading screen and continue with app stuff
                
        }
        // Start task
        task.resume()
        
        context.delete(SocialsDataSource[index])
        
        SocialMedias.list.append(SocialsDataSource[index].platform!)
        
        let indexToRemove = SocialMedias.addedSocials.firstIndex(of: SocialsDataSource[index].platform!)
        
        let removedItem = SocialMedias.addedSocials.remove(at: indexToRemove!)
        
        do{
            try context.save()
            dismiss(animated: true)
        }catch{
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true)

    }
    
}

