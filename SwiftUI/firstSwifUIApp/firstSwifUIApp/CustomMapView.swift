//
//  CustomMapView.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 01.04.2023.
//

import SwiftUI

struct CustomMapView: View {
    var body: some View {
        ZStack {
            Image("EldenRingMap")
                .resizable()
                .ignoresSafeArea()
                .overlay {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .position(x: 100, y: 100)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                        .position(x: 200, y: 200)
                }
        }
    }
}

struct CustomMapView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMapView()
    }
}
