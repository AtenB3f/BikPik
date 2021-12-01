//
//  HabitViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit
import SideMenu

class HabitViewController: UIViewController {
    
    let mngHabit = HabitManager.mngHabit
    let mngToDo = ToDoManager.mngToDo
    let mngNoti = Notifications.mngNotification
    
    var widthCell : CGFloat = 250
    var cellSize = CGSize()
    var sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: notiAddHabit  , object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(_:)))
        habitCollection.addGestureRecognizer(longPress)
        
        //habitCollection.delegate = self
        mngHabit.loadHabit()
        setLayout()
    }
    
    @objc func didDismissPostCommentNotification(_ sender: Any) {
        mngHabit.loadHabit()
        habitCollection.reloadData()
    }
    
    func setLayout() {
        
    }
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBAction func btnMenu(_ sender: Any) {
        let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuViewController
        let menu = CustomSideMenuViewController(rootViewController: sideMenuViewController)
        
        present(menu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var habitCollection: UICollectionView!
    @IBOutlet weak var btnAddHabit: UIButton!
    @IBAction func btnAddHabit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension HabitViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mngHabit.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectCell {
            let size = CGSize(width: 330.0, height: 128.0)
            let id = indexPath.row
            let data = mngHabit.habits[id]
            cell.update(data: data)
            cell.frame.size = size
            cell.updateConstraints()
            cell.layer.cornerRadius = 15
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewW = habitCollection.frame.width
        let col : CGFloat = viewW > 500 ? 2 : 1
        let edge: CGFloat = 10.0
        
        let widthFrame : CGFloat = (viewW - CGFloat(edge * 2)) / col
        let gap : CGFloat = ((col - 1.0) * edge) / 2
        widthCell = widthFrame - gap
        
        sectionInsets.left = (viewW - (widthFrame * col)) / 2
        sectionInsets.right = sectionInsets.left
        cellSize = CGSize(width: widthCell , height: 128)
        
        //cellSize.width -= CGFloat(edge)
        return cellSize
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    @objc func longPressCell(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let point = sender.location(in: habitCollection)
            let row = habitCollection.indexPathForItem(at: point)
            let id:Int  = row?[1] ?? 0
            
            let alert = UIAlertController(title: mngHabit.habits[id].task.name, message: "습관을 삭제하시겠습니까?", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "Delete", style: .destructive, handler: {UIAlertAction in self.alertDelete(id: id) })
            let reviseAct = UIAlertAction(title: "Revise", style: .default, handler: {UIAlertAction in self.alertRevise(id: id)})
            let cancleAct = UIAlertAction(title: "Cancle", style: .default, handler: nil)
            alert.addAction(deleteAct)
            alert.addAction(reviseAct)
            alert.addAction(cancleAct)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func alertDelete(id: Int) {
        let habit = mngHabit.habits[id]
        if habit.task.alram == true {
            mngNoti.removeNotificationHabit(habit: habit)
        }
        mngHabit.deleteHabit(id : id)
        mngHabit.loadHabit()
        mngToDo.updateData()
        habitCollection.reloadData()
    }
    
    func alertRevise(id: Int) {
        let vc  = storyboard.self?.instantiateViewController(withIdentifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        vc.data = mngHabit.habits[id]
        self.present(vc, animated: true, completion: nil)
    }
    
}

class HabitCollectCell: UICollectionViewCell {
    @IBOutlet weak var nameHabit: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var percent: UILabel!
    
    let mngHabit = HabitManager.mngHabit
    
    func update(data: Habits) {
        nameHabit.text = data.task.name
        start.text = "Start    \(Date.DateForm(data: data.start, input: .fullDate, output: .userDate) as! String)"
        end.text = "End      \(Date.DateForm(data: data.end, input: .fullDate, output: .userDate) as! String)"
        total.text = "Total    \(data.total) day"
        percent.text = "\(calPercent(habit: data))%"
    }
    
    func calPercent(habit data: Habits) -> Int {
        
        guard data.isDone != nil else { return 0 }
        guard data.total>0 else { return 0 }
        
        var numDone = 0
        for n in 0...data.total-1 {
            if data.isDone![n] == true {
                numDone += 1
            }
        }
        return (numDone/data.total)*100
    }
}
