import Foundation
@testable import Utils
/**
 * This protocol exist because other that Lists may want to be Elastic scrollable, like A container of things
 */
protocol Elastic:Containable {
    var mover:RubberBand?{get set}
    var prevScrollingDelta:CGFloat{get set}//rename to to: prevScrollingDelta
    var velocities:[CGFloat]{get set}
    //⚠️️ you may be able to remove progressvalue in the future. as it works differently now!=!=?
    var progressValue:CGFloat?{get set}//<--same as progress but unclamped (because RBSliderList may go beyond 0 to 1 values etc)
    var iterimScroll:InterimScroll{get set}
}
extension Elastic {
    
    /**
     * PARAM value: is the final y value for the lableContainer
     * TODO: Try to use a preCalculated itemsHeight, as this can be heavy to calculate for lengthy lists
     */
    func setProgress(_ value:CGFloat){//DIRECT TRANSMISSION 💥
        Swift.print("Elastic2.setProgress() value: " + "\(value)")
        lableContainer!.point[dir] = value/*<--this is where we actully move the labelContainer*/
        //the bellow var may not be need to be set
        progressValue = value / -(contentSize[dir] - maskSize[dir])/*get the the scalar values from value.*/
    }
    /*DEPRECATED,Legacy support*/
    var prevScrollingDelta:CGFloat{get{return iterimScroll.prevScrollingDelta}set{iterimScroll.prevScrollingDelta = newValue}}
    var progressValue:CGFloat?{get{return iterimScroll.progressValue}set{iterimScroll.progressValue = newValue}}
    var velocities:[CGFloat]{get{return iterimScroll.velocities}set{iterimScroll.velocities = newValue}}
}
