//
//  CVPopAnimation.swift
//  CVFullScreenPopAnimation
//
//  Created by caven on 2018/10/12.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        if fromVC == nil || toVC == nil {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromVC!.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
    
}
