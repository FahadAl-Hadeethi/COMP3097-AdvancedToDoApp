import SwiftUI

struct TaskCategoriesView: View {
    @State private var categories: [String] = []
    @State private var newCategory = ""
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            VStack {
            
                Text("To do list")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)

                
                Text("Task Categories:")
                    .font(.headline)
                    .padding(.top, 10)

            
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    
                    // Add Category Button
                    Button(action: {
                        showAlert = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 120)
                            Image(systemName: "plus")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }

                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: TaskListView(category: category)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(height: 120)
                                Text(category)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()
            }
            .alert("New Category", isPresented: $showAlert) {
                VStack {
                    TextField("Category Name", text: $newCategory)
                        .padding()
                    HStack {
                        Button("Cancel", role: .cancel) { }
                        Button("Add") {
                            addCategory()
                        }
                    }
                }
            }
        }
    }

    func addCategory() {
        if !newCategory.isEmpty {
            categories.append(newCategory)
            newCategory = ""
            showAlert = false
        }
    }
}
