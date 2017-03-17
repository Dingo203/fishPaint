//
//  fishPaint.swift
//  fishPaint
//
//  Created by 蒋永翔 on 17/3/17.
//  Copyright © 2017年 dingo. All rights reserved.
//

import UIKit

/// fishPaintView Delegate

public protocol fishPaintViewDelegate {
    
    /**
     fishPaintViewDelegate called when a touch gesture begins on the fishPaintView.
     */
    
    func fishPaintDidBeginDrawing(view: fishPaintView)
    
    /**
     fishPaintViewDelegate called when touch gestures continue on the fishPaintView.
     */
    
    func fishPaintIsDrawing(view: fishPaintView)
    
    /**
     fishPaintViewDelegate called when touches gestures finish on the fishPaintView.
     */
    
    func fishPaintDidFinishDrawing(view: fishPaintView)
    
    /**
     fishPaintViewDelegate called when there is an issue registering touch gestures on the  fishPaintView.
     */
    
    func fishPaintDidCancelDrawing(view: fishPaintView)
}

extension fishPaintViewDelegate {
    
    func fishPaintDidBeginDrawing(view: fishPaintView) {
        //optional
    }
    
    func fishPaintIsDrawing(view: fishPaintView) {
        //optional
    }
    
    func fishPaintDidFinishDrawing(view: fishPaintView) {
        //optional
    }
    
    func fishPaintDidCancelDrawing(view: fishPaintView) {
        //optional
    }
}

/// touch gestures happen at fishPaintView are translated into Core Graphics drawing

open class fishPaintView: UIView {
    
    /// Line color for current drawing strokes
    public var lineColor              : UIColor   = UIColor.black
    
    /// Line width for current drawing strokes
    public var lineWidth              : CGFloat   = 10.0
    
    /// Line opacity for current drawing strokes
    public var lineOpacity            : CGFloat   = 1.0
    
    /// Sets whether touch gestures should be registered as drawing strokes on the current canvas
    public var drawingEnabled         : Bool      = true
    
    /// fishPaintView delegate
    public var delegate               : fishPaintViewDelegate?
    
    private var pathArray             : [Line]    = []
    private var currentPoint          : CGPoint   = CGPoint()
    private var previousPoint         : CGPoint   = CGPoint()
    private var previousPreviousPoint : CGPoint   = CGPoint()
    
    private struct Line {
        var path    : CGMutablePath
        var color   : UIColor
        var width   : CGFloat
        var opacity : CGFloat
        
        init(path : CGMutablePath, color: UIColor, width: CGFloat, opacity: CGFloat) {
            self.path    = path
            self.color   = color
            self.width   = width
            self.opacity = opacity
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    /// Overriding draw(rect:) to stroke paths
    
    override open func draw(_ rect: CGRect) {
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        
        for line in pathArray {
            context.setLineWidth(line.width)
            context.setAlpha(line.opacity)
            context.setStrokeColor(line.color.cgColor)
            context.addPath(line.path)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            context.strokePath()
            context.endTransparencyLayer()
        }
    }
    
    /******************************** touches method to modify view ******************************/
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if not allow to draw, return
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.fishPaintDidBeginDrawing(view: self)
        if let touch = touches.first as UITouch! {
            setTouchPoints(touch, view: self)
            let newLine = Line(path: CGMutablePath(), color: self.lineColor, width: self.lineWidth, opacity: self.lineOpacity)
            newLine.path.addPath(createNewPath())
            pathArray.append(newLine)
        }

    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.fishPaintIsDrawing(view: self)
        if let touch = touches.first as UITouch! {
            updateTouchPoints(touch, view: self)
            let newLine = createNewPath()
            if let currentPath = pathArray.last {
                currentPath.path.addPath(newLine)
            }
        }
    }
   
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.fishPaintDidFinishDrawing(view: self)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawingEnabled == true else {
            return
        }
        
        self.delegate?.fishPaintDidCancelDrawing(view: self)
    }
    
    /// Remove last stroked line
    
    public func removeLastLine() {
        if pathArray.count > 0 {
            pathArray.removeLast()
        }
        setNeedsDisplay()
    }
    
    /// Clear all stroked lines on canvas
    
    public func clearCanvas() {
        pathArray = []
        setNeedsDisplay()
    }
    
    /********************************** Private Functions **********************************/
    
    private func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        previousPreviousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func updateTouchPoints(_ touch: UITouch,view: UIView) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    private func createNewPath() -> CGMutablePath {
        let midPoints = getMidPoints()
        let subPath = createSubPath(midPoints.0, mid2: midPoints.1)
        let newPath = addSubPathToPath(subPath)
        return newPath
    }
    
    private func calculateMidPoint(_ p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5);
    }
    
    private func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = calculateMidPoint(previousPoint, p2: previousPreviousPoint)
        let mid2 : CGPoint = calculateMidPoint(currentPoint, p2: previousPoint)
        return (mid1, mid2)
    }
    
    private func createSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint.x, y: previousPoint.y))
        return subpath
    }
    
    private func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * lineWidth, dy: -2.0 * lineWidth)
        self.setNeedsDisplay(drawBox)
        return subpath
    }
}
