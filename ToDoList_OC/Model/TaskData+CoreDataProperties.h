//
//  TaskData+CoreDataProperties.h
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/24.
//
//

#import "TaskData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskData (CoreDataProperties)

+ (NSFetchRequest<TaskData *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) BOOL isDone;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *taskDescription;
@property (nullable, nonatomic, copy) NSDate *time;

@end

NS_ASSUME_NONNULL_END
