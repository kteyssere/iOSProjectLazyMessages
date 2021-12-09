//
//  ViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier and Karina Teyssere on 18/11/2021.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var createPage: UIButton!
    @IBOutlet weak var listPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.messageToSend(notification:)), name: Notification.Name("SmsToSendFromNotif"), object: nil)
		
//        let defaults = UserDefaults.standard
//        defaults.set(0, forKey: "nbMessages")
        
        createPage.layer.cornerRadius = 10
        listPage.layer.cornerRadius = 10
    }
    
	@objc func messageToSend(notification: Notification) {
		let defaults = UserDefaults.standard
		if let idToSend = defaults.string(forKey: "SmsToSendFromNotif") {
			sendSms(idMessage: idToSend)
		}
       
        
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
	
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    //Envoi du sms
    func sendSms(idMessage: String) {

        // 1- Get Message from UserDefaults
        let defaults = UserDefaults.standard
        let key = idMessage
        let savedMessageData = defaults.object(forKey: key)
        
        do {
            let savedMessage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedMessageData as! Data) as! Message
            
            // 2- On envoie le message
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = savedMessage.contenu
                controller.recipients = [savedMessage.destinataire]
                
                print(controller)
                print(controller.body!)
                print(controller.recipients!)
                
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
                
				defaults.removeObject(forKey: "SmsToSendFromNotif")
				
            } else {
                print("Erreur d'envoi !")
            }
            
        } catch {
            print("Erreur !")
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print(result)
        
        self.dismiss(animated: true)
        
    }
}
