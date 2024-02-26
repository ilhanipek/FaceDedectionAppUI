//
//  ContentView.swift
//  FaceDedectionAppUI
//
//  Created by ilhan serhan ipek on 21.09.2023.
//

import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
    @State var isActivated: Bool
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var faces: [VNFaceObservation]? = nil
    private var faceCount: Int { return faces?.count ?? 1 }
    private let placeholderImage = UIImage(named: "slipknot")!
    @State private var image: UIImage?

    var body: some View {
        VStack(spacing: 10) {
            if let image = self.image {
              Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .center)
              Text("\(faceCount)").padding(.bottom, 20)
            } else {
                Image(uiImage: placeholderImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
            }
            Spacer()

            PhotosPicker(selection: $selectedPhoto, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                Text("Select photo from album")
                    .font(.title2)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
          DetectFaceButton(isActivated: $isActivated, selectedPhoto: $selectedPhoto, image: $image, faces: $faces)
        }
        .onChange(of: selectedPhoto, perform: { newValue in
            guard let item = selectedPhoto.first else { return }
            Task {
                do {
                    let data = try await item.loadTransferable(type: Data.self)
                  if let image = UIImage(data: data!) {
                        self.image = image
                    } else {
                        print("Failed to create UIImage from data.")
                    }
                } catch {
                    print("Error loading transferable: \(error)")
                }
            }
        })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isActivated: false)
    }
}
