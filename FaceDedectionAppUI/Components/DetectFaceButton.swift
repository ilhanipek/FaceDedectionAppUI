//
//  DeteectFaceButton.swift
//  FaceDedectionAppUI
//
//  Created by ilhan serhan ipek on 21.09.2023.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Vision

struct DetectFaceButton: View {
    @Binding var isActivated: Bool
    @Binding var selectedPhoto: [PhotosPickerItem]
    @Binding var image: UIImage?
    @Binding var faces: [VNFaceObservation]?
    var body: some View {
        Button(action: {
            Task {
                if let item = selectedPhoto.first {
                    do {
                        let data = try await item.loadTransferable(type: Data.self)
                      if let image = UIImage(data: data!) {
                            self.image = image
                            isActivated.toggle()
                        
                        image.dedectFaces { result in
                          faces = result
                        }
                        } else {
                            print("Failed to create UIImage from data.")
                        }
                    } catch {
                        print("Error loading transferable: \(error)")
                    }
                } else {
                    print("No selected photo.")
                }
            }
        }) {
            Text("Detect Faces")
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(isActivated ? .red : .green))
                .cornerRadius(10)
        }
    }
}
struct DetectFaceButton_Previews: PreviewProvider {
    static var previews: some View {
      DetectFaceButton(isActivated: .constant(false), selectedPhoto: .constant([]), image: .constant(nil), faces: .constant([]))
    }
}
