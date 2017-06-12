//
//  TutorialViewController.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 6. 3..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
    
    var mainViewController: MainViewController?
    
    var pageViewController : UIPageViewController?
    var numberOfPages = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: InstructionView = viewControllerAtIndex(index: 0)! as! InstructionView
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController is InstructionView {
            index = (viewController as! InstructionView).index
            if(index == 0) {
                return nil
            }
        } else {
            // special case for personalInfoViewController
            index = numberOfPages - 1
        }
        
        return viewControllerAtIndex(index: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0
        if viewController is InstructionView {
            index = (viewController as! InstructionView).index
        } else {
            // there is no page after personalInfoViewController
            return nil
        }
        return viewControllerAtIndex(index: index + 1)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if(index >= numberOfPages) {
            // trying to access the page that does not exist
            return nil
        }
        
        // Create new view controller for the page
        if(index == numberOfPages - 1) { // last page
            let contentViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "TutorialPersonalInfoViewController") as! PersonalInfoViewController
            
            contentViewcontroller.mainViewController = self
            
            return contentViewcontroller
        } else {
            let contentViewcontroller = InstructionView()
            contentViewcontroller.image = ""
            contentViewcontroller.index = index
            
            return contentViewcontroller
        }
    }
    
    func finished() {
        // now personal informations have given, load the card
        mainViewController!.personalCardView.loadPersonalCard()
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.numberOfPages
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class InstructionView: UIViewController {
    var index = 0
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
}
