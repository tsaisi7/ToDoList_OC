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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetail"]){

        DetailViewController *detail = (DetailViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detail.indexPath = indexPath;
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
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

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.controller fetchedObjects]count];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        TaskData *taskData = [self.controller objectAtIndexPath:indexPath];
        [self.manageObjectContext deleteObject:taskData];
        NSError *error;
        [self.manageObjectContext save:&error];
        completionHandler(YES);
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = UIColor.systemRedColor;
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}
@end
