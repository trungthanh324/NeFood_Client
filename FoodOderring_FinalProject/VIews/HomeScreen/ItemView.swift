//
//  ItemView.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 12/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    var item : Item
    @State var color = Color.red.opacity(0.8)
    var body: some View {
        VStack{
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenWidth - 20, height: 250)
            HStack(spacing: 8){
                Text(item.item_name)
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                ForEach(1...5, id: \.self){index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(truncating: item.item_rating) ? Color(color) : .gray)
                }
            }
            HStack{
                Text(item.item_details)
                    .font(.caption)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
            }
        }
    }
}

