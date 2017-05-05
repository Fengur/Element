import Foundation

class FastListModifier {
    /**
     * Sets selectedIndex in fastList and makes the appropriate UI changes to the visibleItems
     * PARAM: index: dataProvider index
     */
    static func select(_ list:IFastList, _ index:Int, _ isSelected:Bool = true){
        list.selectedIdx = index/*set the cur selectedIdx in fastList*/
        if let index = list.pool.index(where:{index == $0.idx}){//was-> for (i,_) in list.visibleItems.enumerate(){
            ListModifier.selectAt(list, index)/*if the index is currently visible then select it to see UI changes*/
        }
    }
}
