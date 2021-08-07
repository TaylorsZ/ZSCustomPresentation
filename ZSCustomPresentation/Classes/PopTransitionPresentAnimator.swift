//
//  PopTransitionPresentAnimator.swift
//  Poppy
//
//  Created by Taylor on 2020/4/17.
//  Copyright © 2020 Taylor. All rights reserved.
//

import Foundation
import UIKit
import ZSExtensionSwift

class PopTransitionPresentAnimator: NSObject,UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate {
    /// 是否已经弹出页面
    private var isPresent = false
    var popRect:CGRect = CGRect.zero
    var position:PresentPosition = .bottom
    
    var presentationController:CustomPresentationController?
    private let kPopTransitionPresenDuration:TimeInterval = 0.3
    var isTouchCancle:Bool?
    var isMask:Bool?;
    
    var presentedViewController:UIViewController?;

    
    
    init(frame:CGRect,mask:Bool? = true,isTouchCancle:Bool? = true,type:PresentPosition) {
        self.popRect = frame;
        self.isMask = mask;
        self.position = type;
        self.isTouchCancle = isTouchCancle;
        super.init();
        
//        presentationController?.coverView.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside);
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedRect = popRect
        presentation.position = position
        presentation.isTouchCancle = isTouchCancle
        presentation.isMask = isMask;
        presentationController = presentation
       
        return presentation
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    // MARK: - *************** UIViewControllerAnimatedTransitioningDelegate ***************
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kPopTransitionPresenDuration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            animationForPresentedView(transitionContext: transitionContext)
        }else{
            animationForDismissedView(transitionContext: transitionContext)
        }
        
    }
    
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning)  {
        
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        let containerView =  transitionContext.containerView
        containerView.addSubview(presentedView)
        
       
        
        
        switch position {
        case .left:
            self.presentationController?.coverView.alpha = 0
            let frameStart = presentedView.frame;
            presentedView.frame = CGRect(x: frameStart.origin.x - frameStart.size.width, y: frameStart.origin.y, width: frameStart.width, height: frameStart.height);
            UIView.animate(withDuration: kPopTransitionPresenDuration * 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                self.presentationController?.coverView.alpha = 1.0
                presentedView.frame = frameStart;
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
            }
            break;
        case .bottom:
            
            self.presentationController?.coverView.alpha = 0
            self.presentationController?.presentedView?.alpha = 0
            presentedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            UIView.animate(withDuration: kPopTransitionPresenDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.presentationController?.coverView.alpha = 1.0
                presentedView.alpha = 1.0;
                presentedView.transform = CGAffineTransform.identity
            }) { (finished) in
                transitionContext.completeTransition(true)
            }
            break;
        case .right:
            
            self.presentationController?.coverView.alpha = 0
            let frameStart = presentedView.frame;
            presentedView.frame = CGRect(x: frameStart.origin.x + frameStart.size.width, y: frameStart.origin.y, width: frameStart.width, height: frameStart.height);
            UIView.animate(withDuration: kPopTransitionPresenDuration * 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                self.presentationController?.coverView.alpha = 1.0
                presentedView.frame = frameStart;
            }completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            break;
        default:
            // 设置阴影
            containerView.layer.shadowColor = UIColor.black.cgColor;
            containerView.layer.shadowOffset = CGSize.init(width: 0, height: 5);
            containerView.layer.shadowOpacity = 0.5;
            containerView.layer.shadowRadius = 10.0;
            self.presentationController?.coverView.alpha = 0
            self.presentationController?.presentedView?.alpha = 0
            presentedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            UIView.animate(withDuration: kPopTransitionPresenDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.presentationController?.coverView.alpha = 1.0
                presentedView.alpha = 1.0;
                presentedView.transform = CGAffineTransform.identity
            }) { (finished) in
                transitionContext.completeTransition(true)
            }
            break;
        }
        
    }
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning)  {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
      
        UIView.animate(withDuration: kPopTransitionPresenDuration, animations: {
            self.presentationController?.coverView.alpha = 0
            let frame = presentedView.frame;
            switch self.position{
            case .right:
               
                presentedView.frame = CGRect(x: frame.minX + frame.size.width, y: frame.minY, width: frame.size.width, height: frame.size.height);
                break;
            case .left :
                presentedView.frame = CGRect(x: frame.minX - frame.size.width, y: frame.minY, width: frame.size.width, height: frame.size.height);
                break;
            default:
                break;
            }
            
        }) { (finished) in
            self.presentationController = nil;
            self.popRect = CGRect.zero;
            presentedView.removeFromSuperview()
            self.presentationController?.coverView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }    
}
