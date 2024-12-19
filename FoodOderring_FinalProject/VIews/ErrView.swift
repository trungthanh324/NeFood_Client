//
//  ErrView.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 10/10/24.
//

import SwiftUI

struct ErrView : View {
    @State var color = Color.red.opacity(0.8)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View {
        ZStack{
            GeometryReader{geometry in
                ZStack(alignment: .center){
                    VStack{
                        HStack{
                            Text(self.error == "Reset" ? "Message" : "Error")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                            Spacer()
                        }
                        .padding(.horizontal, 25)
                        
                        Text(self.error == "Reset" ? "Check your email" : self.error)
                            .lineLimit(nil)
                            .foregroundColor(self.color)
                        Button {
                            self.alert.toggle()
                        } label: {
                            Text(self.error == "Reset" ? "Ok" :"Cancel")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.screenWidth - 120)
                        }
                        .background(self.color)
                        .cornerRadius(10)
                        .padding(.top, 25)
                        .padding(.bottom)
                    }
                    .padding()
                    .frame(width: UIScreen.screenWidth - 50)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                
            }
        }
    
    }
}




