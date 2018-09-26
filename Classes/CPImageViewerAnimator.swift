//
//  BaseViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

public final class CPImageViewerAnimator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    private let animator = CPImageViewerAnimationTransition()
    private let interativeAnimator = CPImageViewerInteractiveTransition()

    // MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let sourceViewer = source as? CPImageViewerProtocol,
            let _ = presenting as? CPImageViewerProtocol,
            let imageViewer = presented as? CPImageViewer {
            if let navi = presenting as? UINavigationController {
                navi.animationImageView = sourceViewer.animationImageView
            } else if let tabBarVC = presenting as? UITabBarController {
                tabBarVC.animationImageView = sourceViewer.animationImageView
            }
            
            interativeAnimator.wireToImageViewer(imageViewer)
            interativeAnimator.isPresented = true
            animator.isBack = false
            return animator
        }
        
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is CPImageViewer {
            animator.isBack = true
            return animator
        }
        
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
    
    // MARK: - UINavigationDelegate
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push,
            fromVC is CPImageViewerProtocol,
            let imageViewer = toVC as? CPImageViewer {
            interativeAnimator.wireToImageViewer(imageViewer)
            interativeAnimator.isPresented = false
            animator.isBack = false
            return animator
        } else if operation == .pop,
            toVC is CPImageViewerProtocol,
            fromVC is CPImageViewer {
            animator.isBack = true
            return animator
        }
        
        return nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
}
