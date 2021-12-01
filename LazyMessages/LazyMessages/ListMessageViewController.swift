//
//  ListMessageViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier on 01/12/2021.
//

import UIKit

class ListMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    var hierarchicalData = [[String]]()
     
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let defaults = UserDefaults.standard
        let nbMessages = defaults.integer(forKey: "nbMessages")
        return nbMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaults = UserDefaults.standard
        let key = "SavedMessage" + String(indexPath.row)
        let savedMessageData = defaults.object(forKey: key)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        
        do {
            let savedMessage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedMessageData as! Data) as! Message
            
            cell.titleLabel.text = savedMessage.titre
            cell.subtitleLabel.text = savedMessage.destinataire
            
            
        } catch {
            
            print("Erreur !")
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infosVC = storyboard.instantiateViewController(withIdentifier: "InfosVC") as! InfosViewController
        
        let defaults = UserDefaults.standard
        let key = "SavedMessage" + String(indexPath.row)
        let savedMessageData = defaults.object(forKey: key)
        
        do {
            let savedMessage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedMessageData as! Data) as! Message
            
            infosVC.titre = savedMessage.titre
            infosVC.destinataire = savedMessage.titre
            infosVC.contenu = savedMessage.contenu
            infosVC.date = savedMessage.date
            infosVC.recurrence = savedMessage.recurrence

            
            
        } catch {
            
            print("Erreur !")
            
        }
        
        
        self.navigationController?.pushViewController(infosVC, animated: true)
        
    }
}
