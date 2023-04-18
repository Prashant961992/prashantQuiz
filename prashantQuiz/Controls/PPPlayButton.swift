//
//  PPPlayButton.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 18/04/23.
//

import UIKit

/**
 A custom `UIButton` subclass that represents a play button for media content.
 */
class PPPlayButton: UIButton {
    
    override func awakeFromNib() {
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()  {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.cornerRadius = 4.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
