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


@end
