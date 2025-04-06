import SwiftUI
import CoreData

struct TaskListView: View {
    var category: String
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest private var tasks: FetchedResults<TaskEntity>
    @State private var navigateToCreateTask = false
    @State private var refreshToggle = false
    @State private var searchText = ""

    init(category: String) {
        self.category = category
        _tasks = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.dueDate, ascending: true)],
            predicate: NSPredicate(format: "category == %@", category),
            animation: .default
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
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

                NavigationLink(destination: CreateTaskView(category: category, addTask: addTask), isActive: $navigateToCreateTask) {
                    EmptyView()
                }

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

                if filteredTasks.isEmpty {
                    Text("No tasks found")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Group {
                    List {
                        ForEach(filteredTasks) { task in
                            NavigationLink(
                                destination: TaskDetailView(task: task)
                                    .onDisappear { refreshToggle.toggle() }
                            ) {
                                TaskCardView(task: task)
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .listStyle(PlainListStyle())
                }
                .id(refreshToggle)
                .animation(.easeInOut(duration: 0.3), value: tasks.count)
                .searchable(text: $searchText, prompt: "Search tasks...")
            }
        }
    }

    func addTask(title: String, description: String, category: String, status: String, dueDate: String) {
        let newTask = TaskEntity(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.taskDescription = description
        newTask.category = category
        newTask.status = status
        newTask.dueDate = parseDate(dueDate)

        try? viewContext.save()
    }

    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            viewContext.delete(task)
        }

        try? viewContext.save()
    }

    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func parseDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.date(from: dateString) ?? Date()
    }

    var filteredTasks: [TaskEntity] {
        if searchText.isEmpty {
            return Array(tasks)
        } else {
            return tasks.filter {
                ($0.title ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.taskDescription ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    struct TaskCardView: View {
        var task: TaskEntity

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title ?? "")
                    .font(.headline)
                    .foregroundColor(.black)

                Text(task.taskDescription ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                HStack {
                    Text("Status: \(task.status ?? "")")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Due: \(formatDate(task.dueDate))")
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

        func formatDate(_ date: Date?) -> String {
            guard let date = date else { return "" }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}
