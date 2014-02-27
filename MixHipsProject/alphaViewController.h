//
//  alphaViewController.h
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 26..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "alphaDelegate.h"


@interface alphaViewController : UIViewController<alphaDelegate>

-(void)dismissView;

-(void)startIndicator;

-(void)stopIndicator;

-(void)statusLabel:(NSString *)status;
@end
