//
//  PaoMaDengView.m
//  DemoBlurView
//
//  Created by 董杰 on 2017/5/26.
//  Copyright © 2017年 DexJay. All rights reserved.
//

#import "PaoMaDengView.h"

#define kLabelEdgePadding (2)
#define kLabelFont (14)
#define kLabelTextColor ([UIColor lightGrayColor])

@interface PaoMaDengView()

@property(nonatomic, strong) NSString *msgStr;
@property(nonatomic, assign) CGFloat msgLbaelMaxWidth;

@property(nonatomic, assign) BOOL canScroll;//是否需要滚动

@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UILabel *copyLabel;

//定时器
@property(nonatomic, strong) NSTimer *actionTimer;

@end

@implementation PaoMaDengView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)initBaseView
{
    NSLog(@"~~~ 初始化 界面 ~~");
    
    self.msgLbaelMaxWidth = CGRectGetWidth(self.frame) - 2 * kLabelEdgePadding;
    self.firstLabel.frame = CGRectMake(kLabelEdgePadding, 5, self.msgLbaelMaxWidth, 20);
    [self addSubview:self.firstLabel];
    
    [self addSubview:self.copyLabel];
}

-(void)fillDataWithMsgStr:(NSString *)msg
{
    self.msgStr = msg;
    [self refreshScrollLabel];
}

-(void)refreshScrollLabel
{
    CGFloat msgWidth = [self fetchTheWidthOfTheMessageStr];
    
    if (msgWidth > self.msgLbaelMaxWidth) {
        self.canScroll = YES;
    }else{
        self.canScroll = NO;
    }
    
    if (self.canScroll == YES) {
        //可以 滚动
        self.copyLabel.hidden = NO;
        
        CGRect oldRect = self.firstLabel.frame;
        CGFloat firstEnd = CGRectGetMaxX(self.firstLabel.frame);
        oldRect.origin.x = firstEnd;
        self.copyLabel.frame = oldRect;
        
        self.copyLabel.text = self.firstLabel.text = self.msgStr;
        
        CGFloat speed = 3;
        [self paoMaScrollActionWithSpeed:speed];

    }else{
        //不可以 滚动
        self.firstLabel.text = self.msgStr;
        self.copyLabel.hidden = YES;
    }
    
}

-(void)paoMaScrollActionWithSpeed:(CGFloat)speed
{
    //跑马灯 滚动
    if (!self.actionTimer) {
        self.actionTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
            if (CGRectGetMaxX(self.firstLabel.frame) <= 0) {
                CGFloat firstEnd = CGRectGetMaxX(self.copyLabel.frame);
                CGRect oldCopyRect = self.copyLabel.frame;
                oldCopyRect.origin.x = firstEnd;
                self.firstLabel.frame = oldCopyRect;
            }else{
                CGRect oldRect = self.firstLabel.frame;
                oldRect.origin.x -= speed;
                self.firstLabel.frame = oldRect;
            }
            
            if (CGRectGetMaxX(self.copyLabel.frame) <= 0) {
                CGFloat firstEnd = CGRectGetMaxX(self.firstLabel.frame);
                CGRect oldCopyRect = self.copyLabel.frame;
                oldCopyRect.origin.x = firstEnd;
                self.copyLabel.frame = oldCopyRect;
            }else{
                CGRect oldCopyRect = self.copyLabel.frame;
                oldCopyRect.origin.x -= speed;
                self.copyLabel.frame = oldCopyRect;
            }
            
        }];
        
    }else{
        self.actionTimer = nil;
        [self.actionTimer invalidate];
//        [[NSRunLoop currentRunLoop] addTimer:self.actionTimer forMode:NSRunLoopCommonModes];
        self.actionTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            CGRect oldRect = self.firstLabel.frame;
            oldRect.origin.x -= speed;
            self.firstLabel.frame = oldRect;
            
            CGFloat firstEnd = CGRectGetMaxX(self.firstLabel.frame);
            CGRect oldCopyRect = self.copyLabel.frame;
            oldCopyRect.origin.x = firstEnd;
            self.copyLabel.frame = oldCopyRect;
            
        }];

    }
    
}


#pragma mark - Private
-(CGFloat)fetchTheWidthOfTheMessageStr
{
    if (!self.msgStr) {
        return 30;
    }else{

        CGFloat msgHeight = 20;
        UIFont *mFont;
        if (self.paoFont) {
            mFont = self.paoFont;
        }else{
            mFont = [UIFont systemFontOfSize:kLabelFont];
        }
      
        CGSize msgSize = [self.msgStr boundingRectWithSize:CGSizeMake(MAXFLOAT, msgHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor redColor]} context:nil].size;
        
        if (msgSize.width < 30) {
            return 30;
        }else{
            return msgSize.width;
        }
        
    }
    
}

#pragma mark - Data
-(void)setPaoFont:(UIFont *)paoFont
{
    _paoFont = paoFont;
}

-(void)setPaoTextColor:(UIColor *)paoTextColor
{
    _paoTextColor = paoTextColor;
}

#pragma mark - Property
-(UILabel *)firstLabel
{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.textColor = kLabelTextColor;
        _firstLabel.font = [UIFont systemFontOfSize:kLabelFont];
    }
    return _firstLabel;
}

-(UILabel *)copyLabel
{
    if (!_copyLabel) {
        _copyLabel = [[UILabel alloc] init];
        _copyLabel.textColor = kLabelTextColor;
        _copyLabel.font = [UIFont systemFontOfSize:kLabelFont];

    }
    return _copyLabel;
}

-(void)dealloc
{
    [self.actionTimer invalidate];
    self.actionTimer = nil;
}



@end
