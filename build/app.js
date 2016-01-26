(function() {
  var Default,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Default = (function(superClass) {
    extend(Default, superClass);

    function Default() {
      this.quit = bind(this.quit, this);
      this.show = bind(this.show, this);
      this.hide = bind(this.hide, this);
      this._default = {
        events: []
      };
      Default.__super__.constructor.apply(this, arguments);
    }

    Default.prototype.on = function(eventName, func) {
      this._default.events.push([eventName, func]);
      return Vent.on(eventName, func);
    };

    Default.prototype.once = function(eventName, func) {
      this._default.events.push([eventName, func]);
      return Vent.once(eventName, func);
    };

    Default.prototype.off = function(eventName, func) {
      var event, i, len, ref, results;
      if (eventName) {
        return Vent.off(eventName, func);
      }
      ref = this._default.events;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        event = ref[i];
        results.push(Vent.off(event[0], event[1]));
      }
      return results;
    };

    Default.prototype.block = function(e) {
      e.preventDefault();
      return e.stopPropagation();
    };

    Default.prototype.hide = function() {
      return this.$el.removeClass('show-me');
    };

    Default.prototype.show = function() {
      return this.$el.addClass('show-me');
    };

    Default.prototype.quit = function() {
      this.off();
      return this.remove();
    };

    Default.prototype.trigger = function() {
      return Vent.trigger.apply(Vent, arguments);
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

}).call(this);
