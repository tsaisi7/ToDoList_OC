//
//  EditViewController.h
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSManagedObjectContext *manageObjectContext;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSFetchedResultsController *controller;

@end

NS_ASSUME_NONNULL_END
