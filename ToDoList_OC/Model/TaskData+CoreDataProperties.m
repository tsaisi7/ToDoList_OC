//
//  TaskData+CoreDataProperties.m
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/26.
//
//

#import "TaskData+CoreDataProperties.h"

@implementation TaskData (CoreDataProperties)

+ (NSFetchRequest<TaskData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskData"];
}

@dynamic isDone;
@dynamic name;
@dynamic remind;
@dynamic taskDescription;
@dynamic time;
@dynamic id;

@end
