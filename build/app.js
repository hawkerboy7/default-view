var DefaultView,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

DefaultView = (function(superClass) {
  extend(DefaultView, superClass);

  function DefaultView() {
    this.show = bind(this.show, this);
    this.hide = bind(this.hide, this);
    this.quit = bind(this.quit, this);
    this.empty = bind(this.empty, this);
    this._DefaultView = {
      socket: [],
      children: []
    };
    DefaultView.prototype.socket = this.__socket();
    DefaultView.__super__.constructor.apply(this, arguments);
  }

  DefaultView.prototype.__socket = function() {
    var socket;
    return socket = {
      on: (function(_this) {
        return function(eventName, func) {
          _this._DefaultView.socket.push([eventName, func]);
          return App.Socket.on(eventName, func);
        };
      })(this),
      once: (function(_this) {
        return function(eventName, func) {
          _this._DefaultView.socket.push([eventName, func]);
          return App.Socket.once(eventName, func);
        };
      })(this),
      off: (function(_this) {
        return function(eventName, func) {
          var event, i, len, ref, results;
          if (eventName) {
            return App.Socket.off(eventName, func);
          }
          ref = _this._DefaultView.socket;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            event = ref[i];
            results.push(App.Socket.off(event[0], event[1]));
          }
          return results;
        };
      })(this),
      emit: (function(_this) {
        return function() {
          return App.Socket.emit.apply(App.Socket, arguments);
        };
      })(this)
    };
  };

  DefaultView.prototype.on = function(eventName, func) {
    return App.Vent.on(eventName, this.cid, func);
  };

  DefaultView.prototype.off = function(eventName, func) {
    return App.Vent.off(eventName, this.cid, func);
  };

  DefaultView.prototype.emit = function() {
    return App.Vent.emit.apply(App.Vent, arguments);
  };

  DefaultView.prototype.append = function(view) {
    this._DefaultView.children.push(view);
    return this.$el.append(view.el);
  };

  DefaultView.prototype.prepend = function(view) {
    this._DefaultView.children.push(view);
    return this.$el.prepend(view.el);
  };

  DefaultView.prototype.empty = function() {
    var child, i, len, ref, results;
    ref = this._DefaultView.children;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      child = ref[i];
      results.push(child.quit());
    }
    return results;
  };

  DefaultView.prototype.quit = function() {
    this.empty();
    this.off();
    this.socket.off();
    return this.remove();
  };

  DefaultView.prototype.block = function(e) {
    e.preventDefault();
    return e.stopPropagation();
  };

  DefaultView.prototype.hide = function() {
    return this.$el.removeClass('show-me');
  };

  DefaultView.prototype.show = function() {
    return this.$el.addClass('show-me');
  };

  DefaultView.prototype.leftClick = function(e) {
    return (e != null ? e.button : void 0) === 0;
  };

  DefaultView.prototype.objLength = function(obj) {
    return Object.keys(obj).length;
  };

  DefaultView.prototype.enterPressed = function(e) {
    if (e && (e.which || e.key) === 13) {
      return true;
    } else {
      return false;
    }
  };

  return DefaultView;

})(Backbone.View);

module.exports = DefaultView;
