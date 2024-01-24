//
//  BreadForm.swift
//  BreadJournal
//
//  Created by Michel Goñi on 21/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BreadFormFeature {
    struct State: Equatable {
        @BindingState var journalEntry: Entry
        
        init(journalEntry: Entry) {
            self.journalEntry = journalEntry
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
            
        }
    }
}

struct BreadFormView: View {
    let store: StoreOf<BreadFormFeature>
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                Form {
                    Section {
                        DatePicker("Fecha",
                                   selection: viewStore.$journalEntry.date,
                                   displayedComponents: .date)
                    }
                    
                    //                    Section(header: Text("Foto")) {
                    //                        ImagePickerView(selectedImage: viewStore.$journalEntry.breadPicture)
                    //                            .frame(maxWidth: .infinity, alignment: .center)
                    //                    }
                    //                    Section(
                    //                        header: IngredientsHeaderView(
                    //                            addItem: addItem(ingredient:))
                    //                    ) {
                    //                        ForEach(items.indices,
                    //                                id: \.self) { index in
                    //                            TextField("Ingrediente \(index + 1)",
                    //                                      text: $items[index])
                    //                        }
                    //                    }
                    //                    Group {
                    //
                    //                        Section {
                    //                            DatePicker("Hora último refresco mada madre",
                    //                                       selection: viewStore.$journalEntry.lastSourdoughFeedTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //                        Section {
                    //                            DatePicker("Hora comiezo prefermento",
                    //                                       selection: viewStore.$journalEntry.prefermentStartingTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //                        Section {
                    //                            DatePicker("Hora comiezo autólisis",
                    //                                       selection: viewStore.journalEntry.autolysisStartingTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //                        Section {
                    //                            DatePicker("Hora comiezo fermentación en bloque",
                    //                                       selection: viewStore.journalEntry.blockFermentationStartingTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //
                    //                        Section {
                    //                            TextField("Pliegues", text: viewStore.journalEntry.folds)
                    //                        }
                    //
                    //                        Section {
                    //                            DatePicker("Hora formado del pan",
                    //                                       selection: viewStore.journalEntry.breadShapingTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //
                    //                        Section {
                    //                            DatePicker("Hora segunda fermentación",
                    //                                       selection: viewStore.journalEntry.secondFermentingTime,
                    //                                       displayedComponents: .hourAndMinute)
                    //                        }
                    //                    }
                    //                    Group {
                    //
                    //                        Toggle(isOn: viewStore.journalEntry.fridge) {
                    //                            Text("¿Se ha usado frigorífico?")
                    //                        }
                    //                        if viewStore.journalEntry.fridge{
                    //                            Section {
                    //
                    //                                TextField("Tiempo total en el frigo", text: viewStore.journalEntry.fridgeTotalTime)
                    //                            }
                    //                        }
                    //                        Section {
                    //                            TextField("Tiempo de horneado",
                    //                                      text: viewStore.journalEntry.bakingTotalTime)
                    //                            Toggle(isOn: viewStore.journalEntry.steelPlate) {
                    //                                Text("¿Plancha de acero?")
                    //                            }
                    //                        }
                    //
                    //                    }
                    Group {
//                                                Section(header: Text("Corteza")) {
//                                                    StarRatingView(rating: viewStore.$journalEntry.crustRating)
//                                                }
//                                                Section(header: Text("Miga")) {
//                                                    StarRatingView(rating: viewStore.$journalEntry.crumbRating)
//                                                }
//                                                Section(header: Text("Subida")) {
//                                                    StarRatingView(rating: viewStore.$journalEntry.riseRating)
//                                                }
//                                                Section(header: Text("Greñado")) {
//                                                    StarRatingView(rating: viewStore.j$ournalEntry.scoreRating)
//                                                }
//                                                Section(header: Text("Sabor")) {
//                                                    StarRatingView(rating: viewStore.$journalEntry.tasteRating)
//                                                }
//                                                Section(header: Text("Evaluation")) {
//                                                    StarRatingView(rating: viewStore.$journalEntry.evaluation)
//                                                }
//                                            }
                        
                    }
                    Spacer()
                    Button(action: {
                        debugPrint("pressed send")
                    }) {
                        Text("Enviar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(minWidth: .zero,
                                   maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        
        //    func addItem(ingredient: String) {
        //        items.append(ingredient)
        //    }
    }
  
}

#Preview(body: {
    

    BreadFormView(store: Store(initialState: BreadFormFeature.State(journalEntry: .mock), reducer: {
        BreadFormFeature()
    }))
})

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.image = pickedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ImagePickerView: View {
    @Binding var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
            }
            
            Button(action: {
                isImagePickerPresented = true
            }) {
                if selectedImage == nil {
                    Text("Seleccionar Imagen")
                }
                
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

struct IngredientsHeaderView: View {
    var addItem: (String) -> Void
    @State private var newIngredient = ""
    var body: some View {
        HStack {
            Text("Ingredientes")
                .font(.headline)
            Spacer()
            Button(action: {
                addItem(newIngredient)
                
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.green)
            }
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    let maximumRating: Int = 5
    
    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}


