//
//  AllSocialsPageController.swift
//  Meetsy
//
//  Created by APPLE on 13/09/22.
//

import UIKit
import CoreData

class AllSocialsPageController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var socialsArray = [Social]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SocialMedias.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllSocialsCell") as! AllSocialsCell
        
        cell.logo.image = UIImage(named: SocialMedias.list[indexPath.row])
        cell.platformName = SocialMedias.list[indexPath.row]
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
                
    }
    
    @IBAction func addUsernames(_ sender: Any) {
        
        let cells = self.tableView.visibleCells as! [AllSocialsCell]
        
        var array:[[String]] = []
        for cell in cells {
            
            if(cell.usernameTF.text != ""){
                
                let newItem = Social(context: context)
                newItem.username = cell.usernameTF.text
                newItem.platform = cell.platformName
                array.append([newItem.platform as! String, newItem.username as! String])
                
                SocialMedias.addedSocials.append(newItem.platform!)
                
                let indexToRemove = SocialMedias.list.firstIndex(of: newItem.platform!)
                
                let removedItem = SocialMedias.list.remove(at: indexToRemove!)
                
                do{
                    try context.save()
                }
                catch{
                    
                }
                
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true)
        
        print(array)
        
        var request = URLRequest(url: URL(string: "https://meetsy-alpha.vercel.app/api/social/add?API_TOKEN=ZpzDou4zDidsLmqRv4hw6lkhjgWcO6zMOYvfqGg")!)
        // Configure POST Request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = HTTP.createCodableSocials(userId: UDM.shared.getUserId(), arr: array)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // Show error page
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            
            // check if status code == 201
            // stop loading screen and continue with app stuff
                
        }
        // Start task
        task.resume()
        
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
