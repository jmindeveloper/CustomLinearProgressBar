//
//  LineProgress.swift
//  CustomLinearProgressBar
//
//  Created by J_Min on 2022/11/20.
//

import UIKit
import Combine

final class LineProgress: UIView {
    
    private let mainLayer = CALayer()
    private let trackLayer = CAShapeLayer()
    private let trackPath = UIBezierPath()
    private let progressPath = UIBezierPath()
    private let progressLayer = CAShapeLayer()
    
    let finishProgressPublisher = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        trackLayer.frame = mainLayer.frame
        progressLayer.frame = trackLayer.frame
        drawTrack()
        drawProgress()
    }
    
    private func setLayers() {
        layer.addSublayer(mainLayer)
        mainLayer.addSublayer(trackLayer)
        trackLayer.masksToBounds = true
    }
    
    private func drawTrack() {
        let height: CGFloat = 7
        let start = CGPoint(x: bounds.origin.x, y: bounds.height / 2)
        
        trackPath.move(to: start)
        trackPath.addLine(to: CGPoint(x: frame.width, y: start.y))
        
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = height
        mainLayer.addSublayer(trackLayer)
    }
    
    private func drawProgress() {
        let height: CGFloat = 7
        let start = CGPoint(x: bounds.origin.x, y: bounds.height / 2)
        
        progressPath.move(to: start)
        progressPath.addLine(to: CGPoint(x: frame.width, y: start.y))
        
        progressLayer.path = trackPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = height
        trackLayer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 0
    }
    
    func startAnimation(duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        
        progressLayer.add(animation, forKey: "lineAnimation")
    }
}

extension LineProgress: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        progressLayer.actions = ["strokeEnd": NSNull()]
        progressLayer.strokeEnd = 1
        progressLayer.removeAllAnimations()
        finishProgressPublisher.send()
    }
}
