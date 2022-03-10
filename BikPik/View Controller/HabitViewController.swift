//
//  HabitViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit
import SideMenu

class HabitViewController: UIViewController {
    let mngFirebase = Firebase.mngFirebase
    let mngHabit = HabitManager.mngHabit
    let mngToDo = ToDoManager.mngToDo
    let mngNoti = Notifications.mngNotification
    
    var cellSize = CGSize()
    var cellInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.calCellSize), name: NSNotification.Name("DeviceRotateNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAddHabitNoti(_:)), name: NSNotification.Name("AddHabitNoti")  , object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(_:)))
        habitCollection.addGestureRecognizer(longPress)
        
        //habitCollection.delegate = self
        mngHabit.loadHabit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    @objc func handleAddHabitNoti(_ sender: Any) {
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
        mngFirebase.updateHabit(handleSaveHabit: mngHabit.saveServerHabit(uuid:habit:))
        
        habitCollection?.indexPathsForVisibleItems.forEach { idx in
            let cell = habitCollection?.cellForItem(at: idx) as! HabitCollectCell
            let id = idx.row
            if let habit = mngHabit.habits[mngHabit.listHabit[id]] {
                cell.update(data: habit)
            }
        }
    }
}

extension HabitViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mngHabit.habits.count
    }
    
    @objc func calCellSize() -> CGSize {
        var widthCell : CGFloat = 250
        if UITraitCollection.current.userInterfaceIdiom == .pad {
            // pad
            widthCell = (habitCollection.frame.width - 46)/2
        } else {
            // phone
            widthCell = habitCollection.frame.width - 30
        }
        return CGSize(width: widthCell , height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as? HabitCollectCell {
            let size = calCellSize()
            let id = indexPath.row
            if let habit = mngHabit.habits[mngHabit.listHabit[id]] {
                cell.update(data: habit)
            }
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
        return cellInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellInsets.left
    }
    
    
    @objc func longPressCell(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let point = sender.location(in: habitCollection)
            let row = habitCollection.indexPathForItem(at: point)
            let id:Int  = row?[1] ?? 0
            let uuid = mngHabit.listHabit[id]
            let habit = mngHabit.habits[uuid]
            
            let alert = UIAlertController(title: habit?.task.name, message: "습관을 삭제하시겠습니까?", preferredStyle: .alert)
            let deleteAct = UIAlertAction(title: "삭제", style: .default, handler: {UIAlertAction in self.alertDelete(uuid: uuid) })
            let reviseAct = UIAlertAction(title: "수정", style: .default, handler: {UIAlertAction in self.alertRevise(uuid: uuid)})
            let cancleAct = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            alert.addAction(reviseAct)
            alert.addAction(deleteAct)
            alert.addAction(cancleAct)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func alertDelete(uuid: String) {
        guard let habit = mngHabit.habits[uuid] else { return }
        if habit.task.alram == true {
            mngNoti.removeNotificationHabit(habit: habit)
        }
        mngHabit.deleteHabit(uuid : uuid)
        mngHabit.loadHabit()
        mngToDo.updateData()
        habitCollection.reloadData()
    }
    
    func alertRevise(uuid: String) {
        let vc  = storyboard.self?.instantiateViewController(withIdentifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        vc.data = mngHabit.habits[uuid]!
        vc.uuid = uuid
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
