//
//  CreateMessageViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier on 25/11/2021.
//

import UIKit

class CreateMessageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        let message = Message(titre: titreTextField.text!, destinataire: destinataireTextField.text!, contenu: contenuTextField.text!, date: dateDatePicker.date, recurrence: recurrenceTextfield.text!)
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: message, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            
            var key = "SavedMessage"
            let nbMessages = defaults.integer(forKey: "nbMessages")
            key += String(nbMessages)
            let newNbMessages = nbMessages + 1
            defaults.set(newNbMessages, forKey: "nbMessages")

            defaults.set(encodedData, forKey: key)
            
            /*let sms = MFMessageComposeViewController()
             sms.messageComposeDelegate = self
             
             sms.recipients = [destinataire: destinataireTextField.text!]
             sms.body = contenu: contenuTextField.text!
             
             self.presentViewController(sms, animated: true, completion: nil)*/
            
            
        } catch {
            
            print("Erreur !")
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "listVC")
        self.navigationController?.pushViewController(listVC, animated: true)
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
