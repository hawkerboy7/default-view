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
      parent: null,
      socket: [],
      children: []
    };
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
    this.worker = {};
    this.worker.on = (function(event, func) {
      return App.Worker.on(event, this.cid, func);
    }).bind(this);
    this.worker.off = (function(event, func) {
      return App.Worker.off(event, this.cid, func);
    }).bind(this);
    this.worker.emit = (function() {
      return App.Worker.emit.apply(App.Worker, arguments);
    }).bind(this);
    DefaultView.__super__.constructor.apply(this, arguments);
  }

  DefaultView.prototype.on = function(event, func) {
    return App.Vent.on(event, this.cid, func);
  };

  DefaultView.prototype.off = function(event, func) {
    return App.Vent.off(event, this.cid, func);
  };

  DefaultView.prototype.emit = function() {
    return App.Vent.emit.apply(App.Vent, arguments);
  };

  DefaultView.prototype.append = function(view) {
    view._DefaultView.parent = this;
    this._DefaultView.children.push(view);
    return this.$el.append(view.el);
  };

  DefaultView.prototype.prepend = function(view) {
    view._DefaultView.parent = this;
    this._DefaultView.children.push(view);
    return this.$el.prepend(view.el);
  };

  DefaultView.prototype.empty = function() {
    var child, i, ref, results;
    ref = this._DefaultView.children;
    results = [];
    for (i = ref.length - 1; i >= 0; i += -1) {
      child = ref[i];
      results.push(child.quit());
    }
    return results;
  };

  DefaultView.prototype.quit = function() {
    var children, index;
    this.empty();
    this.off();
    this.socket.off();
    this.worker.off();
    index = (children = this._DefaultView.parent._DefaultView.children).indexOf(this);
    children.splice(index, 1);
    return this.remove();
  };

  DefaultView.prototype.block = function(e) {
    e.preventDefault();
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
    if (e && (e.which || e.key) === 13) {
      return true;
    } else {
      return false;
    }
  };

  return DefaultView;

})(Backbone.View);

module.exports = DefaultView;
