//
//  PlayListDB.h
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListDB : NSObject
@property NSMutableArray *playList;
@property NSMutableArray *nickNameList;
@property NSMutableArray *sound_ID;
@property NSMutableArray *album_img;
- (NSInteger)addMovieWithName:(NSString *)name nickName:(NSString *)nickName song_id:(NSString *)song_id album_img:(NSString *)album_img;
- (NSInteger)getNumberOfMovies;
- (void)fetchMovies;
- (NSString *)getNameOfMovieAtIndex:(NSInteger)index;
+ (id)sharedPlaylist;
-(NSString *)getNickNameOfMusicAtIndex:(NSInteger)index;
-(NSInteger)deleteMusic:(NSInteger)indexpath;
-(NSString *)getSoundIdAtIndex:(NSInteger)index;
-(NSArray *)data:(NSIndexPath *)indexPath;
-(NSArray *)data;
-(NSString *)getalbumImgAtIndex:(NSInteger)index;
-(NSArray *)albumimg;

//test
-(NSArray *)cacheData;
@end
