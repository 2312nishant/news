//
//  CategorizeUrl.m
//  PCBNewsProject
//
//  Created by pawanag on 6/3/15.
//  Copyright (c) 2015 Pawan. All rights reserved.
//

#import "CategorizeUrl.h"



@implementation CategorizeUrl

static CategorizeUrl *sharedMyManager = nil;

-(NSString*)currentNewsCategory {
    
    if(!_currentNewsCategory) {
        _currentNewsCategory = [[NSString alloc]init];
        _currentNewsCategory = @"Home Page";
    }
    return _currentNewsCategory;
}

+ (id)sharedCategorizeUrlObject {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


+(NSString*) getNewsUrlType : (NSString*) string{

    if ([string isEqualToString:@"Notifications"]) {
        return @"getNotificationNews.php";
    } else if ([string isEqualToString:@"Banner"]) {
        return @"getBannerNews.php";
    } else if ([string isEqualToString:@"Pimpri"]) {
        return @"getPimpriNews.php";
    } else if  ([string isEqualToString:@"Chinchwad"]) {
        return @"getChinchwadNews.php";
    } else if ([string isEqualToString:@"Bhosari"]) {
        return @"getBhosariNews.php";
    } else if ([string isEqualToString:@"Pune"]) {
        return @"getPuneNews.php";
    } else if ([string isEqualToString:@"Maharashtra"]) {
        return @"getMaharashtraNews.php";
    } else if ([string isEqualToString:@"Desh"]) {
        return @"getDeshNews.php";
    } else if  ([string isEqualToString:@"Videsh"]) {
        return @"getVideshNews.php";
    } else if ([string isEqualToString:@"Sampadakiya"]) {
        return @"getSampadakiyNews.php";
    } else if ([string isEqualToString:@"Poll"]) {
        return @"getPoll.php";
    } else if ([string isEqualToString:@"Krida"]) {
        return @"getSportsNews.php";
    } else if ([string isEqualToString:@"Aarogya"]) {
        return @"getHealthNews.php";
    } else if  ([string isEqualToString:@"Yuva Vishwa"]) {
        return @"getYouthWorldNews.php";
    } else if ([string isEqualToString:@"Mahila Vishwa"]) {
        return @"getWomenWorldNews.php";
    } else if ([string isEqualToString:@"Sahitya"]) {
        return @"getSahityaNews.php";
    } else if ([string isEqualToString:@"Business"]) {
        return @"getBusinessNews.php";
    } else if ([string isEqualToString:@"TantraGyan"]) {
        return @"getTechnologyNews.php";
    } else if ([string isEqualToString:@"Rashi Bhavishya"]) {
        return @"getAstrologyNews.php";
    } else if ([string isEqualToString:@"Career"]) {
        return @"getCareerNews.php";
    } else if ([string isEqualToString:@"Khadya Bhramanti"]) {
        return @"getFoodSafariNews.php";
    } else if ([string isEqualToString:@"Life Style"]) {
        return @"getLifeStyleNews.php";
    } else if ([string isEqualToString:@"Manoranjan"]) {
        return @"getEntertainmentNews.php";
    } else if ([string isEqualToString:@"Rojgar"]) {
        return @"getCareerNews.php";
    } else {
        return @"getBannerNews.php";
    }

}

+(NSString*) getCurrentNewsCategory {
    [self sharedCategorizeUrlObject];
   return sharedMyManager.currentNewsCategory;
}

+(void) setCurrentNewsCategory : (NSString*)categoryString {
    sharedMyManager.currentNewsCategory = categoryString;
    
}




@end
