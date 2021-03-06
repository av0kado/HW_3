//
//  TaskManager.m
//  TaskManager
//
//  Created by Alexander on 23.12.13.
//  Copyright (c) 2013 Alexander. All rights reserved.
//

#import "TaskManager.h"

@interface TaskManager()
{
    NSMutableArray* _tasks;
}
@end

@implementation TaskManager

+ (instancetype)sharedInstance
{
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[TaskManager alloc] init];
    });
    return _singleton;
}

- (id)init
{
    self = [super init];
    if(self){
        [self loadTasks];
    }
    return self;
}

#pragma mark - Store/load
- (void)loadTasks
{
    NSArray* arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Tasks"];
    _tasks = [NSMutableArray new];
    for(NSData* taskData in arr){
        Task* task = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
        [_tasks addObject:task];
    }
}

- (void)saveTasks
{
    NSMutableArray* tasksDataArr = [NSMutableArray new];
    for(Task* task in self.tasks){
        NSData* taskData = [NSKeyedArchiver archivedDataWithRootObject:task];
        [tasksDataArr addObject:taskData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tasksDataArr forKey:@"Tasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Task *)getTaskAtIndex:(int)index
{
    return _tasks[index];
}

#pragma mark - Operations
- (void)addTask:(Task *)task
{
    [_tasks addObject:task];
    [self saveTasks];
}

- (void)deleteTask:(Task *)task
{
    [_tasks removeObject:task];
    [self saveTasks];
}

- (void)taskChanged:(Task*)task
{
    [self saveTasks];
}
@end
