//
//  EditViewController.m
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/24.
//

#import "EditViewController.h"
#import "TaskData+CoreDataClass.h"
#import "TaskData+CoreDataProperties.h"

@interface EditViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    TaskData *taskData = [self.controller objectAtIndexPath:self.indexPath];
    self.taskNameTextField.text = taskData.name;
    self.taskDescriptionTextView.text = taskData.taskDescription;
    self.taskDatePicker.date = taskData.time;
    [self.remindSwitch setOn: taskData.remind];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

-(void)readData{
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.manageObjectContext = [[self.appDelegate persistentContainer]viewContext];
    self.fetchRequest = [[NSFetchRequest<TaskData *> alloc]initWithEntityName:@"TaskData"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    self.controller = [[NSFetchedResultsController<TaskData *> alloc]initWithFetchRequest:self.fetchRequest managedObjectContext:self.manageObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.controller.delegate = self;
    NSError *error;
    [self.controller performFetch: &error];
}

- (IBAction)editTask:(id)sender{
    if(self.taskNameTextField.text && ![self.taskNameTextField.text  isEqual: @""] && self.taskDescriptionTextView.text){
        TaskData *taskData = [self.controller objectAtIndexPath:self.indexPath];
        taskData.name = self.taskNameTextField.text;
        taskData.taskDescription = self.taskDescriptionTextView.text;
        taskData.time = self.taskDatePicker.date;
        taskData.remind = self.remindSwitch.isOn;
        NSError *error;
        [self.manageObjectContext save:&error];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"請輸入完整資料" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
