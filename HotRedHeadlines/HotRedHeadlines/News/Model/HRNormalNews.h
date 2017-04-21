//
//  HRNormalNews.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRNormalNews : NSObject<NSCoding>
typedef NS_ENUM(NSUInteger, NormalNewsType) {
    NormalNewsTypeNoPicture = 1,
    NormalNewsTypeSigalPicture = 2,
    NormalNewsTypeMultiPicture = 3,//图片大于等于三张
};
@property (nonatomic, copy) NSString *article_url;/**<解释*/
@property (nonatomic, copy) NSString *image_url;/**<解释*/
@property (nonatomic, copy) NSString *source;/**<解释*/
@property (nonatomic, copy) NSString *title;/**<解释*/
@property (nonatomic, strong) NSMutableArray *image_list;/**<解释*/
@property (nonatomic, strong) NSNumber * ground_id;/**<解释*/
@property (nonatomic, strong) NSNumber * listId;/**<解释*/
@property (nonatomic, strong) NSString *time;/**<解释*/
//自己定义的变量
@property (nonatomic, assign) NormalNewsType normalNewsType;
@property (nonatomic, assign) NSInteger createdtime;//发布日期
- (void)readFromJSONDictionary:(NSDictionary *)d;
@end
