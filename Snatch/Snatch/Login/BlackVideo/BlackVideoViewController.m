//
//  BlackVideoViewController.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "BlackVideoViewController.h"
#import "GJVideoFunctions.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface BlackVideoViewController ()
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) AVPlayerLayer   *avlayer;
@property (nonatomic,strong) AVPlayerItem *playerItem;

@property (assign) BOOL isLoop;
@end

@implementation BlackVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoop=[GJVideoFunctions getLoopMode];
    [self prepareClipPlayback];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNotification];
    [_avPlayer play];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_avPlayer pause];
}

#pragma mark - Player
-(void) prepareClipPlayback{
    if (_avPlayer == nil) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        NSURL *urlMovie = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[GJVideoFunctions getVideoUrl] ofType:[GJVideoFunctions getVideoType]]];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:urlMovie options:nil];
        _playerItem = [AVPlayerItem playerItemWithAsset:asset];
        _avPlayer = [AVPlayer playerWithPlayerItem: _playerItem];
        _avlayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        if (self.navigationController) {
            _avlayer.frame = (CGRect){0, 64, self.view.frame.size.width, self.view.frame.size.height-(64+49)};
        }else{
            _avlayer.frame = (CGRect){0, 0, self.view.frame.size.width, self.view.frame.size.height};
        }
        
        _avlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_avlayer];
        //视频充满
        _avlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_avPlayer play];
    }
}

#pragma mark - MPMoviePlayerPlaybackStateDidChangeNotification
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    //NSLog(@"视频播放完成.");
    
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_avPlayer seekToTime:CMTimeMake(0, 1)];
    [_avPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
