//
//  MyIDCatagory.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 27..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "MyIDCatagory.h"

@implementation MyIDCatagory{
    NSString *myID;
}

static MyIDCatagory *_instance = nil;
+ (id)defaultCatalog
{
    
    if (nil == _instance) {
        _instance = [[MyIDCatagory alloc] init];
    }
    return _instance;
}

- (id) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)getMyid{
    return [NSString stringWithFormat:@"30"];
}

@end
