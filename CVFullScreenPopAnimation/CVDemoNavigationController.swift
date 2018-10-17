//
//  CVDemoNavigationController.swift
//  CVFullScreenPopAnimation
//
//  Created by caven on 2018/10/12.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class CVDemoNavigationController: UINavigationController {

    var navTransition: CVNavigationInteractiveTransition!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 禁止系统的侧滑手势
        self.interactivePopGestureRecognizer?.isEnabled = false
        let gestureView = self.interactivePopGestureRecognizer?.view
        
        self.navTransition = CVNavigationInteractiveTransition(navigationController: self)
        
        let popRecognizer = UIPanGestureRecognizer.init(target: self.navTransition, action: #selector(handleControllerPop(_:)))
        popRecognizer.delegate = self
        popRecognizer.maximumNumberOfTouches = 1
        gestureView?.addGestureRecognizer(popRecognizer)
    }
    
    /// 侧滑手势，这里不会调用，写这个方法只是为了不报错
    @objc func handleControllerPop(_ gesture: UIPanGestureRecognizer) {
        
    }
    
}


extension CVDemoNavigationController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
        return self.viewControllers.count != 1 && !(self.value(forKey: "_isTransitioning") as! Bool)
    }
}
