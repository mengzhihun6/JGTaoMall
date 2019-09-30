//
//  UIViewExtension.swift
//  U17
//
//  Created by charles on 2017/11/13.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit

extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}


// UIView 渐变色 , UIView及其子类都可以使用，比如UIButton、UILabel等。
//
// Usage:
// myButton.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor(hex: "#FF2619").cgColor, UIColor(hex: "#FF8030").cgColor])
public extension UIView {
    
    // MARK: 添加渐变色图层
    func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        
        var gradientLayer: CAGradientLayer!
        
        removeGradientLayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        self.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}


extension UIView {
    
    ///MARK: 实现虚线功能
    func addBorderDottedLinewithColor(color:UIColor)  {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        
        shapeLayer.position = CGPoint(x: self.frame.width / 2, y: 0)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 1)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

///MARK - Frame扩展
///在使用UIView的时候，经常会对视图的位置、长度、宽度进行更改，针对常用的一些类做了一些扩展。
extension UIView{
    
    public var JG_X:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r  = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var JG_Y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var JG_W:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    
    public var JG_H:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    public var JG_rightX:CGFloat{
        get{
            return self.JG_X + self.JG_W
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    
    public var JG_bottomY:CGFloat{
        get{
            return self.JG_Y + self.JG_H
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var JG_CenterX:CGFloat{
        get{
            return self.center.x
        }
        set
        {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var JG_CenterY :CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x:self.center.x,y:newValue)
        }
    }
    
    public var JG_origin:CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.JG_X = newValue.x
            self.JG_Y = newValue.y
        }
    }
    
    public var JG_size:CGSize{
        get{
            return self.frame.size
        }
        set{
            self.JG_W = newValue.width
            self.JG_H = newValue.height
        }
    }
    
}
