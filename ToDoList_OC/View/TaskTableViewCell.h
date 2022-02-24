//
//  TaskTableViewCell.h
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end

NS_ASSUME_NONNULL_END
