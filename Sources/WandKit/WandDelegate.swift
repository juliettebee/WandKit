//
//  WandDelegate.swift
//  
//
//  Created by Juliette on 5/9/21.
//

import Foundation

@objc public protocol WandDelegate {
    optional func deviceFound () // Called when Wand is discovered
    optional func connected () // Called when Wand connects to device
    optional func failToConnect () // Called if Wand fails to connect to device
    optional func disconnect () // Called when Wand disconnects, automatically rescans to attempt to reconnect
    optional func location (_ point: Point) // Called whenever Wand sends location
    optional func buttonPress () // Called whenever Wand sends button press
}
