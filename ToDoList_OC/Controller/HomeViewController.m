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
@import UserNotifications;

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

- (void)registerNotification:(TaskData*)taskData{
    NSLog(@"===%@",taskData.id);
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"提醒" arguments:nil];
    content.subtitle = [NSString localizedUserNotificationStringForKey:taskData.name arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:taskData.taskDescription arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSCalendarUnitYear+NSCalendarUnitDay+NSCalendarUnitHour + NSCalendarUnitMinute fromDate:taskData.time];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier: [NSString stringWithFormat:@"%@",taskData.id] content:content trigger:trigger];
    
    NSLog(@"TEST0:%d",taskData.remind);
    if (taskData.remind == YES){
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"TEST1:%d",taskData.remind);
        }];
    }else{
        [center removePendingNotificationRequestsWithIdentifiers:@[[NSString stringWithFormat:@"%@",taskData.id]]];
        NSLog(@"TEST2:%d",taskData.remind);
    }
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"TEST3:%@",notifications);
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetail"]){
        DetailViewController *detail = (DetailViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detail.indexPath = indexPath;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController<TaskData *> *)controller{
    [self.tableView reloadData];
    for (TaskData *taskData in self.controller.fetchedObjects){
        [self registerNotification:taskData];
    }
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
    }else{
        [cell.doneButton setImage:[UIImage systemImageNamed:@"square.dashed"] forState:UIControlStateNormal];
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
        taskData.remind = NO;
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
