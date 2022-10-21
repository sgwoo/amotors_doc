//
//  AppDelegate.h
//  paySample-objective-C
//
//  Created by 서정현 on 2018. 12. 19..
//  Copyright © 2018년 서정현. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

