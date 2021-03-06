/*
 *     Created by cacaodev@gmail.com.
 *     Copyright (c) 2011 Pear, Inc. All rights reserved.
 */

@import "CPPopUpButton.j"

var GRADIENT_START_COLOR = "#fcfcfc",
    GRADIENT_END_COLOR = "#dfdfdf",
    BORDER_COLOR = "#BDBDBD";

var GRADIENT_NORMAL,
    GRADIENT_HIGHLIGHTED,
    GRADIENT_PROPERTY;

if (CPBrowserIsEngine(CPWebKitBrowserEngine))
{
    GRADIENT_NORMAL = "-webkit-gradient(linear, left top, left bottom, from(" + GRADIENT_START_COLOR + "), to(" + GRADIENT_END_COLOR + "))",
    GRADIENT_HIGHLIGHTED = "-webkit-gradient(linear, left top, left bottom, from(" + GRADIENT_END_COLOR + "), to(" + GRADIENT_START_COLOR + "))";
    GRADIENT_PROPERTY = "background";
}
else if (CPBrowserIsEngine(CPGeckoBrowserEngine))
{
    GRADIENT_NORMAL = "-moz-linear-gradient(top, " + GRADIENT_START_COLOR + ", " + GRADIENT_END_COLOR + ")",
    GRADIENT_HIGHLIGHTED = "-moz-linear-gradient(top, " + GRADIENT_END_COLOR + ", " + GRADIENT_START_COLOR + ")";
    GRADIENT_PROPERTY = "background";
}
else if (CPBrowserIsEngine(CPInternetExplorerBrowserEngine))
{
    GRADIENT_NORMAL = "progid:DXImageTransform.Microsoft.gradient(startColorstr='" + GRADIENT_START_COLOR + "', endColorstr='" + GRADIENT_END_COLOR + "')";
    GRADIENT_HIGHLIGHTED = "progid:DXImageTransform.Microsoft.gradient(startColorstr='" + GRADIENT_END_COLOR + "', endColorstr='" + GRADIENT_START_COLOR + "')";
    GRADIENT_PROPERTY = "filter";
}else
{
    GRADIENT_NORMAL = GRADIENT_START_COLOR;
    GRADIENT_HIGHLIGHTED = GRADIENT_END_COLOR;
    GRADIENT_PROPERTY = "background";
}

@implementation _CPRuleEditorPopUpButton : CPPopUpButton
{
    CPInteger radius;
}

- (void)_sharedInit
{
    [self setBordered:NO];

    var style = _DOMElement.style;
    style.border = "1px solid " + BORDER_COLOR;
    style[GRADIENT_PROPERTY] = GRADIENT_NORMAL;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
        [self _sharedInit];

    return self;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    [self _sharedInit];

    return self;
}

- (id)hitTest:(CPPoint)point
{
    if (!CPRectContainsPoint([self frame], point) || ![self sliceIsEditable])
        return nil;

    return self;
}

- (BOOL)sliceIsEditable
{
    var superview = [self superview];
    return ![superview isKindOfClass:[_CPRuleEditorViewSlice]] || [superview isEditable];
}

- (BOOL)trackMouse:(CPEvent)theEvent
{
    if (![self sliceIsEditable])
        return NO;

    return [super trackMouse:theEvent];
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    var contentRect = [super contentRectForBounds:bounds];
    contentRect.origin.x += radius;
    contentRect.size.width -= 2 * radius;

    return contentRect;
}

- (void)layoutSubviews
{
    radius = FLOOR(CGRectGetHeight([self bounds]) / 2);
    var style = _DOMElement.style,
        radiusCSS = radius + "px";

    style.borderRadius = radiusCSS;

    [super layoutSubviews];
}

- (void)drawRect:(CGRect)aRect
{
    var context = [[CPGraphicsContext currentContext] graphicsPort],
        bounds = [self bounds],
        arrow_width = FLOOR(CGRectGetHeight(bounds) / 3.5);

    CGContextTranslateCTM(context, CGRectGetWidth(bounds) - radius - arrow_width, CGRectGetHeight(bounds) / 2);

    var arrowsPath = [CPBezierPath bezierPath];
    [arrowsPath moveToPoint:CGPointMake(0, 1)];
    [arrowsPath lineToPoint:CGPointMake(arrow_width, 1)];
    [arrowsPath lineToPoint:CGPointMake(arrow_width / 2, arrow_width + 1)];
    [arrowsPath closePath];

    CGContextSetFillColor(context, [CPColor colorWithWhite:101 / 255 alpha:1]);
    [arrowsPath fill];

    CGContextScaleCTM(context, 1 , -1);
    [arrowsPath fill];
}

@end

@implementation _CPRuleEditorButton : CPButton
{
    CPInteger radius;
}

- (void)_sharedInit
{
    [self setBordered:NO];

    var style = _DOMElement.style;
    style.border = "1px solid " + BORDER_COLOR;
    style[GRADIENT_PROPERTY] = GRADIENT_NORMAL;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
        [self _sharedInit];

    return self;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    [self _sharedInit];

    return self;
}

- (void)layoutSubviews
{
    radius = FLOOR(CGRectGetHeight([self bounds]) / 2);

    var style = _DOMElement.style,
        radiusCSS = radius + "px";

    style.borderRadius = radiusCSS;
    style[GRADIENT_PROPERTY] = ([self isHighlighted]) ? GRADIENT_HIGHLIGHTED : GRADIENT_NORMAL;

    [super layoutSubviews];
}

@end
