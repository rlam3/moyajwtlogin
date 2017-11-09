//
//  LanguageSelectFormViewController.swift
//  Midori
//
//  Created by Raymond Lam on 4/10/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Async
import Localize_Swift


class LanguageSelectFormViewController: FormViewController {
    
    var selectedLanguage:String!
    let languages = Localize.availableLanguages(true)
    var saveButton:UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureForm()
        configureSaveButton()
    }
    
//     Add an observer for LCLLanguageChangeNotification on viewWillAppear. This is posted whenever a language changes and allows the viewcontroller to make the necessary UI updated. Very useful for places in your app when a language change might happen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveLanguageSettings), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }

    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func configureSaveButton(){
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveLanguageSettings))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveLanguageSettings(sender:UIBarButtonItem){
        
        print("UpdateLanguageSettings")
        
        AuthManager.shared.userSetLanguage = selectedLanguage

//        Localize.setCurrentLanguage(selectedLanguage)
        
        Localize.resetCurrentLanguageToDefault()
        
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    func configure(){
        title = "Language"
    }
    
    func configureForm() -> Void {
        
        form +++
            SelectableSection<ListCheckRow<String>>(
                NSLocalizedString("What is your preferred language?", comment: "LanguageSelectFormVC"), selectionType: .singleSelection(enableDeselection: false))
        
        for option in languages {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                
                let displayName = Localize.displayNameForLanguage(option)

                listRow.title = displayName
                listRow.selectableValue = option
                
                // Provides check mark to proper cell
                if Localize.currentLanguage() == option{
                    listRow.value = option
                }else{
                    listRow.value = nil
                }
                
                
            }
        }
        
        
        
        
    }
    
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        
        // Re-enable save button
        saveButton.isEnabled = true

        print("OLD VALUE: \(String(describing: oldValue)) NEW VALUE: \(String(describing: newValue))")

        selectedLanguage = (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.selectableValue
        
    }
    
}
