//
//  TaskData+CoreDataProperties.m
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/24.
//
//

#import "TaskData+CoreDataProperties.h"

@implementation TaskData (CoreDataProperties)

+ (NSFetchRequest<TaskData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskData"];
}
@dynamic remind;
@dynamic isDone;
@dynamic name;
@dynamic taskDescription;
@dynamic time;

@end
