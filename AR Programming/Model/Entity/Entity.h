//
//  Entity.h
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class Entity;
@protocol EntityDelegate
-(void)entity:(Entity*)entity addedComponent:(GKComponent*)component;
-(void)entity:(Entity*)entity removedComponent:(GKComponent*)component;
@end

@interface Entity : GKEntity
@property (nonatomic, weak) id <EntityDelegate> delegate;
@end
