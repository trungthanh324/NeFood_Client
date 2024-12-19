//
//  Item.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 12/10/24.
//

import SwiftUI

struct Item : Identifiable {
    var id : String
    var item_name : String
    var item_cost : NSNumber
    var item_details : String
    var item_image : String
    var item_rating : NSNumber
    var isAdded : Bool = false
}

