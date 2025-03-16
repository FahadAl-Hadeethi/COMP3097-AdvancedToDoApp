import SwiftUI

struct TaskListView: View {
    var category: String
    @State private var tasks: [Task] = []
    @State private var navigateToCreateTask = false

    struct Task: Identifiable {
        let id = UUID()
        var title: String
        var description: String
        var category: String
        var status: String
        var dueDate: String
        var isCompleted: Bool
    }

    var body: some View {
        NavigationStack {
            VStack {
                // header background
                ZStack {
                    Rectangle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)

                    Text(category)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)
                }
                
                
                NavigationLink(destination: CreateTaskView(addTask: addTask), isActive: $navigateToCreateTask) {
                    EmptyView()
                }

                // Create Task Button
                Button(action: {
                    navigateToCreateTask = true
                }) {
                    Text("Add a new task")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }

                if tasks.isEmpty {
                    Text("There's nothing here.\nAdd a task!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // Task List
                List {
                    ForEach(tasks.indices, id: \.self) { index in
                        NavigationLink(destination: TaskDetailView(
                            task: $tasks[index].title,
                            description: $tasks[index].description,
                            status: $tasks[index].status,
                            dueDate: $tasks[index].dueDate,
                            updateTask: { newTitle, newDescription, newStatus, newDueDate in
                                updateTask(index: index, newTitle: newTitle, newDescription: newDescription, newStatus: newStatus, newDueDate: newDueDate)
                            },
                            deleteTask: { deleteTask(index: index) }
                        )) {
                            TaskCardView(task: tasks[index])
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(PlainListStyle())
            }
        }
    }

    // Add Task Function
    func addTask(title: String, description: String, category: String, status: String, dueDate: String) {
        tasks.append(Task(title: title, description: description, category: category, status: status, dueDate: dueDate, isCompleted: false))
    }

    // Delete Task Function
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func deleteTask(index: Int) {
        tasks.remove(at: index)
    }

    // Update Task Function
    func updateTask(index: Int, newTitle: String, newDescription: String, newStatus: String, newDueDate: String) {
        tasks[index].title = newTitle
        tasks[index].description = newDescription
        tasks[index].status = newStatus
        tasks[index].dueDate = newDueDate
    }
}

// TaskCardView
struct TaskCardView: View {
    var task: TaskListView.Task

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.headline)
                .foregroundColor(.black)

            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()

            HStack {
                Text("Status: \(task.status)")
                    .font(.footnote)
                    .foregroundColor(.blue)
                Spacer()
                Text("Due: \(task.dueDate)")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 3)
        .padding(.horizontal)
    }
}
