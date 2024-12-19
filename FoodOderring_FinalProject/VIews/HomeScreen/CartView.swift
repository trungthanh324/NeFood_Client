//
//  CartView.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 13/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData : HomeViewModel
    @Environment(\.presentationMode) var present
    @State var isShowMap = false
    @State var color = Color.red.opacity(0.8)
    var body: some View {
            VStack{
                HStack(spacing: 20){
                    Button(action: {present.wrappedValue.dismiss()} , label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(color)
                    })
                    
                    Text("My cart")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding()
                ScrollView(.vertical, showsIndicators: false){
                    LazyVStack(spacing: 0){
                        ForEach(homeData.cartItems){ cart in
                            HStack{
                                WebImage(url: URL(string: cart.item.item_image))
                                    .resizable()
                                    .aspectRatio(contentMode:.fill)
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(15)
                                
                                VStack(alignment: .leading, spacing: 10){
                                    Text(cart.item.item_name)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                             
                                    Text(cart.item.item_details)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                    
    //getPrice, add, delete product
                                    
                                    HStack(spacing: 15){
                                        Text("\(cart.item.item_cost)")
                                            .font(.title2)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                        
                                        Spacer(minLength: 0)
    //minus
                                        Button(action: {
                                            if cart.quantity > 1{
                                                homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                            }
                                        }, label: {
                                            Image(systemName: "minus")
                                                .fontWeight(.heavy)
                                                .foregroundColor(.black)
                                        })
                                        
                                        Text("\(cart.quantity)")
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(Color.black.opacity(0.06))
    //plus
                                        Button(action: {
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                        }, label: {
                                            Image(systemName: "plus")
                                                .fontWeight(.heavy)
                                                .foregroundColor(.black)
                                        })
                                    }
                                    .padding(.trailing, 5)
                                }//vstack
                            }
                            .padding(.top , 10)
                            .contextMenu{
    //delete order from cart
                                Button(action: {
                                    let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                                    let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                                    
                                    homeData.items[itemIndex].isAdded = false
                                    homeData.filtered[itemIndex].isAdded = false
                                    homeData.cartItems.remove(at: index)
                                }, label: {
                                    Text("Delete")
                                })
                            }
                        }//foreach
                    }//lazyvstack
                }//scrollview
                
                
                
    //bottom view
                VStack{
                    HStack{
                        Text("Shipping:")
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("₫35.000")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding([.top, .horizontal])
                    HStack{
                        Text("Total")
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(homeData.caculateTotalPrice())
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
                    .padding([.top, .horizontal])
            
                    NavigationLink(destination: TrackingScreen(HomeModel: homeData), isActive: $isShowMap) {
                        Button(action: {
                            homeData.updateOrder()
                            if homeData.ordered {
                                isShowMap = true
                            }
                        }) {
                            Text(homeData.ordered ? "View Order" : "Pay by cash")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.screenWidth - 30)
                                .background(Color(color))
                                .cornerRadius(15)
                        }
                    }

                }
                .background(Color.white)
            }//vstack
            .navigationBarBackButtonHidden()
    }//body
}//struct

#Preview {
    CartView(homeData: HomeViewModel())
}

