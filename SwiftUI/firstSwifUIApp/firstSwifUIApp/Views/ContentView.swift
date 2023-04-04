//
//  ContentView.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 31.03.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
