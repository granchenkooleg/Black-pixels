//
//  ContentView.swift
//  TC
//
//  Created by Oleg Granchenko on 22.04.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var imageInfoViewModel = ImageInfoViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                ForEach(imageInfoViewModel.images.indices, id: \.self) { idx in
                    ZStack {
                        Image(imageInfoViewModel.images[idx].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .animation(.easeInOut)
                        
                        LoaderView(tintColor: .accentColor,
                                   scaleSize: 2.0).hidden(imageInfoViewModel.images[idx].isHideLoader)
                    }
                    
                    .onTapGesture {
                        imageInfoViewModel.images[idx].isHideLoader = false
                        let resizedImage = imageInfoViewModel.resizeBegin(with: UIImage(imageLiteralResourceName: imageInfoViewModel.images[idx].image),
                                                                          width: 30,
                                                                          height: 30)
                        imageInfoViewModel.getBlackPixelsAndSort(resizedImage, with: idx)
                        imageInfoViewModel.images[idx].isHideLoader = true
                    }
                    
                    .overlay(imageInfoViewModel.showPercent(imageInfoViewModel.images[idx].blackPixelsPercent ?? nil),
                             alignment: Alignment(horizontal: .trailing,
                                                  vertical: .top))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            })
            .background(Color.gray.opacity(0.1))
            
            .navigationBarTitle("Determine black pixels", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button("All photos", action: {
                        imageInfoViewModel.isHideLoaderForEachImage(false)
                        imageInfoViewModel.resizeImagesBeginAndSort()
                        imageInfoViewModel.isHideLoaderForEachImage(true)
                    }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            imageInfoViewModel.fillImageInfo()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
