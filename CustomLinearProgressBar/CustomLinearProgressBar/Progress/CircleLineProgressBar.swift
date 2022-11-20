//
//  CircleLineProgressBar.swift
//  CustomLinearProgressBar
//
//  Created by J_Min on 2022/11/20.
//

import UIKit
import Combine

final class CircleLineProgressBar: UIView {
    var circleProgressCount = 5
    private var circleProgressBars: [(CircleProgress, Bool)] = []
    private var lineProgressBars: [(LineProgress, Bool)] = []
    private var isFirstDraw: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    
    private var progressOffset: CGFloat {
        return 1 / CGFloat(circleProgressCount)
    }
    
    private var currentCircleProgress: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstDraw && frame != .zero {
            let circleRects = calculateCircleProgressRect()
            let lineRects = calculateLineProgressRect(circleRects: circleRects)
            drawLineProgress(rects: lineRects)
            drawCircleProgress(rects: circleRects)
            isFirstDraw = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bindingCircleProgressBar() {
        circleProgressBars.enumerated().forEach { index, value in
            value.0.finishProgressPublisher
                .sink { [weak self] in
                    guard let self = self else { return }
                    self.currentCircleProgress = 0
                    self.circleProgressBars[index].1 = false
                    if self.circleProgressBars.count - 1 > index {
                        self.updateLineProgress()
                        self.circleProgressBars[index + 1].1 = true
                    } else {
                        print("모든 진행률 끝남ㅋ")
                    }
                }.store(in: &subscriptions)
        }
    }
    
    private func bindingLineProgressBar() {
        lineProgressBars.enumerated().forEach { index, value in
            value.0.finishProgressPublisher
                .sink { [weak self] in
                    guard let self = self else { return}
                    self.lineProgressBars[index].1 = false
                    if self.lineProgressBars.count - 1 > index {
                        self.lineProgressBars[index + 1].1 = true
                    }
                }.store(in: &subscriptions)
        }
    }
    
    private func calculateCircleProgressRect() -> [CGRect] {
        let size = min(frame.width, frame.height)
        let radius = size / 2
        let offset = (frame.width - radius * 2) / CGFloat(circleProgressCount - 1)
        var rects: [CGRect] = [CGRect(x: 0, y: 0, width: size, height: size)]
        for i in 1..<circleProgressCount {
            let point = CGRect(x: rects[i - 1].origin.x + offset, y: 0, width: size, height: size)
            rects.append(point)
        }
        
        return rects
    }
    
    private func drawCircleProgress(rects: [CGRect]) {
        for rect in rects {
            let circleProgress = CircleProgress()
            circleProgress.frame = rect
            addSubview(circleProgress)
            self.circleProgressBars.append((circleProgress, false))
        }
        circleProgressBars[0].1 = true
        bindingCircleProgressBar()
    }
    
    private func calculateLineProgressRect(circleRects: [CGRect]) -> [CGRect] {
        var rects: [CGRect] = []
        
        for i in 1..<circleRects.count {
            let beforeCircleRect = circleRects[i - 1]
            let circleRect = circleRects[i]
            let origin = CGPoint(x: beforeCircleRect.maxX - 1, y: 0)
            let width = circleRect.minX - origin.x + 1
            rects.append(CGRect(x: origin.x, y: origin.y, width: width, height: frame.height))
        }
        
        return rects
    }
    
    private func drawLineProgress(rects: [CGRect]) {
        for rect in rects {
            let lineProgress = LineProgress()
            lineProgress.frame = rect
            addSubview(lineProgress)
            self.lineProgressBars.append((lineProgress, false))
        }
        lineProgressBars[0].1 = true
        bindingLineProgressBar()
    }
    
    func updateCircleProgress() {
        currentCircleProgress += progressOffset
        if currentCircleProgress > 1 {
            currentCircleProgress = 1
        }
        
        print(currentCircleProgress)
        
        circleProgressBars.forEach {
            if $0.1 {
                $0.0.startAnimation(to: currentCircleProgress)
            }
        }
    }
    
    func updateLineProgress() {
        lineProgressBars.forEach { lineProgress in
            if lineProgress.1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    lineProgress.0.startAnimation(duration: 1)
                }
            }
        }
    }
}
