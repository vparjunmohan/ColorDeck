//
//  ColorDeckViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 05/11/22.
//

import UIKit
import DOFavoriteButton

class ColorDeckViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addSwipeView())
        
        let button = DOFavoriteButton(frame: CGRect(x: 100, y: 50, width: 50, height: 50), image: UIImage(named: "favorite"))
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
    }
    
    @objc func clicked(_ sender: DOFavoriteButton){
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
            sender.imageColorOff = UIColor.brown
            sender.imageColorOn = UIColor.red
            sender.circleColor = UIColor.green
            sender.lineColor = UIColor.blue
            sender.duration = 3.0 // default: 1.0
        }
    }
    
    func addSwipeView() -> UIView {
        let swipeView = UIView()
        let color = UIColor.random()
        let hexCode = hexStringFromColor(color: color)
        let viewHeight = 350.0
        let viewWidth = 250.0
        let defaults = UserDefaults.standard
        if let viewTag = defaults.object(forKey: "viewTag") as? Int {
            swipeView.tag = viewTag
        }
        swipeView.backgroundColor = color
        swipeView.layer.cornerRadius = 10
        swipeView.layer.shadowColor = color.cgColor
        swipeView.applyCommonDropShadow(radius: 5, opacity: 1)
        swipeView.alpha = 0
        swipeView.frame = CGRect(x: (view.center.x)-(viewWidth/2), y: (view.center.y)-(viewHeight/2), width: viewWidth, height: viewHeight)
        createHexLabel()
        if let hexLabel = view.viewWithTag(400) as? UILabel {
            hexLabel.frame = CGRect(x: 0, y: swipeView.frame.maxY + 30, width: self.view.frame.width, height: 20)
            hexLabel.text = "Color code: \(hexCode)"
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
            swipeView.alpha = 1
        })
        let viewSwippedRight = UISwipeGestureRecognizer(target: self, action: #selector(viewIsSwipped(_:)))
        viewSwippedRight.direction = .right
        let viewSwippedLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewIsSwipped(_:)))
        viewSwippedRight.direction = .left
        swipeView.addGestureRecognizer(viewSwippedRight)
        swipeView.addGestureRecognizer(viewSwippedLeft)
        return swipeView
    }
    
    @objc func viewIsSwipped(_ sender: UISwipeGestureRecognizer){
        let currentSwipeView = sender.view!
        var currentSwipeFrame = currentSwipeView.frame
        let defaults = UserDefaults.standard
        let angle: CGFloat = 45.0 * CGFloat.pi / 180.0
        
        if let currentSwipeTag = defaults.object(forKey: "viewTag") as? Int{
            defaults.set(currentSwipeTag+1, forKey: "viewTag")
        }
        let newSwipeView = addSwipeView()
        newSwipeView.isUserInteractionEnabled = false
        view.addSubview(newSwipeView)
        
        switch sender.direction {
        case .left:
            currentSwipeFrame.origin.x -= 70
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [self] () -> Void in
                view.bringSubviewToFront(currentSwipeView)
                currentSwipeView.frame = currentSwipeFrame
                let rotationMatrix = CGAffineTransform(rotationAngle: -angle)
                let translationMatrix = CGAffineTransform(translationX: -100.0, y: -angle)
                currentSwipeView.transform = translationMatrix.concatenating(rotationMatrix)
            }) { completed in
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    currentSwipeView.alpha = 0
                }) { completed in
                    currentSwipeView.removeFromSuperview()
                }
                newSwipeView.isUserInteractionEnabled = true
            }
        case .right:
            currentSwipeFrame.origin.x += 70
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [self] () -> Void in
                view.bringSubviewToFront(currentSwipeView)
                currentSwipeView.frame = currentSwipeFrame
                let rotationMatrix = CGAffineTransform(rotationAngle: angle)
                let translationMatrix = CGAffineTransform(translationX: 100.0, y: 0.0)
                currentSwipeView.transform = translationMatrix.concatenating(rotationMatrix)
            }) { completed in
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    currentSwipeView.alpha = 0
                }) { completed in
                    currentSwipeView.removeFromSuperview()
                }
                newSwipeView.isUserInteractionEnabled = true
            }
        default:
            break
        }
    }
}
