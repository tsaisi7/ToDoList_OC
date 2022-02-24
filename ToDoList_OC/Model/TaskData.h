//
//  TaskData.h
//  ToDoList_OC
//
//  Created by Adam Liu on 2022/2/23.
//

#import <Foundation/Foundation.h>
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface TaskData : NSManagedObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *time;
@property (nonatomic) NSString *taskDescriptioin;
@property (nonatomic) BOOL isDone;

@end

NS_ASSUME_NONNULL_END
