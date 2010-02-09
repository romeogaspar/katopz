package com.sleepydesign.components
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class SDButton extends SDComponent
	{
		private var _back:Shape;
		private var _face:Shape;
		private var _label:SDLabel;
		private var _labelText:String = "";
		private var _over:Boolean = false;
		private var _down:Boolean = false;
		private var _selected:Boolean = false;
		private var _toggle:Boolean = false;

		public function SDButton(label:String = "")
		{
			_labelText = label;
			
			_back = new Shape();
			addChild(_back);

			_label = new SDLabel(_labelText);
			addChild(_label);
			
			_label.autoSize = "center";

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			
			buttonMode = true;
			useHandCursor = true;
			setSize(48, 18);
		}

		override public function draw():void
		{
			_label.autoSize = "center";
			_label.text = _labelText;
			if (_label.width > _width - 4)
			{
				_label.autoSize = "none";
				_label.width = _width - 4;
			}
			else
			{
				_label.autoSize = "center";
			}
			_label.draw();
			_label.x = _width / 2 - _label.width / 2;
			
			_back.graphics.clear();
			_back.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA, true);
			_back.graphics.beginFill(SDStyle.BUTTON_COLOR, SDStyle.BUTTON_ALPHA);
			_back.graphics.drawRoundRect(0, 0, _width, _height, SDStyle.SIZE * .75, SDStyle.SIZE * .75);
			_back.graphics.endFill();
			
			super.draw();
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			TweenLite.to(_back, .25, SDStyle.BUTTON_OVER_TWEEN);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			_over = false;
			if (!_down)
			{
				TweenLite.to(_back, .25, SDStyle.BUTTON_UP_TWEEN);
			}
			else
			{
				TweenLite.to(_back, .25, SDStyle.BUTTON_DOWN_TWEEN);
			}
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			_down = true;
			TweenLite.to(_back, .1, SDStyle.BUTTON_DOWN_TWEEN);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (_toggle && _over)
			{
				_selected = !_selected;
			}
			_down = _selected;
			if (_over)
			{
				TweenLite.to(_back, .1, SDStyle.BUTTON_OVER_TWEEN);
			}
			else
			{
				TweenLite.to(_back, .1, SDStyle.BUTTON_UP_TWEEN);
			}
		}

		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}

		public function get label():String
		{
			return _labelText;
		}

		public function set selected(value:Boolean):void
		{
			if (!_toggle)
				return;

			_selected = value;
			_down = _selected;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}

		public function get toggle():Boolean
		{
			return _toggle;
		}
	}
}