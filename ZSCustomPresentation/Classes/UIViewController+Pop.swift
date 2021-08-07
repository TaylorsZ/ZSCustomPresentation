//
//  UIViewController+Pop.swift
//  Poppy
//
//  Created by Taylor on 2020/4/17.
//  Copyright © 2020 Taylor. All rights reserved.
//

import UIKit

/// 弹出位置
public enum PresentPosition {
    case top
    case right
    case bottom
    case left
    case center
    case custom
}

extension UIViewController {
    
    private struct AssociateKeys {
        static var popAnimatorKey: Void?
    }
    
    var popAnimator: PopTransitionPresentAnimator?{
        
        get{
            return objc_getAssociatedObject(self, &AssociateKeys.popAnimatorKey) as? PopTransitionPresentAnimator
        }
        set{
            objc_setAssociatedObject(self, &AssociateKeys.popAnimatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 在指定的屏幕位置弹出控制器
    /// - Parameters:
    ///   - viewControllerToPresent: 要弹出的controller
    ///   - frame: 视图位置大小
    ///   - maskLayer: 是否有蒙版遮盖
    ///   - touchCancle: 点击蒙版是否能自动关闭页面
    ///   - flag: 是否动画过渡
    ///   - location: 展现的位置
    ///   - completion: 完成回调
    public func present(_ viewControllerToPresent: UIViewController,location:PresentPosition,frame:CGRect ,maskLayer:Bool? = true,touchCancle:Bool? = true,animated flag:Bool, completion: (() -> Void)?) {
       
        let popAnimator = PopTransitionPresentAnimator(frame: frame, mask: maskLayer, isTouchCancle: touchCancle, type: location);
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.transitioningDelegate = popAnimator
        self.popAnimator = popAnimator;
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
