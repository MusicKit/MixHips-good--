//
//  FollowerViewController.h
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 12..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumList.h"

@interface FollowerViewController : UIViewController
@property (strong,nonatomic) AlbumList *list;
@property NSString *soundID;
@end
