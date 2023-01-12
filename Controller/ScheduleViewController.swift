//
//  ScheduleViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/5/22.
//  muljo@usc.edu

import UIKit
import EventKit
import EventKitUI

// View controller to schedule a workout and add to calendar
// Using Event Kit apple framework
class ScheduleViewController: UIViewController, EKEventViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var scheduledDate: UIDatePicker!
    @IBOutlet weak var lengthCount: UILabel!
    @IBOutlet weak var workoutTitle: UITextField!
    
    let eventStore = EKEventStore() // Initialize EventKit
    var overHour: Bool! // variable to check if time of workout is over or under 60 min for formatting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Keyboard dismiss gesture recognizers
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userDidSingleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
    }

    // Schedule button clicked to add a workout to callendar
    @IBAction func addButton(_ sender: UIButton) {
        // uses EventKit to create an event on calendar app
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            // Handle the response to the request.
            if granted, error == nil{
                DispatchQueue.main.async {
                    guard let store = self?.eventStore else {return}
                    
                    let newEvent = EKEvent(eventStore: store) // Create new event
                    // If title field filled, fill in event title with input. Otherwise, set to "Workout" default
                    if let title = self?.workoutTitle.text {
                        if(title.count != 0){
                            newEvent.title = title
                        } else{
                            newEvent.title = "Workout"
                        }
                    }
                    else{
                        newEvent.title = "Workout"
                    }
                    
                    // Set start date to set date
                    newEvent.startDate = self?.scheduledDate.date
                    // Set end date to set date advanced by some amount of time (as in workout length)
                    newEvent.endDate = self?.scheduledDate.date.advanced(by: (self?.stepper.value)!*3600)

                    // Create a view controller to present, which shows the workout event to be added
                    let eventcontroller = EKEventViewController()
                    eventcontroller.delegate = self
                    eventcontroller.event = newEvent
                    let navigationController = UINavigationController(rootViewController: eventcontroller)
                    self?.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Button to change the lengthCount text display (Either in minutes or hours)
    @IBAction func stepperClicked(_ sender: Any) {
        
        let workoutLength = 60*stepper.value // get in minutes
        if(workoutLength > 60){
            overHour = true
        }
        else{
            overHour = false
        }
        
        if(overHour){
            lengthCount.text = String(format: "%.2f hours", workoutLength/60)
        }
        else{
            lengthCount.text = String(format: "%.f min", workoutLength)
        }
    }
    
    // When "Done" clicked and completed, dismiss controllers back to home tab view controller
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true)
        self.dismiss(animated: true)
    }
    
    // Keyboard dismiss gesture recognizers
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func userDidSingleTap(_ tap: UITapGestureRecognizer){
        workoutTitle.resignFirstResponder()
    }
    
}

