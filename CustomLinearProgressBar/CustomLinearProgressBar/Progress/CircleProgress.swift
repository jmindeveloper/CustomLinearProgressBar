//
//  CircleProgress.swift
//  CustomLinearProgressBar
//
//  Created by J_Min on 2022/11/20.
//

import UIKit
import Combine

final class CircleProgress: UIView {
    
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
        drawTrack()
        drawProgress()
    }
    
    private func setLayers() {
        layer.addSublayer(mainLayer)
        mainLayer.addSublayer(trackLayer)
        trackLayer.masksToBounds = true
    }
    
    private func drawTrack() {
        let radius = CGFloat(min(frame.width, frame.height) / 2)
        trackLayer.frame.size = CGSize(width: radius * 2, height: radius * 2)
        trackLayer.frame.origin = CGPoint(x: (frame.width / 2) - radius, y: (frame.height / 2) - radius)
        let center = CGPoint(x: trackLayer.frame.width / 2, y: trackLayer.frame.height / 2)
        
        trackPath.move(to: center)
        trackPath.addArc(
            withCenter: center,
            radius: radius,
            startAngle: CGFloat(0).toRadian(),
            endAngle: CGFloat(360).toRadian(),
            clockwise: true
        )
        
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.fillColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 0
        trackLayer.cornerRadius = trackLayer.frame.width / 2
        mainLayer.addSublayer(trackLayer)
    }
    
    private func drawProgress() {
        let height = frame.height
        let radius = CGFloat(min(frame.width, frame.height) / 2)
        let center = CGPoint(x: trackLayer.frame.width / 2, y: trackLayer.frame.height / 2)
        let start = CGPoint(x: center.x - radius, y: center.y)
        
        progressPath.move(to: start)
        progressPath.addLine(to: CGPoint(x: start.x + radius * 2, y: start.y))
        
        progressLayer.frame = CGRect(x: 0, y: 0, width: trackLayer.frame.width, height: trackLayer.frame.height)
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = height
        
        trackLayer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 0
    }
    
    func startAnimation(to toValue: CGFloat) {
        progressLayer.strokeEnd = toValue
        print(toValue)
        if toValue >= 1 {
            finishProgressPublisher.send()
        }
    }
}
