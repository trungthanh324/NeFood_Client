//
//  Color + Utilities.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 1/10/24.
//

import SwiftUI
import UIKit
extension Color{
    init(_ red : CGFloat, _ green : CGFloat, _ blue : CGFloat){ // _ de khi dien vao k can dien red: green: blue: ma chi can dien so^' no se tu hieu
        self.init(red : red/255.0, green: green/255.0, blue:  blue/255.0)
    }
}
