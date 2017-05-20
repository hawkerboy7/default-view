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
    var msg;
    this._DefaultView = {
      set: false,
      socket: [],
      parent: null,
      children: [],
      removeFromParent: ((function(_this) {
        return function(view) {
          var children, index;
          if (!view) {
            return console.log("View to remove is not provided");
          }
          if (-1 === (index = (children = _this._DefaultView.parent._DefaultView.children).indexOf(view))) {
            return console.log("View " + view + " was not found in it's parent");
          }
          return children.splice(index, 1);
        };
      })(this)).bind(this)
    };
    this.db = App.DB;
    if (!App.Vent) {
      msg = "DefaultView requires a variable App.Vent to be an event emitter (preferably MiniEventEmitter)";
      if (console.warn) {
        return console.warn(msg);
      }
      console.log(msg);
    }
    if (App.Socket) {
      this.socket = {};
      this.socket.on = ((function(_this) {
        return function(event, func) {
          _this._DefaultView.socket.push([event, func]);
          return App.Socket.on(event, func);
        };
      })(this)).bind(this);
      this.socket.off = ((function(_this) {
        return function(event, func) {
          var events, i, len, ref;
          if (event) {
            return App.Socket.off(event, func);
          }
          ref = _this._DefaultView.socket;
          for (i = 0, len = ref.length; i < len; i++) {
            events = ref[i];
            App.Socket.off(events[0], events[1]);
          }
          return _this._DefaultView.socket = [];
        };
      })(this)).bind(this);
      this.socket.emit = (function() {
        return App.Socket.emit.apply(App.Socket, arguments);
      }).bind(this);
      this.socket.once = (function(event, func) {
        this._DefaultView.socket.push([event, func]);
        return App.Socket.once(event, func);
      }).bind(this);
    }
    DefaultView.__super__.constructor.apply(this, arguments);
  }

  DefaultView.prototype.on = function(event, func) {
    App.Vent.on(event, this.cid, func);
    return this._DefaultView.set = true;
  };

  DefaultView.prototype.off = function(event, func) {
    return App.Vent.off(event, this.cid, func);
  };

  DefaultView.prototype.emit = function() {
    return App.Vent.emit.apply(App.Vent, arguments);
  };

  DefaultView.prototype.append = function(view) {
    if (view._DefaultView.parent) {
      view._DefaultView.removeFromParent(view);
    }
    view._DefaultView.parent = this;
    this._DefaultView.children.push(view);
    return this.$el.append(view.el);
  };

  DefaultView.prototype.prepend = function(view) {
    if (view._DefaultView.parent) {
      view._DefaultView.removeFromParent(view);
    }
    view._DefaultView.parent = this;
    this._DefaultView.children.push(view);
    return this.$el.prepend(view.el);
  };

  DefaultView.prototype.empty = function() {
    var child, i, ref;
    ref = this._DefaultView.children;
    for (i = ref.length - 1; i >= 0; i += -1) {
      child = ref[i];
      child.quit();
    }
    return this.$el.empty();
  };

  DefaultView.prototype.quit = function() {
    var children, index, ref;
    this.empty();
    if (this._DefaultView.set) {
      this.off(null);
    }
    if ((ref = this.socket) != null) {
      ref.off();
    }
    index = (children = this._DefaultView.parent._DefaultView.children).indexOf(this);
    children.splice(index, 1);
    return this.remove();
  };

  DefaultView.prototype.block = function(e) {
    this.preventDefault(e);
    this.stopPropagation(e);
    return false;
  };

  DefaultView.prototype.preventDefault = function(e) {
    return e.preventDefault();
  };

  DefaultView.prototype.stopPropagation = function(e) {
    return e.stopPropagation();
  };

  DefaultView.prototype.hide = function() {
    return this.$el.removeClass("show-me");
  };

  DefaultView.prototype.show = function() {
    return this.$el.addClass("show-me");
  };

  DefaultView.prototype.leftClick = function(e) {
    return (e != null ? e.button : void 0) === 0;
  };

  DefaultView.prototype.objLength = function(obj) {
    return Object.keys(obj).length;
  };

  DefaultView.prototype.enterPressed = function(e) {
    return ((e != null ? e.which : void 0) || (e != null ? e.key : void 0)) === 13;
  };

  return DefaultView;

})(Backbone.View);

module.exports = DefaultView;
