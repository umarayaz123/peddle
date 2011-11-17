/*
* jQuery minislider by Diego Imbriani aka Darko Romanov http://romanovian.com
* ----------------------------------------------------------------------------
* "THE BEER-WARE LICENSE" (Revision 42):
* <darko.romanov@gmail.com> wrote this file. As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy me a beer
* ----------------------------------------------------------------------------
*/


jQuery.fn.minislider = function (options) {

	var _cnt;
	var _cnt_size = {};
	var _strip;
	var _to;
	var _index;
	var _itemsCount;
	var _locked;

    var settings = jQuery.extend({
        slideshow: true,
		pause: 4000,
		duration: 1000,
		loop: true,
		easing: null,
		next: '.next',
		prev: '.prev',
		monitor: null
    }, options);

	var _resetLoop = function() {
		_index = 0;
		_strip.css('left', (_itemsCount * _cnt_size.width * -1) + 'px');
	}

	var _checkArrows = function() {
		if(_index == _itemsCount - 1) {
			$(settings.next).addClass('disabled');
		} else {
			$(settings.next).removeClass('disabled');
		}

		if(_index == 0)
			$(settings.prev).addClass('disabled');
		else
			$(settings.prev).removeClass('disabled');
	}

	var _updateMonitor = function () {
		$(settings.monitor).find('a')
			.removeClass('selected')
			.eq(_index % _itemsCount)
			.addClass('selected');
	}

	var _goto = function(idx) {
		var left = idx * _cnt_size.width * -1;
		if(settings.loop) {
			clearInterval(_to);
			left -= _cnt_size.width * _itemsCount;

			_to = setInterval(function () {
				_next();
			}, settings.pause);
		}
		_index = idx;
		_strip.css('left', left);
		_updateMonitor();
		_checkArrows();
	}

	var _scroll = function(fwd) {
		if(_locked)
			return;
		_locked = true;

		var sign = fwd ? "-=" : "+=";

		_strip.animate({left: sign + _cnt_size.width}, settings.duration, settings.easing, function () {
			fwd ? _index++ : _index--;

			if(settings.loop) {
				if(_index % _itemsCount == 0) {
					_resetLoop();
				}
			} else {
				if(_index == _itemsCount - 1)
					clearInterval(_to);
				_checkArrows();
			}
			_updateMonitor();
			_locked = false;
		});
	}

    var _next = function () {
		if(_to > 0 && _index == _itemsCount - 1) {
			clearInterval(_to);
			return;
		}
		_scroll(true);
	}

	var _prev = function () {
		_scroll(false);
	}

    return this.each(function () {
		_cnt = $(this);
		_cnt_size.width = _cnt.width();
		_cnt_size.height = _cnt.height();

		_strip = $('<div />');
		_strip.append(_cnt.children());
		_cnt.append(_strip);
		_itemsCount = _strip.children().size();

		/* assign styles */
		_cnt.css('position', 'relative');
		_cnt.css('overflow', 'hidden');
		_strip.css('position', 'absolute');
		_strip.css('left', 0);
		_strip.css('top', 0);
		_strip.css('width', '999em');

		_index = 0;

		/* monitor settings */
		if(settings.monitor != null) {
			for(var i=0; i<_strip.children().size(); i++) {
				var a = $("<a href='#' />").click(function(e) {
					e.preventDefault();
					_goto($(settings.monitor).find("a").index(this));
				});
				$(settings.monitor).append(a);
			}
			_updateMonitor();
		}

		/* prev and next settings */
		function _arrowsAction(e, action) {
			if($(e).hasClass('disabled'))
				return;

			clearInterval(_to);
			action.apply();

			if(settings.slideshow) {
				_to = setInterval(function () {
					_next();
				}, settings.pause);
			}
		}
		$(settings.next).click(function (e) {
			e.preventDefault();
			_arrowsAction(this, _next);
		});
		$(settings.prev).click(function (e) {
			e.preventDefault();
			_arrowsAction(this, _prev);
		});

		if(! settings.loop) {
			$(settings.next).addClass('disabled');
			$(settings.prev).addClass('disabled');
			if(_itemsCount > 1)
				$(settings.next).removeClass('disabled');
		} else {
			var items = _strip.children();
			_strip.append(items.clone(true)).prepend(items.clone(true));
			_resetLoop();
		}

		/* slideshow settings */
		if(settings.slideshow) {
			_to = setInterval(function () {
				_next();
			}, settings.pause);
		}
    });
};