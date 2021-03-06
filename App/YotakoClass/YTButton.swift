//
//  YTButton.swift
//  App
//
//  Created by Keuha on 26/02/2018.
//  Copyright © 2018 Yotako S.A. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class YTButton : UIButton {
    
    @IBInspectable var addBorderTop: CGFloat = 0.0
        {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderBottom: CGFloat = 0.0
        {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderLeft: CGFloat = 0.0
        {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderRight: CGFloat = 0.0
        {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet {
            self.updateCornerCall = self.updateCorner
        }
    }
    @IBInspectable var startColor: UIColor = UIColor.clear
        {
        didSet {
            self.updateGradientCall = self.updateGradient
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.clear
        {
        didSet {
            self.updateGradientCall = self.updateGradient
        }
    }
    
    @IBInspectable var stringUrl: String = ""
        {
        didSet {
            self.downloadImage = self.imageFromUrl
        }
    }
    
    var updateCornerCall : (()-> Void)?
    var updateBorderCall : (()-> Void)?
    var updateGradientCall : (() -> Void)?
    var downloadImage: (() -> Void)?
    
    var originalHeight: CGFloat = 0.0
    var originalWidth: CGFloat = 0.0
    
    override func willMove(toSuperview newSuperview: UIView?) {
        originalWidth = self.frame.width
        originalHeight = self.frame.height
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        updateBorderCall?()
        updateCornerCall?()
        updateGradientCall?()
    }
    
    func updateCorner() {
        let smallerRatio = (frame.height / originalHeight) > (frame.width / originalWidth ) ? (frame.width / originalWidth ) : (frame.height / originalHeight)
        layer.cornerRadius = cornerRadius * smallerRatio
        layer.masksToBounds = (cornerRadius * smallerRatio) > 0
    }
    
    func updateBorder() {
        if addBorderTop > 0  {
            self.addBorderUtility(0, y: 0, width:self.bounds.size.width, height: addBorderTop)
        }
        if addBorderBottom > 0 {
            self.addBorderUtility(0, y: self.bounds.size.height, width:self.bounds.size.width, height: addBorderBottom)
        }
        if addBorderRight > 0 {
            self.addBorderUtility(0, y: 0, width:addBorderRight, height: self.bounds.size.height)
        }
        if addBorderLeft > 0 {
            self.addBorderUtility(self.bounds.size.width - addBorderLeft, y:0, width: addBorderLeft, height: self.bounds.size.height)
        }
    }
    
    private func addBorderUtility(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let border = CALayer()
        border.backgroundColor = self.layer.borderColor;
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    private func updateGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: frame.size.width,
                                height: frame.size.height)
        gradient.colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
    
    private func imageFromUrl() {
        if let url = URL(string: self.stringUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) { //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.setBackgroundImage(UIImage(data: data), for: .normal)
                    }
                }
            }
        }
    }
}
