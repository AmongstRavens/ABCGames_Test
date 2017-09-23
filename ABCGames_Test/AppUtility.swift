//
//  AppUtility.swift
//  ABCGames_Test
//
//  Created by Sergey on 9/23/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import UIKit

struct AppUtility {
    
    static func lockOrientation(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                delegate.orientationLock = .landscape
                return
            case .portrait:
                delegate.orientationLock = .portrait
                return
            case .portraitUpsideDown:
                delegate.orientationLock = .portraitUpsideDown
                return
            default:
                return
            }
        }
    }
    
    static func unlockOrientation() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .all
        }
    }

}
