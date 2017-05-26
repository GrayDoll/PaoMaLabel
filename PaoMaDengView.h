//
//  PaoMaDengView.h
//  DemoBlurView
//
//  Created by 董杰 on 2017/5/26.
//  Copyright © 2017年 DexJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaoMaDengView : UIView

-(void)fillDataWithMsgStr:(NSString *)msg;

@property(nonatomic, strong) UIFont *paoFont;
@property(nonatomic, strong) UIColor *paoTextColor;



@end
