//
//  XDDropDownMenu.m
//  XDDropDownMenu
//
//  Created by 蔡欣东 on 16/5/2.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDDropDownMenu.h"

#define MenuBackgoundColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0]
// 选中颜色加深
#define SelectedColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0]

@interface NSString (getSize)
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end

@implementation NSString (getSize)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}
@end

@interface XDDropDownMenu()
@property(nonatomic,assign)NSInteger currentSelectedIndex;
@property(nonatomic,assign)BOOL show;
@property(nonatomic,assign)NSInteger numOfMenu;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,strong)UIView* backgoundView;
@property(nonatomic,strong)UIView* bottomShadowView;
@property(nonatomic,strong)UITableView* leftTableView;
@property(nonatomic,strong)UITableView* rightTableView;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, assign) BOOL hadSelected;

@end


@implementation XDDropDownMenu

#pragma mark - getter
-(UIColor *)indicatorColor{
    if (!_indicatorColor) {
        _indicatorColor = [UIColor lightGrayColor];
    }
    return _indicatorColor;
}

-(UIColor *)textColor{
    if (!_textColor) {
        _textColor = [UIColor darkGrayColor];
    }
    return _textColor;
}

-(UIColor *)seperatorColor{
    if (!_seperatorColor) {
        _seperatorColor = [UIColor lightGrayColor];
    }
    return _seperatorColor;
}

#pragma mark - setter
-(void)setDatasource:(id<XDDropDownMenuDataSource>)datasource{
    _datasource = datasource;
    
    if ([_datasource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_datasource numberOfColumnsInMenu:self];
    }else{
        _numOfMenu =  1;
    }
    
    
    CGFloat layerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i=0; i<_numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*layerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:MenuBackgoundColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake((i+0.5)*layerInterval, self.frame.size.height/2);;
        NSString *titleString = [_datasource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height/2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * layerInterval, self.frame.size.height/2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.seperatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
        _bottomShadowView.backgroundColor = self.seperatorColor;
        _titles = [tempTitles copy];
        _indicators = [tempIndicators copy];
        _bgLayers = [tempBgLayers copy];
    }
}

#pragma mark - create layer
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    //为了正确地计算出它们的边界，我需要将画笔的大小考虑在内
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    CGSize size = [self calculateTitleSizeWithString:string];
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - init
-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedIndex = -1;
        _show = NO;
        _hadSelected = NO;
        
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(origin.x, self.frame.origin.y+self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 38;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 38;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;
        
        
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapMenuGestire = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapMenuGestire];
        
        _backgoundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backgoundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgoundView.opaque = NO;
        UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backgoundView addGestureRecognizer:tapBackGesture];
        
        _bottomShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        [self addSubview:_bottomShadowView];
    }
    return self;
}

#pragma mark - gesture response
- (void)menuTapped:(UITapGestureRecognizer *)gesture {
    //触击的点
    CGPoint touchPoint = [gesture locationInView:self];
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                
            }];
            [(CALayer *)self.bgLayers[i] setBackgroundColor:MenuBackgoundColor.CGColor];
        }
    }
    
    BOOL haveRightTableView = [_datasource haveRightTableInColumn:tapIndex];
    UITableView *rightTableView = nil;
    if (haveRightTableView) {
        rightTableView = _rightTableView;
    }
        
    if (tapIndex == _currentSelectedIndex && _show) {
            
        [self animateIdicator:_indicators[_currentSelectedIndex] background:_backgoundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedIndex] forward:NO complecte:^{
                _currentSelectedIndex = tapIndex;
                _show = NO;
        }];
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:MenuBackgoundColor.CGColor];
    }else{
        _hadSelected = NO;
        _currentSelectedIndex = tapIndex;
        if ([_datasource respondsToSelector:@selector(currentSelectedRowInLeftTableOfColumn:)]) {
            _leftSelectedRow = [_datasource currentSelectedRowInLeftTableOfColumn:_currentSelectedIndex];
        }
        if (rightTableView) {
            [rightTableView reloadData];
        }
        [_leftTableView reloadData];
            
        CGFloat proportion = [_datasource proportionOfWidthInLeftColumn:_currentSelectedIndex];
        if (_leftTableView) {
            _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*proportion, 0);
        }
        if (_rightTableView) {
            _rightTableView.frame = CGRectMake(_origin.x+_leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-proportion), 0);
        }
        [self animateIdicator:_indicators[_currentSelectedIndex] background:_backgoundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedIndex] forward:YES complecte:^{
                    _show = YES;
        }];
        
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectedColor.CGColor];
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)gesture
{
    [self animateIdicator:_indicators[_currentSelectedIndex] background:_backgoundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedIndex] forward:NO complecte:^{
            _show = NO;
        }];
    [(CALayer *)self.bgLayers[_currentSelectedIndex] setBackgroundColor:MenuBackgoundColor.CGColor];
}

#pragma mark - animation
- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    if (complete) {
        complete();
    }
}

/**
 * 下标动画
 **/
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!animation.removedOnCompletion) {
        [indicator addAnimation:animation forKey:animation.keyPath];
    } else {
        [indicator addAnimation:animation forKey:animation.keyPath];
        [indicator setValue:animation.values.lastObject forKeyPath:animation.keyPath];
    }
    if (complete) {
        complete();
    }
    
}

/**
 * 文本变化
 **/
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (complete) {
        complete();
    }
}

/**
 * 背景动画
 **/
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    if (complete) {
        complete();
    }
}

/**
 * 显示下拉菜单动画
 */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)())complete {
    
    CGFloat proportion = [_datasource proportionOfWidthInLeftColumn:_currentSelectedIndex];
    
    if (show) {
        CGFloat leftTableViewHeight = 0;
        CGFloat rightTableViewHeight = 0;
        if (leftTableView) {
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*proportion, 0);
            [self.superview addSubview:leftTableView];
            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] > 5) ? (5 * leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight);
        }
        if (rightTableView) {
            rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-proportion), 0);
            [self.superview addSubview:rightTableView];
            rightTableViewHeight = ([rightTableView numberOfRowsInSection:0] > 5) ? (5 * rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight);
        }
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*proportion, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-proportion), tableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*proportion, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-proportion), 0);
            }
            } completion:^(BOOL finished) {
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    if (complete) {
        complete();
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    }
    NSAssert(self.datasource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.datasource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight:leftRow:)]) {
        return [self.datasource menu:self numberOfRowsInColumn:self.currentSelectedIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MenuCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = MenuBackgoundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = self.textColor;
    titleLabel.tag = 1;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cell addSubview:titleLabel];
    
    NSInteger leftOrRight = 0;
    
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    }
    
    CGSize textSize;
    
    if ([self.datasource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        
        titleLabel.text = [self.datasource menu:self titleForRowAtIndexPath:[[XDIndexPath alloc]initWithColumn:self.currentSelectedIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        // 只取宽度
        textSize = [titleLabel.text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (leftOrRight == 1) {
        CGFloat marginX = 20;
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);
        //右边tableview
        cell.backgroundColor = MenuBackgoundColor;
        if ([titleLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedIndex] string]]) {
            
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select.png"]];
            
            accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (self.frame.size.height-12)/2, 16, 12);
            
            [cell addSubview:accessoryImageView];
        }
    } else{
        CGFloat proportion = [_datasource proportionOfWidthInLeftColumn:_currentSelectedIndex];
        CGFloat marginX = (self.frame.size.width*proportion-textSize.width)/2;
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);
        if (!_hadSelected &&_leftSelectedRow == indexPath.row) {
            cell.backgroundColor = MenuBackgoundColor;
            BOOL haveRightTableView = [_datasource haveRightTableInColumn:_currentSelectedIndex];
            if(!haveRightTableView){
                UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select.png"]];
                accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (self.frame.size.height-12)/2, 16, 12);
                [cell addSubview:accessoryImageView];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger leftOrRight = 0;
    if (tableView==_rightTableView) {
        leftOrRight = 1;
    }else{
        _leftSelectedRow = indexPath.row;
    }
  
    if ([self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        BOOL haveRightTable = [_datasource haveRightTableInColumn:_currentSelectedIndex];
        if ((leftOrRight==0&&!haveRightTable)||leftOrRight==1) {
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:leftOrRight];
        }
        
        [self.delegate menu:self didSelectRowAtIndexPath:[[XDIndexPath alloc]initWithColumn:_currentSelectedIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        
        if (leftOrRight==0 && haveRightTable) {
            if (!_hadSelected) {
                _hadSelected = YES;
                [_leftTableView reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
                [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            [_rightTableView reloadData];
        }
    }

}

- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedIndex];
    title.string = [self.datasource menu:self titleForRowAtIndexPath:[[XDIndexPath alloc]initWithColumn:self.currentSelectedIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:row]];
    
    [self animateIdicator:_indicators[_currentSelectedIndex] background:_backgoundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedIndex] setBackgroundColor:MenuBackgoundColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}



@end
