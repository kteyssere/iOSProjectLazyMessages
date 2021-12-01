//
//  InfosViewController.swift
//  LazyMessages
//
//  Created by Brandon Reynier on 01/12/2021.
//

import UIKit

class InfosViewController: UIViewController {

    var titre: String?
    var destinataire: String?
    var contenu: String?
    var date: Date?
    var recurrence: String?

    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var destinataireLabel: UILabel!
    @IBOutlet weak var contenuLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recurrenceLabel: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titreLabel.text = titre
        destinataireLabel.text = destinataire
        contenuLabel.text = contenu
//        dateLabel.text = date
        recurrenceLabel.text = recurrence
    }
}
