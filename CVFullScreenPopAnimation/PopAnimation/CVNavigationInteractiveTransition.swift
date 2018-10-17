//
//  CVNavigationInteractiveTransition.swift
//  CVFullScreenPopAnimation
//
//  Created by caven on 2018/10/12.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVNavigationInteractiveTransition: NSObject, UINavigationControllerDelegate {

    var navigationController: UINavigationController!
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    
    convenience init(navigationController: UINavigationController) {
        self.init()
        self.navigationController = navigationController
        self.navigationController.delegate = self
    }
 
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 判断如果当前执行的是Pop操作，就返回我们自定义的Pop动画对象
        if operation == .pop {
            return CVPopAnimation()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: CVPopAnimation.self) {
            return self.interactivePopTransition
        }
        return nil
    }
    
    /// 侧滑手势
    @objc func handleControllerPop(_ gesture: UIPanGestureRecognizer) {
        
        // interactivePopTransition 我们需要更新它的进度来控制Pop动画的流程，我们用手指在视图中的位置与视图宽度比例作为它的进度
        var progress: CGFloat = gesture.translation(in: gesture.view).x / gesture.view!.bounds.width
        // 稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
        progress = min(1.0, max(0.0, progress))
        
        if gesture.state == .began {
            // 手势开始，新建一个监控对象
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController.popViewController(animated: true)
            
        } else if gesture.state == .changed {
            // 更新手势的完成进度
            self.interactivePopTransition?.update(progress)
        } else if gesture.state == .cancelled || gesture.state == .ended {
            // 手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过
            if (progress > 0.5) {
                self.interactivePopTransition!.finish()
            }
            else {
                self.interactivePopTransition!.cancel()
            }
            
            self.interactivePopTransition = nil
        }
    }
}
