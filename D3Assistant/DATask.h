//
//  DATask.h
//  D3Assistant
//
//  Created by Artem Shimanski on 11.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DATask;
@protocol DATaskDelegate<NSObject>
- (void) taskWillStart:(DATask*) task;
- (void) taskDidFinish:(DATask*) task;
- (void) task:(DATask*) task didChangeProgress:(float) progress;

@end

@interface DATask : NSOperation
@property (nonatomic, copy) void (^block)(DATask* task);
@property (nonatomic, copy) void (^completionHandler)(DATask* task);
@property (nonatomic, weak) id<DATaskDelegate> delegate;
@property (nonatomic, assign) float progress;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* identifier;
@end
