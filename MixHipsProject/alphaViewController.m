//
//  alphaViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 26..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "alphaViewController.h"
#import "AlbumEditViewController.h"

@interface alphaViewController ()<alphaDelegate>


@end

    @implementation alphaViewController{
        UIActivityIndicatorView *indicator;
        UILabel *uploadLabel;
    }
-(void)statusLabel:(NSString *)status{
    uploadLabel.text = status;
    }
-(void)startIndicator{
    [indicator startAnimating];
}
-(void)stopIndicator{
    [indicator stopAnimating];
}
-(void)dismissView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AlbumEditViewController *albumVC;
    albumVC.alphadelegate = self;
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    UIView* backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:backView];
    
    UILabel *statusLable = [[UILabel alloc]initWithFrame:CGRectMake(106, 130, 108, 21)];
    statusLable.text = @"업로드중입니다";
    [backView addSubview:statusLable];
    
    uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 190, 108, 21)];
    [uploadLabel setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:uploadLabel];
    

    
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135, 145, 50, 50)];
    [indicator setTintColor:[UIColor blackColor]];
    [backView addSubview:indicator];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
