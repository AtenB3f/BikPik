//
//  PageViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/14.
//

import UIKit



class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var completeHandler : ((Int)->())?
    
    let viewList : [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let p1 = storyBoard.instantiateViewController(withIdentifier: "ToDoVC")
        let p2 = storyBoard.instantiateViewController(withIdentifier: "HabitVC")
        return [p1,p2]
    } ()
   
    var currentIndex : Int {
            guard let vc = viewControllers?.first else { return 0 }
            return viewList.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstView = viewList.first{
            setViewControllers([firstView], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func setViewcontrollersFromIndex(index : Int){
        if index < 0 && index >= viewList.count {return }
        self.setViewControllers([viewList[index]], direction: .forward, animated: false, completion: nil)
        completeHandler?(currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed {
                completeHandler?(currentIndex)
            }
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = index - 1
        
        if previousIndex < 0 { return nil}
        
        return viewList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = index + 1
        
        if nextIndex == viewList.count { return nil}
        
        return viewList[nextIndex]
    }
}

