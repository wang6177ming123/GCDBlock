//
//  ViewController.h
//  GCDBlock
//
//  Created by pactera on 17/3/1.
//  Copyright © 2017年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明变量
typedef void (^ActionBlock)(void);
@interface ViewController : UIViewController

//定义
- (void)had:(ActionBlock)action;

@end

