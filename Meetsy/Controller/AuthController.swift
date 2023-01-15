//
//  AuthController.swift
//  Meetsy
//
//  Created by Shlok Desai on 15/08/22.
//

import UIKit

class AuthController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var meetsyLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameInputField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // init the name text field
        nameInputField.delegate = self
        nameInputField.keyboardType = UIKeyboardType.alphabet
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Setting the Y position for Leetsy logo
        if UIDevice.current.hasNotch {
            meetsyLogoConstraint.constant = 20
        } else {
            meetsyLogoConstraint.constant = 10
        }

    }
    
    //
    // Custom log in
    //
    
    @IBAction func login(_ sender: Any) {
        // first set name and link attributes
        guard let fullname = nameInputField.text else {
            // replace with alert
            return
        }
        
        if (fullname == "") {
            // replace with alert
            return
        }
        
        UDM.shared.setName(name: fullname)
        UDM.shared.setLoggedInStatus(status: true)
        
        var request = URLRequest(url: URL(string: "https://meetsy-alpha.vercel.app/api/user/add?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg")!)
        // Configure POST Request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = HTTP.createUserJson(name: fullname)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // Show error page
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201{
                    //stop loading screen
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                        
                        let profileStroyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = profileStroyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                    DispatchQueue.global(qos: .background).async {
                       
                     }
                    
                    
                    
                }
                print("error \(httpResponse.statusCode)")
            }
            // check if status code == 201
            // stop loading screen and continue with app stuff
                
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController")
        present(vc, animated: true)
        
        
        // Start task
        task.resume()
       
        // set loading screen
        

        
        

    }
    
    @IBAction func logout(_ sender: Any) {
        let profileStroyboard = UIStoryboard(name: "AuthStoryboard", bundle: nil)
        //Creating an instance of the viewcontroller to go to.
        let vc = profileStroyboard.instantiateViewController(withIdentifier: "AuthController") as! AuthController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        
        UDM.shared.setLoggedInStatus(status: false)
        
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
        dismiss(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
