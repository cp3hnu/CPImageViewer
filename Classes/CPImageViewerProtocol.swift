//
//  CPImageViewerProtocol.swift
//  CPImageViewer
//
//  Created by CP3 on 16/5/12.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import ObjectiveC

public protocol CPImageViewerProtocol {
    /// The animation imageView
    var animationImageView: UIImageView? { get }
    
    /// The frame of animationImageView
    var originalFrame: CGRect? { get }
}

public extension CPImageViewerProtocol {
    var originalFrame: CGRect? {
        return nil
    }
}

//http://stackoverflow.com/questions/24133058/is-there-a-way-to-set-associated-objects-in-swift/24133626#24133626
//http://nshipster.cn/swift-objc-runtime/

extension UINavigationController: CPImageViewerProtocol {
    private struct AssociatedKeys {
        static var animationImageViewKey = "animationImageView_key"
        static var originalFrameKey = "originalFrame_key"
    }
    
    /// The animation imageView conforming to `CPImageViewerProtocol`
    public var animationImageView: UIImageView? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.animationImageViewKey) as? UIImageView)
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.animationImageViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// The animation imageView conforming to `CPImageViewerProtocol`
    public var originalFrame: CGRect? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.originalFrameKey) as? CGRect)
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.originalFrameKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UITabBarController: CPImageViewerProtocol {
    private struct AssociatedKeys {
        static var animationImageViewKey = "animationImageView_key"
        static var originalFrameKey = "originalFrame_key"
    }
    
    /// The animation imageView conforming to `CPImageViewerProtocol`
    public var animationImageView: UIImageView? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.animationImageViewKey) as? UIImageView)
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.animationImageViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// The animation imageView conforming to `CPImageViewerProtocol`
    public var originalFrame: CGRect? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.originalFrameKey) as? CGRect)
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.originalFrameKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
