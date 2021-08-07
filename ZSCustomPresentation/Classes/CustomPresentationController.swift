//
//  CustomPresentationController.swift
//  Poppy
//
//  Created by Taylor on 2020/4/17.
//  Copyright © 2020 Taylor. All rights reserved.
//

import Foundation
import UIKit

class CustomPresentationController: UIPresentationController {
    
    /// 弹出的视图位置大小
    var presentedRect:CGRect = .zero
    /// 是否点击蒙版取消
    var isTouchCancle:Bool?
    /// 是否存在蒙版
    var isMask:Bool?;
    /// 弹出的位置方式
    var position:PresentPosition = .bottom;
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        guard let containerV = self.containerView else {
            return
        }
        let superFrame = containerV.frame;
        switch position {
        case .bottom:
            
            let frame = CGRect(x: 0, y: superFrame.height - presentedRect.height, width: presentedRect.width, height: presentedRect.height)
            presentedView?.frame = frame
            presentedView?.center.x = containerV.center.x;
            break;
        case .left:
            let frame = CGRect(x: 0, y:0, width: presentedRect.width, height: presentedRect.height)
            presentedView?.frame = frame
            presentedView?.center.y = containerV.center.y;
            break;
            
        case .right:
            let x = (superFrame.width - presentedRect.width);
            let frame = CGRect(x: x, y: presentedRect.origin.y, width: presentedRect.width, height: presentedRect.height)
            presentedView?.frame = frame
//            presentedView?.center.y = containerV.center.y;
            
            break;
        case .top:
            
            let frame = CGRect(x: 0, y: 0, width: presentedRect.width, height: presentedRect.height)
            presentedView?.frame = frame
            presentedView?.center.x = containerV.center.x;
            
            break;
        case .center:
            
            let frame = CGRect(x: 0, y: 0, width: presentedRect.width, height: presentedRect.height)
            presentedView?.frame = frame
            presentedView?.center = containerV.center;
            
            break;
        case .custom:
          
            presentedView?.frame = presentedRect
            presentedView?.center = containerV.center;
            break;
        }
        
        guard isMask == true else {
            return;
        }
        containerView?.insertSubview(coverView, at: 0);
        guard isTouchCancle == true else {
            return;
        }
        coverView.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    @objc private func dismiss(_ sender:UIButton) {
        presentedViewController.dismiss(animated: true) {}
    }
    lazy var coverView :UIButton = {
        let view = UIButton(type: .custom)
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2);
        return view
    }()
}
