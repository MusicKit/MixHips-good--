//
//  MyAlbumCell.h
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumList.h"

@interface MyAlbumCell : UITableViewCell
@property (strong,nonatomic) NSString *soundid;
- (void) setProductInfo:(AlbumList *)list indexPath:(NSInteger)index;
@end
