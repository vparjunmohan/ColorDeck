//
//  SwipeView.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/08/23.
//

import Foundation
import UIKit

protocol SwipeViewDelegate: AnyObject {
    func updateFavorites(uuid: String, isFavorite: Bool, colorCode: String)
    func newSwipeViewAdded(swipeView: SwipeView)
}

class SwipeView: UIView {
    
    // MARK: - PROPERTIES
    private var heartButton: UIButton!
    weak var delegate: SwipeViewDelegate?
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSwipeGesture()
        setRandomBackgroundColor()
        setupHeartButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSwipeGesture()
        setRandomBackgroundColor()
        setupHeartButton()
    }
    
    deinit {
    }
    
    // MARK: - CONFIG
    private func setupSwipeGesture() {
        let viewSwippedRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        viewSwippedRight.direction = .right
        let viewSwippedLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        viewSwippedRight.direction = .left
        self.addGestureRecognizer(viewSwippedRight)
        self.addGestureRecognizer(viewSwippedLeft)
        self.addCornerRadius(radius: 10)
        self.accessibilityIdentifier = UUID().uuidString
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeartButton(_:)), name: .UpdateHeartButton, object: nil)
    }
    
    private func setRandomBackgroundColor() {
        backgroundColor = UIColor(
            red: CGFloat.random(),
            green: CGFloat.random(),
            blue: CGFloat.random(),
            alpha: 1.0
        )
    }
    
    private func setupHeartButton() {
        heartButton = UIButton(type: .custom)
        heartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        heartButton.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        heartButton.tintColor = .red
        heartButton.applyCommonDropShadow(radius: 3, opacity: 0.5)
        addSubview(heartButton)
    }
    
    // MARK: - SELECTORS
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        guard let superview = self.superview else { return }
        let currentSwipeView = sender.view!
        var currentSwipeFrame = currentSwipeView.frame
        let angle: CGFloat = 45.0 * CGFloat.pi / 180.0
        let newSwipeView = SwipeView(frame: currentSwipeFrame)
        superview.addSubview(newSwipeView)
        delegate?.newSwipeViewAdded(swipeView: newSwipeView)
        var translationX: CGFloat = 0.0
        
        if sender.direction == .left {
            translationX = -70.0
        } else if sender.direction == .right {
            translationX = 70.0
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            superview.bringSubviewToFront(currentSwipeView)
            currentSwipeView.frame = currentSwipeFrame
            if sender.direction == .left {
                currentSwipeFrame.origin.x -= translationX
                let rotationMatrix = CGAffineTransform(rotationAngle: -angle)
                let translationMatrix = CGAffineTransform(translationX: -100.0, y: -angle)
                currentSwipeView.transform = translationMatrix.concatenating(rotationMatrix)
            } else {
                currentSwipeFrame.origin.x += translationX
                let rotationMatrix = CGAffineTransform(rotationAngle: angle)
                let translationMatrix = CGAffineTransform(translationX: 100.0, y: 0.0)
                currentSwipeView.transform = translationMatrix.concatenating(rotationMatrix)
            }
            self.heartButton.removeFromSuperview()
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                currentSwipeView.alpha = 0
            }) { completed in
                currentSwipeView.removeFromSuperview()
            }
        }
    }
    
    @objc private func heartButtonTapped() {
        guard let swipeViewIdentifier = self.accessibilityIdentifier, let hexString = self.backgroundColor?.toHex() else { return }
        heartButton.isSelected.toggle()
        if heartButton.isSelected {
            delegate?.updateFavorites(uuid: swipeViewIdentifier, isFavorite: true, colorCode: hexString)
            heartButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            delegate?.updateFavorites(uuid: swipeViewIdentifier, isFavorite: false, colorCode: hexString)
            heartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func updateHeartButton(_ notification: Notification) {
        if let dict = notification.userInfo as? [String:Any], let identifier = dict["uuid"] as? String {
            if self.accessibilityIdentifier == identifier {
                heartButton.isSelected = false
                heartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
}
