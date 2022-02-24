//
//  AddTaskViewController.swift
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet var taskNameTextField: UITextField!;
    @IBOutlet var taskDescriptionTextView: UITextView!;
    @IBOutlet var taskDatePicker: UIDatePicker!;

    let app = UIApplication.shared.delegate as! AppDelegate
    lazy var viewContext = app.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveTask(_ sender: Any){
        
    }


}
