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
    @IBOutlet var remindSwitch: UISwitch!;


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var viewContext = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskDatePicker.date = Date()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func alertMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveTask(_ sender: Any){
        guard let taskName = taskNameTextField.text, taskName != "",let taskDescription = taskDescriptionTextView.text, taskDescription != "" else {
            alertMessage(title: "提醒", message: "請輸入完整資料")
            return
        }
        let taskData = NSEntityDescription.insertNewObject(forEntityName: "TaskData", into: viewContext) as! TaskData
        
        taskData.name = taskName
        taskData.taskDescription = taskDescription
        taskData.time = taskDatePicker.date
        taskData.isDone = false
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                alertMessage(title: "提醒", message: "新增成功")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }


}
