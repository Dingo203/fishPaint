//
//  ViewController.swift
//  fishPaint
//
//  Created by 蒋永翔 on 17/3/17.
//  Copyright © 2017年 dingo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, fishPaintViewDelegate {

    var paintView : fishPaintView!
    var colorButton : UIButton!
    var undoButton : UIButton!
    var clearButton : UIButton!
    var opacitySlider : UISlider!
    var lineWidthSlider : UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintView = fishPaintView.init(frame: self.view.frame)
        paintView.delegate = self
        self.view.addSubview(paintView)
        configureSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    func configureSubviews() {
        // lineWidthSilder
        lineWidthSlider = UISlider(frame: CGRect(x: 50, y: self.view.frame.height - 50, width: 100, height: 40))
        lineWidthSlider.minimumValue = 1.0
        lineWidthSlider.maximumValue = 30.0
        lineWidthSlider.setValue(5.0, animated: false)
        lineWidthSlider.isContinuous = true
        lineWidthSlider.addTarget(self, action: #selector(lineWidthSliderValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(lineWidthSlider)

        // opacitySlider
        opacitySlider = UISlider(frame: CGRect(x: 50, y: self.view.frame.height - 90, width: 100, height: 40))
        opacitySlider.minimumValue = 0.001
        opacitySlider.maximumValue = 1.0
        opacitySlider.setValue(1.0, animated: false)
        opacitySlider.isContinuous = true
        opacitySlider.addTarget(self, action: #selector(lineOpacitySliderValueDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(opacitySlider)

        // colorButton
        colorButton = UIButton(frame: CGRect(x: 170, y: self.view.frame.height - 130, width: 120, height: 35))
        colorButton.setTitle("random color", for: UIControlState())
        colorButton.setTitleColor(UIColor.black, for: .normal)
        colorButton.setTitleColor(UIColor.gray, for: .highlighted)
        colorButton.addTarget(self, action: #selector(randomColor), for: .touchUpInside)
        self.view.addSubview(colorButton)

        // undoButton
        undoButton = UIButton(frame: CGRect(x: 170, y: self.view.frame.height - 90, width: 80, height: 35))
        undoButton.setTitle("undo", for: UIControlState())
        undoButton.setTitleColor(UIColor.black, for: .normal)
        undoButton.setTitleColor(UIColor.gray, for: .highlighted)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        self.view.addSubview(undoButton)

        // clearButton
        clearButton = UIButton(frame: CGRect(x: 170, y: self.view.frame.height - 50, width: 80, height: 35))
        clearButton.setTitle("clear", for: UIControlState())
        clearButton.setTitleColor(UIColor.black, for: .normal)
        clearButton.setTitleColor(UIColor.gray, for: .highlighted)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        self.view.addSubview(clearButton)
    }

    func lineWidthSliderValueDidChange(sender: UISlider!) {
        paintView.lineWidth = CGFloat(sender.value)
    }

    func lineOpacitySliderValueDidChange(sender: UISlider!) {
        paintView.lineOpacity = CGFloat(sender.value)
    }

    func randomColor() {
        let redValue = CGFloat(arc4random()%256)/255.0
        let greenValue = CGFloat(arc4random()%256)/255.0
        let blueValue = CGFloat(arc4random()%256)/255.0

        paintView.lineColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

    func undo() {
        paintView.removeLastLine()
    }

    func clear() {
        paintView.clearCanvas()
    }
    /******************************** fishPaintView delegate **********************************/
    func fishPaintDidBeginDrawing(view: fishPaintView) {
        print("start drawing")
        UIView.animate(withDuration: 0.5, animations: {
            self.colorButton.alpha = 0.0
            self.undoButton.alpha = 0.0
            self.clearButton.alpha = 0.0
            self.lineWidthSlider.alpha = 0.0
            self.opacitySlider.alpha = 0.0
        })
    }

    func fishPaintIsDrawing(view: fishPaintView) {

    }

    func fishPaintDidFinishDrawing(view: fishPaintView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.undoButton.alpha = 1.0
            self.colorButton.alpha = 1.0
            self.clearButton.alpha = 1.0
            self.lineWidthSlider.alpha = 1.0
            self.opacitySlider.alpha = 1.0
        })
    }

    func fishPaintDidCancelDrawing(view: fishPaintView) {
        print("cancel")
    }

}

