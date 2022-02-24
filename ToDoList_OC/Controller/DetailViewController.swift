//
//  DetailViewController.swift
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/24.
//

import UIKit

@objc
class DetailViewController: UIViewController {
    
    @IBOutlet var taskNameTextField: UITextField!{
        didSet{
            taskNameTextField.isEnabled = false
        }
    }
    @IBOutlet var taskDescriptionTextView: UITextView!{
        didSet{
            taskDescriptionTextView.isEditable = false
        }
    }
    @IBOutlet var taskDateTextField: UITextField!{
        didSet{
            taskDateTextField.isEnabled = false
        }
    }
    @IBOutlet var remindSwitch: UISwitch!{
        didSet{
            remindSwitch.isEnabled = false
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var viewContext = appDelegate.persistentContainer.viewContext
    @objc var indexPath: IndexPath!;
    var isDone: Bool!
    var remind: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskData")
        fetchrequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        let controller = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchrequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try controller.performFetch()
        }catch{
            fatalError()
        }
        
        let taskData = controller.object(at: self.indexPath) as! TaskData
        
        self.taskNameTextField.text = taskData.name
        self.taskDescriptionTextView.text = taskData.taskDescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.string(from: taskData.time!)
        self.taskDateTextField.text = date

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask"{
//            let edit = segue.destination
        }
    }
    
    
}
