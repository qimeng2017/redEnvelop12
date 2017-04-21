//
//  SGActionSheet.m
//  SGActionSheetExample
//
//  Created by Sorgle on 16/9/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGActionSheet.git - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGActionSheet.h"
#import "SGActionSheetCell.h"
#import "UIView+SGExtension.h"

#define message_TextFond [UIFont systemFontOfSize:17]
#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define SG_screenHeight [UIScreen mainScreen].bounds.size.height

@interface SGActionSheet () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *coverView;

/** 信息提示文字 */
@property (nonatomic, copy) NSString *title;
/** 其他标题文字数组 */
@property (nonatomic, strong) NSArray *otherButtons;
/** 取消按钮文字 */
@property (nonatomic, copy) NSString *cancelButtonTitle;

/** 信息提示Label */
@property (nonatomic, strong) UILabel *message_label;
/** 其他按钮 */
@property (nonatomic, strong) UITableView *tableView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelButton;
/** 底部弹出视图 */
@property (nonatomic, strong) UIView *sheetView;

@end

@implementation SGActionSheet

/** Message与BGView之间的间距(X) */
static CGFloat const margin_X = 20;

/** Message与BGView之间的间距(Y) */
static CGFloat const margin_Y = 15;

/** 取消按钮到other按钮之间的间距 */
static CGFloat const margin_cancelButton_to_otherButton = 5;

/** 设置otherButtons的个数（多余这个数可以实现tableView的滚动 */
static NSInteger const otherButton_count = 3;

/** cell的高度 */
static CGFloat const cell_rowHeight = 50;

/** 底部View弹出的时间 */
static CGFloat const SheetViewAnimationDuration = 0.25;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray *)otherButtonTitleArray {
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        self.title = title;
        self.delegate_SG = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtons = [NSArray array];
        self.otherButtons = otherButtonTitleArray;
        
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title delegate:(id<SGActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray *)otherButtonTitleArray {
    return [[self alloc] initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitleArray:otherButtonTitleArray];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setupSubviews {
    
    // 遮盖视图
    self.coverView = [[UIButton alloc] init];
    self.coverView.frame = self.bounds;
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.coverView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.coverView];
    
    // 取消按钮的创建
    self.cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:self.cancelButtonTitle forState:(UIControlStateNormal)];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"SGActionSheet.bundle/cell_bg_image"] forState:(UIControlStateNormal)];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"SGActionSheet.bundle/cell_bg_image_high@2x"] forState:(UIControlStateHighlighted)];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 提示标题
    self.message_label = [[UILabel alloc] init];
    _message_label.textAlignment = NSTextAlignmentCenter;
    _message_label.numberOfLines = 0;
    _message_label.text = self.title;
    _message_label.font = message_TextFond;

    CGFloat message_label_W = SG_screenWidth - 2 * margin_X;
    CGSize message_labelSize = [self sizeWithText:_message_label.text font:message_TextFond maxSize:CGSizeMake(message_label_W, MAXFLOAT)];
    
    if (_message_label.text) {
        
        // 设置Message的frame
        _message_label.frame = CGRectMake(margin_X, margin_Y, SG_screenWidth - 2 * margin_X, message_labelSize.height);
        
        // 创建Message背景视图
        CGFloat message_bgViewHeight = message_labelSize.height + margin_Y * 2;

        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, SG_screenWidth, message_bgViewHeight);
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_message_label];
        
        // 创建分割线
        UIImageView *splitters = [[UIImageView alloc] init];
        splitters.image = [UIImage imageNamed:@"SGActionSheet.bundle/cell_splitters@2x"];
        splitters.frame = CGRectMake(0, message_bgViewHeight - 1, SG_screenWidth, 1);
        [bgView addSubview:splitters];

        
        CGFloat tableViewHeight; // tableView的高
        if (_otherButtons.count <= otherButton_count) {
            tableViewHeight = cell_rowHeight * _otherButtons.count;
        } else { // _otherButtons.count 大于 otherButton_count
            tableViewHeight = cell_rowHeight * otherButton_count;
        }
        
        // 创建tableView
        self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, message_bgViewHeight, SG_screenWidth, tableViewHeight)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = cell_rowHeight;
        
        // 创建底部弹出视图
        CGFloat sheetView_Height = message_bgViewHeight + tableViewHeight + margin_cancelButton_to_otherButton + cell_rowHeight;
        self.sheetView = [[UIView alloc] init];
        
        if (_otherButtons.count <= otherButton_count) {
            self.tableView.scrollEnabled = NO;
            _tableView.bounces = NO;
        }

        _cancelButton.frame = CGRectMake(0, sheetView_Height - cell_rowHeight, SG_screenWidth, cell_rowHeight);
        
        self.sheetView.frame = CGRectMake(0, SG_screenHeight, SG_screenWidth, sheetView_Height);

        [self.sheetView addSubview:bgView];
        [self.sheetView addSubview:_tableView];
        [self.sheetView addSubview:_cancelButton];
        
    } else {
        
        // 创建tableView
        CGFloat tableViewHeight;
        if (_otherButtons.count <= otherButton_count) {
            tableViewHeight = cell_rowHeight * _otherButtons.count;
        } else {
            tableViewHeight = cell_rowHeight * otherButton_count;
        }
        
        self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, SG_screenWidth, tableViewHeight)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = cell_rowHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        // 创建底部弹出视图
        CGFloat sheetViewHeight = tableViewHeight + 5 + cell_rowHeight;

        self.sheetView = [[UIView alloc] init];
        
        if (_otherButtons.count <= otherButton_count) {
            self.tableView.scrollEnabled = NO;
            _tableView.bounces = NO;
        }
        
        _cancelButton.frame = CGRectMake(0, sheetViewHeight - cell_rowHeight, SG_screenWidth, cell_rowHeight);

        self.sheetView.frame = CGRectMake(0, SG_screenHeight, SG_screenWidth, sheetViewHeight);
        
        [self.sheetView addSubview:_tableView];
        [self.sheetView addSubview:_cancelButton];
    }
    [self.coverView addSubview:_sheetView];
}

- (void)show {
    if (self.superview != nil) return;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:SheetViewAnimationDuration animations:^{
        self.sheetView.transform = CGAffineTransformMakeTranslation(0, - self.sheetView.SG_height);
    }];
}

/** 点击按钮以及遮盖部分执行的方法 */
- (void)dismiss {
    [UIView animateWithDuration:SheetViewAnimationDuration animations:^{
        self.sheetView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - - - TableView代理以及数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    SGActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SGActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.titleLabel.text = self.otherButtons[indexPath.row];
    cell.titleLabel.textColor = self.otherTitleColor;
    cell.titleLabel.font = self.otherTitleFont;
    cell.splitters.hidden = indexPath.row == 0;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate_SG respondsToSelector:@selector(SGActionSheet:didSelectRowAtIndexPath:)]) {
        [self.delegate_SG SGActionSheet:self didSelectRowAtIndexPath:indexPath.row];
    }
    [self dismiss];
}


#pragma mark - - - setter
- (void)setMessageTextColor:(UIColor *)messageTextColor {
    _messageTextColor = messageTextColor;
    self.message_label.textColor = messageTextColor;
}

- (void)setMessageTextFont:(UIFont *)messageTextFont {
    _messageTextFont = messageTextFont;
    self.message_label.font = messageTextFont;
    [self.sheetView removeFromSuperview];
    /** 抽出的部分代码 */
    [self SG_messageTextFont:messageTextFont];
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    _cancelButtonTitleColor = cancelButtonTitleColor;
    [_cancelButton setTitleColor:cancelButtonTitleColor forState:(UIControlStateNormal)];
}

- (void)setCancelButtonTitleFont:(UIFont *)cancelButtonTitleFont {
    _cancelButtonTitleFont = cancelButtonTitleFont;
    self.cancelButton.titleLabel.font = cancelButtonTitleFont;
}

/** 抽出的部分代码 */
- (void)SG_messageTextFont:(UIFont *)messageTextFont {
    // 提示标题
    self.message_label = [[UILabel alloc] init];
    _message_label.textAlignment = NSTextAlignmentCenter;
    _message_label.numberOfLines = 0;
    _message_label.text = self.title;
    _message_label.font = messageTextFont;
    
    CGFloat message_label_W = SG_screenWidth - 2 * margin_X;
    CGSize message_labelSize = [self sizeWithText:_message_label.text font:messageTextFont maxSize:CGSizeMake(message_label_W, MAXFLOAT)];
    
    if (_message_label.text) {
        // 设置Message的frame
        _message_label.frame = CGRectMake(margin_X, margin_Y, SG_screenWidth - 2 * margin_X, message_labelSize.height);
        
        // 创建Message背景视图
        CGFloat message_bgViewHeight = message_labelSize.height + margin_Y * 2;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, SG_screenWidth, message_bgViewHeight);
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_message_label];
        
        // 创建分割线
        UIImageView *splitters = [[UIImageView alloc] init];
        splitters.image = [UIImage imageNamed:@"SGActionSheet.bundle/cell_splitters@2x"];
        splitters.frame = CGRectMake(0, message_bgViewHeight - 1, SG_screenWidth, 1);
        [bgView addSubview:splitters];
        
        
        CGFloat tableViewHeight; // tableView的高
        if (_otherButtons.count <= otherButton_count) {
            tableViewHeight = cell_rowHeight * _otherButtons.count;
        } else { // _otherButtons.count 大于 otherButton_count
            tableViewHeight = cell_rowHeight * otherButton_count;
        }
        
        // 创建tableView
        self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, message_bgViewHeight, SG_screenWidth, tableViewHeight)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = cell_rowHeight;
        
        // 创建底部弹出视图
        CGFloat sheetView_Height = message_bgViewHeight + tableViewHeight + margin_cancelButton_to_otherButton + cell_rowHeight;
        self.sheetView = [[UIView alloc] init];
        
        if (_otherButtons.count <= otherButton_count) {
            self.tableView.scrollEnabled = NO;
            _tableView.bounces = NO;
        }
        
        _cancelButton.frame = CGRectMake(0, sheetView_Height - cell_rowHeight, SG_screenWidth, cell_rowHeight);
        
        self.sheetView.frame = CGRectMake(0, SG_screenHeight, SG_screenWidth, sheetView_Height);
        
        [self.sheetView addSubview:bgView];
        [self.sheetView addSubview:_tableView];
        [self.sheetView addSubview:_cancelButton];
    }
    [self.coverView addSubview:_sheetView];
}

@end
