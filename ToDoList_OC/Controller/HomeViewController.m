//
//  HomeViewController.m
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

#import "HomeViewController.h"
#import "TaskTableViewCell.h"
#import "TaskData.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.taskNameLabel.text = @"圖書館還書";
    cell.taskTimeLabel.text = @"2022-02-25";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}




@end
