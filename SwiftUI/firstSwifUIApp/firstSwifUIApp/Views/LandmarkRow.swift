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
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 400, height: 70))
    }
}
