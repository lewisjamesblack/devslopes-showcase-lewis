//
//  MaterialTextField.swift
//  devslopes-showcase-lewis
//
//  Created by Lewis Black on 29/03/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        

    }
    
    //Placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    //Normal text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
