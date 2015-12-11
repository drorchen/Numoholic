//
//  FButton.swift
//  Numoholic
//
//  Created by Dror Chen on 12/8/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import UIKit

class FButton: UIButton {
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(self.frame.size.width, self.titleLabel!.frame.size.height);
    }
}
