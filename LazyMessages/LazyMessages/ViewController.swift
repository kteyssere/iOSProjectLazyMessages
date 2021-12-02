//
//  ViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier on 18/11/2021.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let defaults = UserDefaults.standard
//        defaults.set(0, forKey: "nbMessages")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        if let idToSend = defaults.string(forKey: "SmsToSendFromNotif") {
            sendSms(idMessage: idToSend)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    func sendSms(idMessage: String) {
        
//        //TODO
//        // 1- Get id message
//        let idMessage = "SavedMessage1"
        
        // 2- Get Message from UserDefaults
        let defaults = UserDefaults.standard
        let key = idMessage
        let savedMessageData = defaults.object(forKey: key)
        
        do {
            let savedMessage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedMessageData as! Data) as! Message
            
            // 3- On envoie le message
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = savedMessage.contenu
                controller.recipients = [savedMessage.destinataire]
                
                print(controller)
                print(controller.body!)
                print(controller.recipients!)
                
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
                
            } else {
                print("Erreur d'envoi !")
            }
            
        } catch {
            print("Erreur !")
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print(result)
        
    }
    
}
