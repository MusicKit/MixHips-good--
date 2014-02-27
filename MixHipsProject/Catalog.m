//
//  Catalog.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "Catalog.h"
#import "AlbumList.h"
#import "RequestCenter.h"

@implementation Catalog
{
    NSArray *albumList;
    NSMutableArray *soundlist;
}

// 싱글톤 메소드
static Catalog *_instance = nil;

+ (id)defaultCatalog
{
    if (nil == _instance) {
        _instance = [[Catalog alloc] init];
    }
    return _instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        albumList = [[ NSArray alloc]init    ];
        albumList = soundlist;
    }
    return self;
}
- (NSUInteger)numberOfMusic
{
    return [albumList count];
}

- (id)musicAt:(NSUInteger)index
{
    return [albumList objectAtIndex:index];
}





@end
