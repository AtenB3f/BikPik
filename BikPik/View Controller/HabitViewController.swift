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
    var sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: notiAddHabit  , object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(_:)))
        habitCollection.addGestureRecognizer(longPress)
        
        //habitCollection.delegate = self
        mngHabit.loadHabit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    @objc func didDismissPostCommentNotification(_ sender: Any) {
        mngHabit.loadHabit()
        habitCollection.reloadData()
    }
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBAction func btnMenu(_ sender: Any) {
        updateData()
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
    
    
    func updateData() {
        habitCollection?.indexPathsForVisibleItems.forEach { idx in
            let cell = habitCollection?.cellForItem(at: idx) as! HabitCollectCell
            let id = idx.row
            cell.update(data: mngHabit.habits[id])
        }
    }
}

extension HabitViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mngHabit.habits.count
    }
    
    func calCellSize() -> CGSize {
        let edge = 15.0
        let viewW = habitCollection.frame.width
        let col : CGFloat = round(viewW / 300.0)
        let widthFrame : CGFloat = (viewW) / col
        
        widthCell = widthFrame - (edge*((col-1.0) + 2.0))
        sectionInsets.right = edge
        sectionInsets.left = edge
        let size = CGSize(width: widthCell , height: 128)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectCell {
            let size = calCellSize()//CGSize(width: 330.0, height: 128.0)
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
        cellSize = calCellSize()
        
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
        percent.text = "\(mngHabit.calculatePercent(habit: data))%"
    }
}