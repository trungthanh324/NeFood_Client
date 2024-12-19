//
//  WelcomeShape.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 1/10/24.
//

import SwiftUI

struct WelcomeShape: View {
    var body: some View {
        GeometryReader { geometry in
            // Path de ve mau nen
            Path{ path in
                path.addRect(CGRect(x: 0, y: 0,
                                    width: UIScreen.screenWidth,
                                    height: UIScreen.screenHeight))
            }.fill(LinearGradient(gradient: Gradient(colors: [Color(168,24,45),  Color(237,31,65)]),
                                  startPoint: UnitPoint(x : 0,y : 0),
                                  endPoint: UnitPoint(x: 1, y:  1 )
            ))
            
            // ve duong vong cung
            Path { path in
                // di chuyen toi vi tri 0 0
                path.move(to: CGPoint(x: 0, y: 0))
                // ve duong thang
                path.addLine(to: CGPoint(x: UIScreen.screenWidth, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.screenWidth, y: 50))
                path.addQuadCurve(to: CGPoint(x: 0, y: 300), control: CGPoint(x: UIScreen.screenWidth/3, y: 100 ))
            }
            .fill(Color(240,58,85))
            .shadow(color: .black.opacity(0.3), radius: 10, x: 1, y: 1)
            
            //ve hinh tron
            Path {  path in
                //ve hinh tron
                path.addEllipse(in: CGRect(origin: CGPoint(x: 25, y: 65), size: CGSize(width: 50, height: 50)))
                
            }
            .fill(Color.white)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 1)
            
           
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeShape()
}
