//
//  DeviceConstraints.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/30/19.
//  Copyright © 2019 SK2020. All rights reserved.
//

import UIKit

struct DeviceConstraints {
    func outerCircle() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation == .portrait {
                return 1.1
            } else {
                return 4.0
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                return 1.5
            } else {
                return 2.1
            }
        }
    }
    
    func ticks() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation == .portrait {
                return 1.2
            } else {
                return 4.5
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                return 1.6
            } else {
                return 2.2
            }
        }
    }
    
    func innerCircle() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation == .portrait {
                return 1.5
            } else {
                return 6
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                return 1.9
            } else {
                return 2.5
            }
        }
    }
}
