//
//  AnimationViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/10.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *tLabel;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startAnimation];
}
-(void)startAnimation{
    [UIView beginAnimations:@"bound" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationRepeatCount:MAX_CANON];
    [UIView setAnimationRepeatAutoreverses:YES];
    CGRect tmp = self.ballView.frame;
    tmp.origin.y +=100;
    self.ballView.frame = tmp;
    CGRect tmp2 = self.tLabel.frame;
    tmp2.origin.y +=100;
    self.tLabel.frame = tmp2;
    [UIView commitAnimations];
    [self performSelector:@selector(toNextView) withObject:nil afterDelay:1];
}

-(void)toNextView{
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTabBarViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}




@end
