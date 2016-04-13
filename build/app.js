var Default,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Default = (function(superClass) {
  extend(Default, superClass);

  function Default() {
    this.show = bind(this.show, this);
    this.hide = bind(this.hide, this);
    this.empty = bind(this.empty, this);
    this.quit = bind(this.quit, this);
    this._default = {
      events: [],
      children: []
    };
    Default.__super__.constructor.apply(this, arguments);
  }

  Default.prototype.on = function(eventName, func) {
    this._default.events.push([eventName, func]);
    return App.Vent.on(eventName, func);
  };

  Default.prototype.once = function(eventName, func) {
    this._default.events.push([eventName, func]);
    return App.Vent.once(eventName, func);
  };

  Default.prototype.off = function(eventName, func) {
    var event, i, len, ref, results;
    if (eventName) {
      return App.Vent.off(eventName, func);
    }
    ref = this._default.events;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      event = ref[i];
      results.push(App.Vent.off(event[0], event[1]));
    }
    return results;
  };

  Default.prototype.append = function(view) {
    this._default.children.push(view);
    return this.$el.append(view.el);
  };

  Default.prototype.prepend = function(view) {
    this._default.children.push(view);
    return this.$el.prepend(view.el);
  };

  Default.prototype.block = function(e) {
    e.preventDefault();
    return e.stopPropagation();
  };

  Default.prototype.quit = function() {
    this.empty();
    this.off();
    return this.remove();
  };

  Default.prototype.empty = function() {
    var child, i, len, ref, results;
    ref = this._default.children;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      child = ref[i];
      results.push(child.quit());
    }
    return results;
  };

  Default.prototype.hide = function() {
    return this.$el.removeClass('show-me');
  };

  Default.prototype.show = function() {
    return this.$el.addClass('show-me');
  };

  Default.prototype.trigger = function() {
    return App.Vent.trigger.apply(Vent, arguments);
  };

  Default.prototype.leftClick = function(e) {
    return (e != null ? e.button : void 0) === 0;
  };

  Default.prototype.objectLength = function(obj) {
    return Object.keys(obj).length;
  };

  Default.prototype.enterPressed = function(e) {
    if (e) {
      return (e.which || e.key) === 13;
    }
  };

  return Default;

})(Backbone.View);

module.exports = Default;
