////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.html.supportClasses
{
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.IViewportScroller;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.ScrollBarView;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.utils.BeadMetrics;
	
	public class ScrollingViewport implements IBead, IViewport
	{		
		public function ScrollingViewport()
		{
		}
		
		private var contentArea:UIBase;
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _model:IViewportModel;
		
		public function set model(value:IViewportModel):void
		{
			_model = value;
			
			if (model.contentArea) contentArea = model.contentArea as UIBase;
			
			model.addEventListener("contentAreaChanged", handleContentChange);
			model.addEventListener("verticalScrollPositionChanged", handleVerticalScrollChange);
			model.addEventListener("horizontalScrollPositionChanged", handleHorizontalScrollChange);
		}
		public function get model():IViewportModel
		{
			return _model;
		}
		
		private var _verticalScroller:ScrollBar;
		public function get verticalScroller():IViewportScroller
		{
			return _verticalScroller;
		}
		
		private var _horizontalScroller:ScrollBar
		public function get horizontalScroller():IViewportScroller
		{
			return _horizontalScroller;
		}
        
        public function get verticalScrollPosition():Number
        {
            return _model.verticalScrollPosition;
        }
        public function set verticalScrollPosition(value:Number):void
        {
            _model.verticalScrollPosition = value;
        }
        
        public function get horizontalScrollPosition():Number
        {
            return _model.horizontalScrollPosition;
        }
        public function set horizontalScrollPosition(value:Number):void
        {
            _model.horizontalScrollPosition = value;
        }
		
		/**
		 * Invoke this function to reshape and set the contentArea being managed by
		 * this viewport. If scrollers are present this will update them as well to
		 * reflect the current location of the visible portion of the contentArea
		 * within the viewport.
		 */
		public function updateContentAreaSize():void
		{
			var host:UIBase = UIBase(_strand);
			var rect:Rectangle;
			var vbarAdjustHeightBy:Number = 0;
			var hbarAdjustWidthBy:Number = 0;
			
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).maximum = model.contentHeight;
				_verticalScroller.x = model.viewportWidth - _verticalScroller.width + 1;
				_verticalScroller.y = model.viewportY;
				
				rect = contentArea.scrollRect;
				rect.y = ScrollBarModel(_verticalScroller.model).value;
				contentArea.scrollRect = rect;
				
				hbarAdjustWidthBy = _verticalScroller.width + 1;
			}
			
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).maximum = model.contentWidth;
				_horizontalScroller.x = model.viewportX;
				_horizontalScroller.y = model.viewportHeight - _horizontalScroller.height + 1;
				
				rect = contentArea.scrollRect;
				rect.x = ScrollBarModel(_horizontalScroller.model).value;
				contentArea.scrollRect = rect;
				
				vbarAdjustHeightBy = _horizontalScroller.height + 1;
			}
			
			if (_verticalScroller) {
				_verticalScroller.setHeight(model.viewportHeight - vbarAdjustHeightBy, false);
			}
			if (_horizontalScroller) {
				_horizontalScroller.setWidth(model.viewportWidth - hbarAdjustWidthBy, false);
			} 
			
			if (!model.contentIsHost) {
				contentArea.x = model.contentX;
				contentArea.y = model.contentY;
			}
			contentArea.setWidthAndHeight(model.contentWidth, model.contentHeight, true);
		}
		
		public function updateSize():void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			var host:UIBase = UIBase(_strand);
			var addVbar:Boolean = false;
			var addHbar:Boolean = false;
			
			if (model.viewportHeight >= model.contentHeight) {
				if (_verticalScroller) {
					host.removeElement(_verticalScroller);
					_verticalScroller = null;
				}
			}
			else if (model.contentHeight > model.viewportHeight) {
				if (_verticalScroller == null) {
					addVbar = true;
				}
			}
			
			if (model.viewportWidth >= model.contentWidth) {
				if (_horizontalScroller) {
					host.removeElement(_horizontalScroller);
					_horizontalScroller = null;
				}
			}
			else if (model.contentWidth > model.viewportWidth) {
				if (_horizontalScroller == null) {
					addHbar = true;
				}
			}
			
			if (addVbar) needsVerticalScroller();
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).maximum = model.contentHeight;
				ScrollBarModel(_verticalScroller.model).pageSize = model.viewportHeight;
				ScrollBarModel(_verticalScroller.model).pageStepSize = model.viewportHeight;
			}
			
			if (addHbar) needsHorizontalScroller();
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).maximum = model.contentWidth;
				ScrollBarModel(_horizontalScroller.model).pageSize = model.viewportWidth;
				ScrollBarModel(_horizontalScroller.model).pageStepSize = model.viewportWidth;
			}
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect) {
				rect.x = 0;
				rect.y = 0;
				rect.width = model.viewportWidth - metrics.left;
				rect.height = model.viewportHeight - 2*metrics.top;
				contentArea.scrollRect = rect;
			}
		}
		
		/**
		 * Call this function when at least one scroller is needed to view the entire
		 * contentArea.
		 */
		public function needsScrollers():void
		{
			needsVerticalScroller();
			needsHorizontalScroller();
		}
		
		/**
		 * Call this function when only a vertical scroller is needed
		 */
		public function needsVerticalScroller():void
		{
			var host:UIBase = UIBase(_strand);
			
			var needVertical:Boolean = model.contentHeight > model.viewportHeight;
			
			if (needVertical && _verticalScroller == null) {
				_verticalScroller = createVerticalScrollBar();
				var vMetrics:UIMetrics = BeadMetrics.getMetrics(_verticalScroller);
				_verticalScroller.visible = true;
				_verticalScroller.x = model.viewportWidth - (_verticalScroller.width+1) - vMetrics.left - vMetrics.right;
				_verticalScroller.y = model.viewportY;
				_verticalScroller.setHeight(model.viewportHeight, true);
				
				host.addElement(_verticalScroller, false);
			}
		}
		
		/**
		 * Call this function when only a horizontal scroller is needed
		 */
		public function needsHorizontalScroller():void
		{
			var host:UIBase = UIBase(_strand);
			
			var needHorizontal:Boolean = model.contentWidth > model.viewportWidth;
			
			if (needHorizontal && _horizontalScroller == null) {
				_horizontalScroller = createHorizontalScrollBar();
				var hMetrics:UIMetrics = BeadMetrics.getMetrics(_horizontalScroller);
				_horizontalScroller.visible = true;
				_horizontalScroller.x = model.viewportX;
				_horizontalScroller.y = model.viewportHeight - (_horizontalScroller.height+1) - hMetrics.top - hMetrics.bottom;
				_horizontalScroller.setWidth(model.viewportWidth, true);
				
				host.addElement(_horizontalScroller, false);
			}
		}
		
		public function scrollerWidth():Number
		{
			if (_verticalScroller) return _verticalScroller.width;
			return 0;
		}
		
		public function scrollerHeight():Number
		{
			if (_horizontalScroller) return _horizontalScroller.height;
			return 0;
		}
		
		private function createVerticalScrollBar():ScrollBar
		{
			var host:UIBase = UIBase(_strand);
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.maximum = model.contentHeight;
			vsbm.minimum = 0;
			vsbm.pageSize = model.viewportHeight - metrics.top - metrics.bottom;
			vsbm.pageStepSize = model.viewportHeight - metrics.top - metrics.bottom;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;
			
			var vsb:VScrollBar;
			vsb = new VScrollBar();
			vsb.model = vsbm;
			vsb.visible = false;
			
			vsb.addEventListener("scroll",handleVerticalScroll);
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect == null) {
				rect = new Rectangle(0, 0, 
					                 model.viewportWidth - metrics.left - metrics.right, 
									 model.viewportHeight - metrics.top - metrics.bottom);
				contentArea.scrollRect = rect;
			}
			
			return vsb;
		}
		
		private function createHorizontalScrollBar():ScrollBar
		{
			var host:UIBase = UIBase(_strand);
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			var hsbm:ScrollBarModel = new ScrollBarModel();
			hsbm.maximum = model.contentWidth;
			hsbm.minimum = 0;
			hsbm.pageSize = model.viewportWidth - metrics.left - metrics.right;
			hsbm.pageStepSize = model.viewportWidth - metrics.left - metrics.right;
			hsbm.snapInterval = 1;
			hsbm.stepSize = 1;
			hsbm.value = 0;
			
			var hsb:HScrollBar;
			hsb = new HScrollBar();
			hsb.model = hsbm;
			hsb.visible = false;
			
			hsb.addEventListener("scroll",handleHorizontalScroll);
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect == null) {
				rect = new Rectangle(0, 0, 
					model.viewportWidth - metrics.left - metrics.right, 
					model.viewportHeight - metrics.top - metrics.bottom);
				contentArea.scrollRect = rect;
			}
			
			return hsb;
		}
		
		private function handleVerticalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var vpos:Number = ScrollBarModel(_verticalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.y = vpos;
			contentArea.scrollRect = rect;
			
			model.verticalScrollPosition = vpos;
		}
		
		private function handleHorizontalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var hpos:Number = ScrollBarModel(_horizontalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.x = hpos;
			contentArea.scrollRect = rect;
			
			model.horizontalScrollPosition = hpos;
		}
		
		private function handleContentChange(event:Event):void
		{
			contentArea = model.contentArea as UIBase;
		}
		
		private function handleVerticalScrollChange(event:Event):void
		{
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).value = model.verticalScrollPosition;
			}
		}
		
		private function handleHorizontalScrollChange(event:Event):void
		{
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).value = model.horizontalScrollPosition;
			}
		}
	}
}