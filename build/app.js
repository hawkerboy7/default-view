(function() {
  var Backbone, Default, _, i,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.$ = require('jquery');

  _ = require('lodash');

  Backbone = require('backbone');

  if (!window.Vent) {
    window.Vent = _["extends"]({}, Backbone.Events);
  }

  i = 0;

  Default = (function(superClass) {
    extend(Default, superClass);

    function Default() {
      this.show = bind(this.show, this);
      this.hide = bind(this.hide, this);
      this.quit = bind(this.quit, this);
      i++;
      this._default = {
        id: i,
        events: [],
        children: []
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
      var event, j, len, ref, results;
      if (eventName) {
        return Vent.off(eventName, func);
      }
      ref = this._default.events;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        event = ref[j];
        results.push(Vent.off(event[0], event[1]));
      }
      return results;
    };

    Default.prototype.append = function(view) {
      this._default.children.push(view);
      return this.$el.append(view.el);
    };

    Default.prototype.preppend = function(view) {
      this._default.children.push(view);
      return this.$el.prepend(view.el);
    };

    Default.prototype.block = function(e) {
      e.preventDefault();
      return e.stopPropagation();
    };

    Default.prototype.quit = function() {
      var child, j, len, ref;
      ref = this._default.children;
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        child.quit();
      }
      this.off();
      return this.remove();
    };

    Default.prototype.hide = function() {
      return this.$el.removeClass('show-me');
    };

    Default.prototype.show = function() {
      return this.$el.addClass('show-me');
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
