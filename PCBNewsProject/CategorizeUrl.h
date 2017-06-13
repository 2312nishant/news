//
//  CategorizeUrl.h
//  PCBNewsProject
//
//  Created by pawanag on 6/3/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategorizeUrl : NSObject

+(NSString*) getNewsUrlType : (NSString*)string;
+(NSString*) getCurrentNewsCategory;
+(void) setCurrentNewsCategory : (NSString*)categoryString  ;
@property (nonatomic,strong) NSString * currentNewsCategory;

@end
