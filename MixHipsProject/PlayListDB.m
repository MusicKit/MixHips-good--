//
//  PlayListDB.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "PlayListDB.h"
#import <sqlite3.h>
#import "Playlist.h"
#import "AlbumList.h"

@interface PlayListDB()



@end

@implementation PlayListDB
{
    sqlite3 *db;
    AlbumList *list;
    NSMutableArray *data;
    NSMutableDictionary *playlist;
    
}

static PlayListDB *_instance = nil;


+ (id)sharedPlaylist
{
    if (nil == _instance) {
        _instance = [[PlayListDB alloc] init];
        [_instance openDB];
    }
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)openDB {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"MixHips.sqlite"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    
    if (SQLITE_OK != ret) {
        return NO;
    }
    
    if (existFile == NO) {
        char *creatSQL = "CREATE TABLE IF NOT EXISTS playlist (song_title TEXT, song_url TEXT, Nick_name TEXT, album_img TEXT)";
        char *errorMsg;
        ret = sqlite3_exec(db, creatSQL, NULL, NULL, &errorMsg);
        if (SQLITE_OK != ret) {
            [fm removeItemAtPath:dbFilePath error:nil];
            NSLog(@"creating table with ret : %d", ret);
            return NO;
        }
        ret = sqlite3_exec(db, creatSQL, NULL, NULL, &errorMsg);
        if (SQLITE_OK != ret) {
            [fm removeItemAtPath:dbFilePath error:nil];
            NSLog(@"creating table with ret : %d", ret);
            return NO;
        }
    }
    return YES;
}
/////////
- (NSInteger)addMovieWithName:(NSString *)name nickName:(NSString *)nickName song_id:(NSString *)song_id album_img:(NSString *)album_img{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO playlist (song_title, Nick_name, song_url, album_img) VALUES ('%@','%@','%@','%@')", name, nickName, song_id, album_img];
  
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
    NSInteger movieID = (NSInteger)sqlite3_last_insert_rowid(db);
    [self fetchMovies];
    return movieID;
}

- (NSInteger)getNumberOfMovies {
    return _playList.count;
}

- (void)fetchMovies {
    _playList = [[NSMutableArray alloc] init];
    _nickNameList =[[NSMutableArray alloc]init];
    _sound_ID = [[NSMutableArray alloc ]init];
    _album_img = [[NSMutableArray alloc]init];

    data = [[NSMutableArray alloc]init];
    
    NSString *queryStr = @"SELECT rowid, song_title, Nick_name, song_url, album_img FROM playlist";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret,sqlite3_errmsg(db));
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        
        list = [[AlbumList alloc]init];
        char *title = (char *)sqlite3_column_text(stmt, 1);
        char *nickName = (char *)sqlite3_column_text(stmt, 2);
        char *song_id = (char *)sqlite3_column_text(stmt, 3);
        char *album_img = (char *)sqlite3_column_text(stmt, 4);
        int rowID = sqlite3_column_int(stmt, 0);
        
        list.rowID = rowID;
        list.songTitle= [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        list.nickName = [NSString stringWithCString:nickName encoding:NSUTF8StringEncoding];
        list.sound_id = [NSString stringWithCString:song_id encoding:NSUTF8StringEncoding];
        list.album_img = [NSString stringWithCString:album_img encoding:NSUTF8StringEncoding];
        NSLog(@"sounddidfjeifie %@",list.sound_id);
        [data addObject:list];
        [_sound_ID addObject:list.sound_id];
        [_playList addObject:list.songTitle];
        [_nickNameList addObject:list.nickName];
        [_album_img addObject:list.album_img];

        NSLog(@"data %@",data);
    }
    sqlite3_finalize(stmt);
}

-(NSArray *)cacheData{
    return data;
}

-(NSArray *)data:(NSIndexPath *)indexPath{
    return _sound_ID[indexPath.row];
}

-(NSInteger)deleteMusic:(NSInteger)indexpath{
    list = [data objectAtIndex:indexpath];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM playlist WHERE rowid = %d", list.rowID];
    NSLog(@"%@",sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
    NSInteger movieID = (NSInteger)sqlite3_last_insert_rowid(db);
    [self fetchMovies];
    return movieID;
}

-(NSArray *)data{
    return _sound_ID;
}

-(NSArray *)albumimg{
    return _album_img;
}

-(NSString *)getalbumImgAtIndex:(NSInteger)index{
    return _album_img[index];
}

-(NSString *)getSoundIdAtIndex:(NSInteger)index{
    return _sound_ID[index];
}


-(NSString *)getNickNameOfMusicAtIndex:(NSInteger)index{
    return _nickNameList[index];
}

- (NSString *)getNameOfMovieAtIndex:(NSInteger)index {
    return _playList[index];
}

@end
