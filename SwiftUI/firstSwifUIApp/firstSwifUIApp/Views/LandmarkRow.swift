//
//  LandmarkRow.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 03.04.2023.
//

import SwiftUI

struct LandmarkRow: View {
    /// Creating property for storing instance of `Landmark`
    var landmark: Landmark
    
    var body: some View {
        HStack {
            Text("hello world")
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkRow(landmark: landmarks[0])
    }
}
