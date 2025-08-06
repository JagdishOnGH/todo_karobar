/*
  [DOC] TODO Cursor Rules
   
   Of course. Here is a simple, line-by-line breakdown of the requirements and my planned approach for each.

Task Plan: ToDo App
Core Requirements

Requirement: The todo should contain title, description, completed status and deadline.

My Approach: I will create a Todo entity in the domain layer and a TodoModel in the data layer with these exact fields. I'll use a TypeConverter in Floor to handle the DateTime object for the deadline.

Requirement: The items should be in a List View and have a infinite scrolling with pagination.

My Approach: I will use a ListView.builder inside a BlocBuilder. For pagination, I'll add a ScrollController to the list to detect when the user scrolls to the end, which will trigger a BLoC event to load the next page of tasks from the database.

Requirement: There should be a pinned search field on top (below the appbar).

My Approach: I will use a CustomScrollView with a SliverAppBar and a SliverPersistentHeader to hold the search TextField. This will keep the search bar visible while the user scrolls.

Requirement: Make use of Bottom Sheet for add/update UI and Dialog for delete.

My Approach: I will call showModalBottomSheet to display a form for creating and editing tasks. For deletion, I'll wrap the delete action in a call to showDialog which will return a confirmation AlertDialog.

Requirement: The todo list must be reactive.

My Approach: The repository will expose a Stream<List<Todo>> from the Floor DAO. The TodoBloc will subscribe to this stream, and the UI will use a BlocBuilder to automatically update whenever the data changes in the database.

Requirement: Must have SQLite as a database.

My Approach: I will use the floor package as the SQLite ORM to define the database, entities, and DAOs (Data Access Objects).

Requirement: Must have BLoC as state manager.

My Approach: I will use the flutter_bloc package. The app's logic will be encapsulated in a TodoBloc which processes TodoEvents and emits TodoStates.

Requirement: Show Snackbar as necessary.

My Approach: I'll use a BlocListener to listen for specific states (e.g., TodoActionSuccess, TodoError) and trigger ScaffoldMessenger.of(context).showSnackBar() to give the user feedback.

Requirement: Show Empty States.

My Approach: In my BlocBuilder, I will check if the list of todos in the TodoLoaded state is empty. If it is, I will render a dedicated widget with an icon and "No tasks yet" message instead of the ListView.

Requirement: Handle duplicate task creation with same title.

My Approach: In the repository layer, before inserting a new task, I will first query the DAO to see if a task with the exact same title exists. If it does, I'll return a Failure, which the BLoC will use to show an error message in a Snackbar.

Optional Recommendations

Recommendation: Use of Clean Architecture.

My Approach: I will structure the project into three distinct layers: Presentation (UI, BLoC), Domain (Entities, UseCases), and Data (Repositories, Floor DB).

Recommendation: Use of Slivers.

My Approach: I will use a CustomScrollView on the main screen to combine the app bar, pinned search bar, and the task list (SliverList) for a smooth scrolling experience.

Recommendation: Take care of potential memory leaks.

My Approach: I will ensure all StreamSubscriptions and ScrollControllers are properly disposed of in the close() method of the BLoC and the dispose() method of the UI widgets, respectively.

Recommendation: Use of Drift package for SQLite.

My Approach: Per our discussion, I will be using Floor instead of Drift for SQLite access.

Recommendation: Add a Tabbed View for showing pending and completed tasks.

My Approach: I will implement a TabBar at the top. The BLoC will provide the full list of tasks, and I will filter this list within the UI to populate the "Pending" and "Completed" tabs, also showing the count in the tab labels.

Recommendation: Feel free to add anything you know.

My Approach: I will use the get_it package for dependency injection to keep the code decoupled. I will also write unit tests for the BLoC and repository logic.
*/