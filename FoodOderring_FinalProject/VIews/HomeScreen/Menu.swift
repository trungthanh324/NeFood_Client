//
//  Menu.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 11/10/24.
//

import SwiftUI
import FirebaseAuth
struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    @State var color = Color.red.opacity(0.8)
    @State var isShowCartView = false
    init(homeData: HomeViewModel, color: SwiftUI.Color = Color.red.opacity(0.8)) {
        self.homeData = homeData
        self.color = color
    }
    var body: some View {
        
            VStack{
                Button(action: {
                    isShowCartView = true
                }, label: {
                    HStack(spacing: 15){
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(color)
                        
                        Text("Cart")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Spacer(minLength: 0)
                    }//hstack
                    .padding()
                    
                    NavigationLink(destination: CartView(homeData: homeData), isActive: $isShowCartView) {
                        EmptyView()
                    }
                })

                Spacer()

            }//vstack
            .padding([.top,.trailing])
            .frame(width: UIScreen.screenWidth / 1.6)
            .background(Color.white.ignoresSafeArea())
        
    }//body
}//struct


