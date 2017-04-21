//
//  HRHelpCellFrame.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRHelpCellFrame.h"
#import "HRHelpModel.h"
#import "NSString+Extension.h"
@implementation HRHelpCellFrame
- (void)setCellModel:(HRHelpModel *)cellModel{
    _cellModel = cellModel;
    CGFloat iconX = 0;
    CGFloat iconY = 10;
    CGFloat iconW = 0;
    CGFloat iconH = 0;
    if (cellModel.imageURL.length >0) {
        iconX = 15;
        iconW = 20;
        iconH = 20;
    }
    self.imageFrame = CGRectMake(iconX, iconY, iconW, iconH);
    CGSize problemSize = [cellModel.problem sizeWithFont:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat problemX = CGRectGetMaxX(self.imageFrame)+10;
    CGFloat problemY = iconY;
    self.problemFrame = CGRectMake(problemX, problemY, problemSize.width, problemSize.height);
    CGSize answerSize;
    if(self.isOpened == YES){
        answerSize = [cellModel.answer sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(kScreenWidth -problemX - 10, MAXFLOAT)];
    }else{
        answerSize = [cellModel.answer sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake(kScreenWidth -problemX - 10, 10)];
    }
    CGFloat answerX = problemX;
    CGFloat answerY = CGRectGetMaxY(self.problemFrame) +10;
    self.answerFrame = CGRectMake(answerX, answerY, answerSize.width, answerSize.height);
    self.cellHeight = CGRectGetMaxY(self.answerFrame)+10;
    CGFloat moreW = 23;
    CGFloat moreH = 23;
    CGFloat moreX = kScreenWidth - 33;
    CGFloat moreY = answerY;
    self.moreFrame = CGRectMake(moreX, moreY, moreW, moreH);
}

+(NSMutableArray *)cellSourceWithName:(NSString *)sourceName{
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:sourceName ofType:@"geojson"];
    NSString *parseJason = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
   NSDictionary *dict = [NSString dictionaryWithJsonString:parseJason];
    NSArray *array = [dict objectForKey:@"coordinates"];
    NSMutableArray *endArray = [NSMutableArray array];
   
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        HRHelpModel *model = [[HRHelpModel alloc]init];
        [model readFromJSONDictionary:dict];
        HRHelpCellFrame *cellFrame = [[HRHelpCellFrame alloc] init];
        cellFrame.cellModel = model;
        [endArray addObject:cellFrame];
    }];
   
    return endArray;
}
@end
