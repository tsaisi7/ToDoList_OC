//
//  HomeViewController.h
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class DetailViewController;

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSManagedObjectContext *manageObjectContext;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSFetchedResultsController *controller;

@end

NS_ASSUME_NONNULL_END
