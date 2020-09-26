//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 26/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var switchAutoPlay: UISwitch!
    @IBOutlet weak var segmentedControlColors: UISegmentedControl!
    @IBOutlet weak var textFieldCategory: UITextField!
    
    private let ud = UserDefaults.standard
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
       }
    
    @IBAction func autoPlayChanged(_ sender: UISwitch) {
        ud.set(sender.isOn, forKey: "autoplay")
    }
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        ud.set(sender.selectedSegmentIndex, forKey: "color")
    }
    
    @IBAction func categoryChanged(_ sender: UITextField) {
        ud.set(sender.text!, forKey: "category")
        sender.resignFirstResponder()
    }
    
    private func setupView(){
        let autoplay = ud.bool(forKey: "autoplay")
        switchAutoPlay.isOn = autoplay
        
        let colorIndex = ud.integer(forKey: "color")
        segmentedControlColors.selectedSegmentIndex = colorIndex
        
        let category = ud.string(forKey: "category")
        textFieldCategory.text = category;
    }
}
