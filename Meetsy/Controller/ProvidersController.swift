//
//  ProvidersController.swift
//  Meetsy
//
//  Created by Shlok Desai on 16/08/22.
//

import UIKit
import GoogleSignIn

class ProvidersController: UIViewController {

    let signInConfig = GIDConfiguration(clientID: "833952923060-840jpk8civku5916djm1m3f859kuj71h.apps.googleusercontent.com", serverClientID: "833952923060-3i9nt0vc6hht95f403tksgqp7qt9606r.apps.googleusercontent.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //
    // Google Sign in
    //
    
    @IBAction func googleSignIn(sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let emailAddress = user.profile?.email as! String
            var tokenID : String!
            
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }

                let idToken = authentication.idToken
                tokenID = authentication.idToken
                UDM.shared.setUserId(userId: emailAddress)
                // Send ID token to backend.
            }
            
            
            
            
             let fullName = user.profile?.name
             print(fullName!)
            
            //Make request call
            //
            
            print(UDM.shared.getUserId())
            var request = URLRequest(url: URL(string: "https://meetsy-alpha.vercel.app/api/user/get?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg&userId=\(UDM.shared.getUserId())")!)
            // Configure POST Request
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // Show error page
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                
                
                if let httpResponse = response as? HTTPURLResponse {
                   print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200{
                        
                        //Take it to home screen existing, set UDM
                        //GET request for core data if user is already there
                        //Chaining request
                        
                        let url = URL(string: "https://meetsy-alpha.vercel.app/api/social/get?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg&userId=\(UDM.shared.getUserId())")!
                        
                        var socialsRequest = URLRequest(url: url)
                        
                        socialsRequest.httpMethod = "GET"
                        
                        socialsRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        let task2 = URLSession.shared.dataTask(with: socialsRequest) { data, response, error in
                            guard let data = data, error == nil else {
                                return
                            }
                            
                            print("started")
                            do{
                                let decodedData = try JSONDecoder().decode(SocialsObject.self, from: data)
                                
                                print(decodedData)
                            }catch{
                                
                                //Error
                                
                            }
                            
                        }
                       
                        task2.resume()
                        
                        
                        
                    } else if httpResponse.statusCode == 404{
                        //New user
                        
                        DispatchQueue.main.async {
                            let authStoryboard = UIStoryboard(name: "AuthStoryboard", bundle: nil)
                            let vc = authStoryboard.instantiateViewController(withIdentifier: "AuthController") as! AuthController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                        }
                       
                        
                        
                        
                        
                    }else{
                        //Error
                    }
                    
                    
                }
                
                
                print(data)
                
                
                // check if status code == 201
                // stop loading screen and continue with app stuff
                    
            }
            // Start task
            task.resume()


            // let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            
            
            // If sign in succeeded, display the app's main content View.
            //If token exists directly to app
            // TODO: Set UDMs in this if statement, following inside if statement
            
            
            
            
            
            //If token doesnt exist show Auth Controllers
            
            
        }
    }
    
    @IBAction func googleSignOut(sender: Any) {
      GIDSignIn.sharedInstance.signOut()
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
