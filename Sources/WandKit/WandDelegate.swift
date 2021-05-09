//
//  WandDelegate.swift
//  
//
//  Created by Juliette on 5/9/21.
//

import Foundation

public protocol WandDelegate {
    func deviceFound () // Called when Wand is discovered
    func connected () // Called when Wand connects to device
    func failToConnect () // Called if Wand fails to connect to device
    func disconnect () // Called when Wand disconnects, automatically rescans to attempt to reconnect
    func location (_ point: Point) // Called whenever Wand sends location
    func buttonPress () // Called whenever Wand sends button press
}
