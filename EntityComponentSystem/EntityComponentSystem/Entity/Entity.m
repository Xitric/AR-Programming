//
//  Entity.m
//  AR Programming
//  
//  Created by Kasper Schultz Davidsen on 24/02/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

#import "Entity.h"

@implementation Entity
@synthesize delegate;

-(void)addComponent:(GKComponent *)component {
    [super addComponent:component];
    [delegate entity:self addedComponent:component];
}

-(void)removeComponentForClass:(Class)componentClass {
    GKComponent *removedComponent;
    for (GKComponent *component in self.components) {
        if ([component isMemberOfClass:componentClass]) {
            removedComponent = component;
        }
    }
    
    [super removeComponentForClass:componentClass];
    [delegate entity:self removedComponent:removedComponent];
}

@end
