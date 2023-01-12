//
//  ExercisesTableViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import UIKit

// View controller when add exercise button is clicked and shows modal
// Conforms to UISearchBar delegate
class ExercisesTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController()
    
    private var sharedExercisesModel = ExerciseModel.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadExercises()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController() // initialize the searchcontroller

    }
    
    // function to initialize the search controller
    private func initSearchController(){
        searchController.searchBar.delegate = self
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.scopeBarActivation = .onSearchActivation
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Chest", "Back", "Arms", "Shoulders", "Legs","Abs", "Cardio"]
    }
    
    // Search results updating protocol, which checks if search bar input has been changed
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        let searchScope = searchBar.selectedScopeButtonIndex
//        print("Search scope: \(searchScope)")
        // Sends the search text and scope to filter exercises
        filterSearch(searchText: searchText, searchScope: searchScope)
    }
    
    // filters the search
    func filterSearch(searchText: String, searchScope : Int = 0){
        
        // get the category id based on the scope selection
        var categoryId = 0
        if (searchScope == 1){ // chest
            categoryId = 11
        }
        else if (searchScope == 2){ // back
            categoryId = 12
        }
        else if (searchScope == 3){ // arms
            categoryId = 8
        }
        else if (searchScope == 4){ // shoulders
            categoryId = 13
        }
        else if (searchScope == 5){ // legs
            categoryId = 9
        }
        else if (searchScope == 6){ // abs
            categoryId = 10
        }
        else if (searchScope == 7){ // cardio
            categoryId = 15
        }

        // filter the exercises and put into filteredExercises in singleton
        sharedExercisesModel.filteredExercises = sharedExercisesModel.exercises.filter{
            exercise in
            let scopeMatch = (searchScope == 0 || exercise.category == categoryId)
            if(searchController.searchBar.text != ""){
                let searchTextMatch = exercise.name.lowercased().contains(searchText.lowercased())

                return searchTextMatch && scopeMatch // check if searched term matches the exercise name and the category matches the scope
            }else{
                return scopeMatch // return just the scope match if nothing inputted in search bar to filter by category
            }
        }
        tableView.reloadData() // reload data after filter
    }
    
    // Returns the count of either filtered exercises (if search controller is active) or all the exercises
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return sharedExercisesModel.filteredExercises.count
        }
        return sharedExercisesModel.exercises.count
    }
    
   // Load the cell with names of either filtered exercises or all exercises
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
         
        let exercise: Result!
        
        if(searchController.isActive){
            exercise = sharedExercisesModel.filteredExercises[indexPath.row]
        }
        else{
            exercise = sharedExercisesModel.exercises[indexPath.row]
        }
        cell.textLabel?.text = exercise.name;

         return cell
    }
    
    // If row was selected, add the exercise to added exercises in NewWorkouts view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var exercise: Result
        if(searchController.isActive){
            exercise = sharedExercisesModel.filteredExercises[indexPath.row]
        }else {
            exercise = sharedExercisesModel.exercises[indexPath.row]
        }
        
        // Sends data back to the presenting view controller
        if let vc = presentingViewController as? NewWorkoutViewController {
            
            vc.dismiss(animated: true){
                vc.addExercise(exercise)
            }
        }
        
    }
    
    // Load the exercises from the API on the global thread
    func loadExercises(){
        DispatchQueue.global().async {
            do{
                self.sharedExercisesModel.getExercises{ exercises in
                    // load exercises fetched from api into the exercises array singleton
                    DispatchQueue.main.async {
                        self.sharedExercisesModel.exercises = exercises
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }

}
