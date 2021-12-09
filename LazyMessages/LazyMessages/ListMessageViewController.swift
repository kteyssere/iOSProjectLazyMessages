//
//  ListMessageViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier and Karina Teyssere on 01/12/2021.
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
    
    //Complete les lignes du tableau
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
    
    //Complete les info du viewController infoList
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infosVC = storyboard.instantiateViewController(withIdentifier: "InfosVC") as! InfosViewController
        
        let defaults = UserDefaults.standard
        let key = "SavedMessage" + String(indexPath.row)
        let savedMessageData = defaults.object(forKey: key)
        
        do {
            let savedMessage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedMessageData as! Data) as! Message
            
            infosVC.titre = savedMessage.titre
            infosVC.destinataire = savedMessage.destinataire
            infosVC.contenu = savedMessage.contenu
            infosVC.date = savedMessage.date

            
            
        } catch {
            
            print("Erreur !")
            
        }
        
        
        self.navigationController?.pushViewController(infosVC, animated: true)
        
    }
    
    //Supprime tout les messages de la liste
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "nbMessages")
        
        tableView.reloadData()
        
    }
    
    //Supprime le message selectionné de la liste
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if editingStyle == .delete {
        print("Deleted")

          
          let defaults = UserDefaults.standard
          let key = "SavedMessage" + String(indexPath.row)
        

            self.tableView.beginUpdates()
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let nbMessages = defaults.integer(forKey: "nbMessages")
            let newNbMessages = nbMessages - 1
            defaults.set(newNbMessages, forKey: "nbMessages")
            
            defaults.removeObject(forKey: key)
            self.tableView.endUpdates()
    
      }
    }
    
    
}
