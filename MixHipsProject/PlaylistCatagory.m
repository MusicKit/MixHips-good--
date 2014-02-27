//
//  PlaylistCatagory.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 6..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "PlaylistCatagory.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlayListDB.h"
#import "Player.h"
#import "cacheList.h"


#import "PlayerViewController.h"


@implementation PlaylistCatagory{
    PlayListDB *playDB;
    Player *playerlist;
    NSMutableArray *list;
    NSTimer *timer;
    NSTimer *timer1;
    NSTimer *timer2;
    NSString *purl;
    NSString *musicURL;
    NSString* urlTextEscaped;
    NSInteger indexPathRow;
    NSArray *listTrack;
    NSString * timeString;
    NSString *userName;
    NSString *soundName;
    NSString *soundid11;
    AVPlayerItem* playerItem;
    BOOL loop;
    BOOL playBool;
}
@synthesize player;

static PlaylistCatagory *_instance = nil;

+ (id)defaultCatalog
{
    if (nil == _instance) {
        _instance = [[PlaylistCatagory alloc] init];
    }
    return _instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        [PlayListDB sharedPlaylist];
        [self loadData];
    }
    return self;
}

-(void)changeTime:(NSInteger)time{
    
    [player seekToTime:CMTimeMakeWithSeconds(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished){
        [player play];
    }];
}

- (void)test:(NSDictionary *)dic {
    NSDictionary *dd = [NSDictionary dictionaryWithDictionary:dic];
    NSArray *soundlist = [dd objectForKey:@"sounds_list"];
    NSMutableArray *soundURL = [[NSMutableArray alloc]init];
    
    if(soundlist.count == 0){
        playerlist = [Player defaultCatalog];
        playDB = [PlayListDB sharedPlaylist];
        [playDB deleteMusic:playerlist.indexPathRow];
        [playDB fetchMovies];
        
        listTrack =  [playDB data];
        if(playerlist.indexPathRow == listTrack.count){
            playerlist.indexPathRow = 0;
            NSString *soundid = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
            [self AFNetworkingPlay:soundid];
            
        }
        else{
            
            NSString *soundid = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
            [self AFNetworkingPlay:soundid];
        }


    }
    else{
        [soundURL addObject:[soundlist[0] objectForKey:@"sound_url"]];
        purl = [NSString stringWithFormat:@"%@",soundURL[0]];
        musicURL = [NSString stringWithFormat:@"http://mixhips.nowanser.cloulu.com%@",purl];
        urlTextEscaped = [musicURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
}
-(void)AFNetworkingPlay:(NSString *)soundid{
    [self.delegate indicator];
    NSString *i = [NSString stringWithFormat:@"%@",soundid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"sounds_id":i};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/fetch_sounds" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self test:responseObject];
        NSURL *urlForPlay = [NSURL URLWithString:urlTextEscaped];
        [self playMusic:urlForPlay];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        playerlist = [Player defaultCatalog];
        playerlist.indexPathRow++;

        playDB = [PlayListDB sharedPlaylist];
        listTrack =  [playDB data];

        if(playerlist.indexPathRow > listTrack.count-1){
            playerlist.indexPathRow = 0;
            NSString *soundid = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
            [self AFNetworkingPlay:soundid];
        }
        
    }];
    
}



-(void)playStart:(NSString *)soundid{
    [self AFNetworkingPlay:soundid];
}

-(BOOL)returnLoop{
    return loop;
}

-(void)loopPlay{
    loop = YES;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:[player currentItem]];
}

-(void)notloopPlay{
    loop = NO;
}



-(void)changeLockScreen:(UIImage *)img soundName:(NSString *)soundName1 userName:(NSString *)userName1{
     MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:img];
    NSArray *keys = [NSArray arrayWithObjects:
                     MPMediaItemPropertyTitle,
                     MPMediaItemPropertyArtist,
                     MPMediaItemPropertyPlaybackDuration,
                     MPNowPlayingInfoPropertyPlaybackRate,
                     MPNowPlayingInfoPropertyElapsedPlaybackTime,
                     MPMediaItemPropertyArtwork,
                     nil];
    NSArray *values = [NSArray arrayWithObjects:
                       soundName1,
                       userName1,
                       [[NSNumber alloc] initWithInteger:[self getDuration]],
                       [NSNumber numberWithInt:1],
                       [[NSNumber alloc] initWithInteger:[self getCurTime]],
                       artWork,
                       nil];
    NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
}

- (int)getDuration{
    return (int)CMTimeGetSeconds(player.currentItem.asset.duration);
}
- (int)getCurTime{
    return (int)CMTimeGetSeconds(player.currentTime);
}
- (void)syncPlayTimeLabel:(NSTimer *)t{
    int duration = [self getDuration];
    int currentTime = [self getCurTime];
    int durationMin = (int)(duration / 60);
    int durationSec = (int)(duration % 60);
    int currentMins = (int)(currentTime / 60);
    int currentSec = (int)(currentTime % 60);
    float ff = currentTime / (float)duration;

    
    timeString =[NSString stringWithFormat:@"%02d:%02d/%02d:%02d",currentMins,currentSec,durationMin,durationSec];
    
    [self.delegate updateProgressViewWithPlayer:timeString time:ff];
    [self.delegate1 updateProgressViewWithPlayer:timeString time:ff];
    [self.delegate2 updateProgressViewWithPlayer:timeString time:ff];
    [self.delegate3 updateProgressViewWithPlayer:timeString time:ff];
    [self.delegate4 updateProgressViewWithPlayer:timeString time:ff];
    
}
// 임시
-(float) getTime {
    int duration = [self getDuration];
    int currentTime = [self getCurTime];
    float ff = currentTime / (float)duration;
    return ff;
}

- (void)setAudioSession{
    NSError *error = nil;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:kAudioSessionProperty_OverrideCategoryMixWithOthers error:&error];
    
    [session setActive:YES error:&error];
}

- (void)updateInfo{
    [self.delegate setUser:userName setSound:soundName];
    [self.delegate1 setUser:userName setSound:soundName];
    [self.delegate2 setUser:userName setSound:soundName];
    [self.delegate3 setUser:userName setSound:soundName];
    [self.delegate4 setUser:userName setSound:soundName];
    [self.delegate1 notiPlay];
    [self.delegate2 notiPlay];
    [self.delegate3 notiPlay];
    [self.delegate4 notiPlay];
}


- (void) saveData:(NSInteger)indexPathRowf
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userNamef = [NSString stringWithFormat:@"%@",[playDB getNickNameOfMusicAtIndex:indexPathRowf]];
    NSString *soundNamef = [NSString stringWithFormat:@"%@",[playDB getNameOfMovieAtIndex:indexPathRowf]];
     NSString *soundIDf = [NSString stringWithFormat:@"%@",[playDB getSoundIdAtIndex:indexPathRowf]];
    
    [defaults setObject:userNamef forKey:@"userName"];
    [defaults setObject:soundNamef forKey:@"soundName"];
    [defaults setInteger:indexPathRowf forKey:@"indexpath"];
    [defaults setObject:soundIDf forKey:@"soundId"];
    
    [defaults synchronize];
}

- (void) loadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ff = [defaults objectForKey:@"indexpath"];
    [Player defaultCatalog];
    playDB = [PlayListDB sharedPlaylist];
    [playerlist setIndexPathrow:ff.integerValue];
}

-(BOOL)playStatus{
    return playBool;
}

-(void)playMusic:(NSURL *)url{
    playDB = [PlayListDB sharedPlaylist];
    [playDB fetchMovies];
    playerItem = [AVPlayerItem playerItemWithURL:url];
    [Player defaultCatalog];
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(syncPlayTimeLabel:) userInfo:Nil repeats:YES];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
     playerlist = [Player defaultCatalog];
    NSArray *albumImgTrack = [playDB albumimg];

    userName = [NSString stringWithFormat:@"%@",[playDB getNickNameOfMusicAtIndex:playerlist.indexPathRow]];
    soundName = [NSString stringWithFormat:@"%@",[playDB getNameOfMovieAtIndex:playerlist.indexPathRow]];
    NSString *ff = @"http://mixhips.nowanser.cloulu.com";
    ff = [ff stringByAppendingString:albumImgTrack[playerlist.indexPathRow]];
    NSURL *fee = [NSURL URLWithString:ff];
    NSData *img = [NSData dataWithContentsOfURL:fee];
    
    UIImage *albumImg = [UIImage imageWithData:img];
    
    [self.delegate setImg:playerlist.indexPathRow];
    
    playBool = YES;

    [self saveData:playerlist.indexPathRow];
    [self changeLockScreen:albumImg soundName:soundName userName:userName];
    [self setAudioSession];
    [self updateInfo];
    [self.delegate stopindicator];
    [player play];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    if(loop == YES){
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
    else{
    // Will be called when AVPlayer finishes playing playerItem
    playerlist = [Player defaultCatalog];
    playerlist.indexPathRow++;
   
    listTrack =  [playDB data];
    if(playerlist.indexPathRow > listTrack.count-1){
        playerlist.indexPathRow = 0;
        NSString *soundid = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
        [self AFNetworkingPlay:soundid];
        
    }
    else{
        NSString *soundid = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
       [self AFNetworkingPlay:soundid];
    }
    }
}
@end
