//
//  HomeViewController.m
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

#import "HomeViewController.h"
#import "TaskTableViewCell.h"
#import "TaskData+CoreDataClass.h"
#import "TaskData+CoreDataProperties.h"
#import "ToDoList_OC-Swift.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self readData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.controller.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)readData{
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.manageObjectContext = [[self.appDelegate persistentContainer]viewContext];
    self.fetchRequest = [[NSFetchRequest<TaskData *> alloc]initWithEntityName:@"TaskData"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    self.controller = [[NSFetchedResultsController<TaskData *> alloc]initWithFetchRequest:self.fetchRequest managedObjectContext:self.manageObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    [self.controller performFetch: &error];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetail"]){

        DetailViewController *detail = (DetailViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detail.indexPath = indexPath;
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController<TaskData *> *)controller{
    NSLog(@"%lu",(unsigned long)[[self.controller fetchedObjects]count]);
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TaskData *taskData = [self.controller objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [dateFormatter stringFromDate:taskData.time];
    cell.taskNameLabel.text = taskData.name;
    cell.taskTimeLabel.text = time;
    if (taskData.isDone){
        [cell.doneButton setImage:[UIImage systemImageNamed:@"app.badge.checkmark.fill"] forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.controller fetchedObjects]count];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskData *taskData = [self.controller objectAtIndexPath:indexPath];
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.manageObjectContext deleteObject:taskData];
        NSError *error;
        [self.manageObjectContext save:&error];
        completionHandler(YES);
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = UIColor.systemRedColor;
    
    UIContextualAction *doneAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        taskData.isDone = YES;
        NSError *error;
        [self.manageObjectContext save:&error];
        completionHandler(YES);
    }];
    doneAction.image = [UIImage systemImageNamed:@"app.badge.checkmark.fill"];
    doneAction.backgroundColor = UIColor.systemGreenColor;
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,doneAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}
@end
