//
//  ViewController.swift
//  Animation
//
//  Created by CXY on 2017/6/22.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var circle: UITextView!
    lazy var animator = UIViewPropertyAnimator()
    override func viewDidLoad() {
        super.viewDidLoad()
        circle.layer.cornerRadius = 0
        interactAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 1. UIView-based Animations
    // UIViewPropertyAnimator :Features Custom timing Interactive Interruptible Responsive 除了线性、渐进、进出，还可以自定义时间曲线
    func uiviewPropertyAnimator() {
        // UIViewPropertyAnimator iOS10 later
//        let animator = UIViewPropertyAnimator(duration: 2, curve: .linear) {
//            self.circle.frame = self.circle.frame.offsetBy(dx: 100, dy: 0)
//        }
//        animator.startAnimation()
        
        //自定义时间曲线
        let para = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.75, y: 0.1),
                                controlPoint2: CGPoint(x: 0.9, y: 0.25))
        let animator = UIViewPropertyAnimator(duration: 2, timingParameters: para)
        animator.addAnimations {
            self.circle.frame = self.circle.frame.offsetBy(dx: 100, dy: 0)
        }
        animator.startAnimation()
    }
    
    // 2. 动画交互
    func interactAnimation() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        circle.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
                self.circle.frame = self.circle.frame.offsetBy(dx: 0, dy: -200)
            })
            animator.pauseAnimation()
            self.circle.layer.cornerRadius = 0
        case .changed:
            let translation = recognizer.translation(in: circle)
            animator.fractionComplete = translation.y / 200
        case .ended:
            //自定义时间曲线
//            let para = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.3, y: 0.5),
//                                               controlPoint2: CGPoint(x: 0.9, y: 0.6))
            let para = UICubicTimingParameters(animationCurve: .easeOut)
            animator.continueAnimation(withTimingParameters: para, durationFactor: 0)
            animateCornerRadius()
        default:
            break
        }
    }
    // 3.中断动画
    func interruptAnimation() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan1))
        circle.addGestureRecognizer(pan)
    }
    
    func animateTransitionIfNeeded(duration: TimeInterval) { }
    var progressWhenInterrupted: CGFloat = 0
    
    @objc func handlePan1(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(duration: 1)
            animator.pauseAnimation()
            progressWhenInterrupted = animator.fractionComplete
        case .changed:
            let translation = recognizer.translation(in: circle)
            animator.fractionComplete = (translation.x / 100) + progressWhenInterrupted
        case .ended:
            let timing = UICubicTimingParameters(animationCurve: .easeOut)
            animator.continueAnimation(withTimingParameters: timing, durationFactor: 0)
        default:
            break
        }
    }
    
    // iOS11新属性
//    var scrubsLinearly: Bool
//    var pausesOnCompletion: Bool 设置 animator.pausesOnCompletion = true，后动画完成后动画状态仍然是active
//    ????
//    Starting as Paused
//    NEW
//
//    let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn)
//    animator.startAnimation()
//    // ...
//    animator.addAnimations {
//    // will run immediately
//    circle.frame = circle.frame.offsetBy(dx: 100, dy: 0)
//    }
//    No escaping for animation blocks
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        uiviewPropertyAnimator()
//        animateCornerRadius()
    }
    
    // Spring Animations 阻尼系数
    // Best Practices When Interrupting Springs
//    Stop and create a new property animator
//    Use critically damped spring without velocity
//    Decompose component velocity with multiple animators
    
    //•Coordinating Animations
    
    // Tracks all running animators
//    var runningAnimators = [UIViewPropertyAnimator]()
//
//    // Perform all animations with animators if not already running
//    func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
//        if runningAnimators.isEmpty {
//            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
//                switch state {
//                case .Expanded:
//                    self.control.frame = CGRect(...)
//                case .Collapsed:
//                    self.control.frame = CGRect(...)
//                }
//            }
//            frameAnimator.startAnimation()
//            runningAnimators.append(frameAnimator)
//        }
//    }
//
//    // Starts transition if necessary or reverses it on tap
//    func animateOrReverseRunningTransition(state: State, duration: TimeInterval) {
//        if runningAnimators.isEmpty {
//            animateTransitionIfNeeded(state: state, duration: duration)
//        } else {
//            for animator in runningAnimators {
//                animator.isReversed = !animator.isReversed
//            } }
//    }
//
//    // Tracks all running animators
//    var runningAnimators = [UIViewPropertyAnimator]()
//    // Perform all animations with animators if not already running
//    func animateTransitionIfNeeded(state: State, duration: TimeInterval) { ... }
//    // Starts transition if necessary or reverses it on tap
//    func animateOrReverseRunningTransition(state: State, duration: TimeInterval) { ... }
//    // Starts transition if necessary and pauses on pan .begin
//    func startInteractiveTransition(state: State, duration: TimeInterval) { ... }
//    // Scrubs transition on pan .changed
//    func updateInteractiveTransition(fractionComplete: CGFloat) { ... }
//    // Continues or reverse transition on pan .ended
//    func continueInteractiveTransition(cancel: Bool) { ... }
    
    
//    let view = UIVisualEffectView()
    
    // Animating Corner Radius ,Now animatable in UIKit iOS 11
    func animateCornerRadius() {
        circle.clipsToBounds = true
        UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.circle.layer.cornerRadius = 25
            }.startAnimation()
        
//        circle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // Keyframe Animations
//    func animateTransitionIfNeeded(forState state: State, duration: TimeInterval) { // ...
//        let buttonAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
//            switch state { case .Expanded:
//                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) { // Start with delay and finish with rest of animations detailsButton.alpha = 1
//                })
//            case .Collapsed:
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) { // Start immediately and finish in half the time detailsButton.alpha = 0
//                }) }
//        }, completion: nil) }
//    }
    
    // Additively Animatable Properties
    
//    var transform: CGAffineTransform  // affine only
//    var frame: CGRect
//    var bounds: CGRect
//    var center: CGPoint
//    var position: CGPoint
    func additivelyAnimatableProperties() {
        let animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut, animations: { for _ in 0..<20 {
            let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.circle.transform = self.circle.transform.concatenating(rotation) }
        })
        animator.startAnimation()
    }
    
    
    
}


