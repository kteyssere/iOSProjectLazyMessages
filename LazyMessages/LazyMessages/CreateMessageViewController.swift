//
//  CreateMessageViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier on 25/11/2021.
//

import UIKit
import MessageUI

class CreateMessageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var titreTextField: UITextField!
    @IBOutlet weak var destinataireTextField:UITextField!
    @IBOutlet weak var contenuTextField:UITextField!
    @IBOutlet weak var dateDatePicker:UIDatePicker!
    @IBOutlet weak var recurrenceTextfield: UITextField!
    
    var pickerData: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Aucune", "Quotidien", "Hebdomadaire", "Mensuel", "Annuel"]
        let thePicker = UIPickerView()
        recurrenceTextfield.inputView = thePicker
        thePicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = pickerData[row]
        recurrenceTextfield.text = valueSelected
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print(result)
        
    }
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        let message = Message(titre: titreTextField.text!, destinataire: destinataireTextField.text!, contenu: contenuTextField.text!, date: dateDatePicker.date, recurrence: recurrenceTextfield.text!)
        if message.titre != "" && message.destinataire != "" && message.contenu != "" && message.date != nil && message.recurrence != ""  {
            
        
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: message, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            
            var key = "SavedMessage"
            let nbMessages = defaults.integer(forKey: "nbMessages")
            key += String(nbMessages)
            let newNbMessages = nbMessages + 1
            defaults.set(newNbMessages, forKey: "nbMessages")

            defaults.set(encodedData, forKey: key)
            
            self.savedSms(message: message, idMessage: key)
            
        } catch {
            
            print("Erreur !")
            
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "listVC")
        self.navigationController?.pushViewController(listVC, animated: true)
        
        } else {
            
            print("Veuillez completer les champs !")
            
        }
    }
    
    func savedSms(message: Message, idMessage: String) {
                
        let manager = LocalNotificationManager()
        
        let date = message.date
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
        
        let myNotif = LocalNotificationManager.Notification(id: idMessage, title: "Le message "+titreTextField.text!+" est en attente d'envoi", datetime: comps)
        
        manager.notifications = [myNotif]

        manager.schedule()
    }
}

class Message: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(titre, forKey: "titre")
        coder.encode(destinataire, forKey: "destinataire")
        coder.encode(contenu, forKey: "contenu")
        coder.encode(date, forKey: "date")
        coder.encode(recurrence, forKey: "recurrence")
    }
    
    required init?(coder: NSCoder) {
        titre = coder.decodeObject(forKey: "titre") as? String
        destinataire = coder.decodeObject(forKey: "destinataire") as? String
        contenu = coder.decodeObject(forKey: "contenu") as? String
        date = coder.decodeObject(forKey: "date") as? Date
        recurrence = coder.decodeObject(forKey: "recurrence") as? String
    }
    
    var titre: String!
    var destinataire: String!
    var contenu: String!
    var date: Date!
    var recurrence: String!
    
    init(titre: String, destinataire: String, contenu: String, date: Date, recurrence: String) {
        self.titre = titre
        self.destinataire = destinataire
        self.contenu = contenu
        self.date = date
        self.recurrence = recurrence
    }
}

class LocalNotificationManager
{
    var notifications = [Notification]()
    
    struct Notification {
        var id: String
        var title: String
        var datetime: DateComponents
    }
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}
