import Cocoa
@testable import Utils


//copy comments from legacy code
//try with CommitList
//rename files
//deperecate old files


//
//add onSliderEvent, as you need to tap into 

/**
 * Might be better to not extend SlideView2
 */
class ElasticSlideScrollView2:SlideView2,ElasticSlidableScrollable2{
    var mover:RubberBand?
    var prevScrollingDeltaY:CGFloat = 0/*this is needed in order to figure out which direction the scrollWheel is going in*/
    var velocities:[CGFloat] = Array(repeating: 0, count: 10)/*represents the velocity resolution of the gesture movment*/
    var progressValue:CGFloat?//<--same as progress but unclamped (because RBSliderList may go beyond 0 to 1 values etc)
    override func scrollWheel(with event: NSEvent) {//you can probably remove this method and do it in base?"!?
        Swift.print("ElasticSlideScrollView2.scrollWheel()")
        scroll(event)
    }
    override func resolveSkin() {
        super.resolveSkin()
        /*RubberBand*/
        let frame = CGRect(0,0,width,height)/*represents the visible part of the content *///TODO: could be ranmed to maskRect
        let itemsRect = CGRect(0,0,width,itemsHeight)/*represents the total size of the content *///TODO: could be ranmed to contentRect
        mover = RubberBand(Animation.sharedInstance,setProgress/*👈important*/,frame,itemsRect)
        mover!.event = onEvent/*Add an eventHandler for the mover object, , this has no functionality in this class, but may have in classes that extends this class, like hide progress-indicator when all animation has stopped*/
    }
    override func onEvent(_ event:Event) {
        if(event.assert(AnimEvent.stopped, mover!)){
            Swift.print("anim stopped")
            hideSlider()/*hides the slider when bounce back anim stopps*/
        }else if(event === (SliderEvent.change,slider!)){
            mover!.value = lableContainer!.frame.y//quick fix, move into onSliderEvent in Slidable
        }
        super.onEvent(event)
    }
}
