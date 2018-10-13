// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('page:change', function () {
  $('.search-submit').on('click', function() {
    window.scrollTo(0,0);
    $('body').addClass('stop-scrolling');
    $('.loading-container').toggle();

  })

var Filter = (function() {
  function Filter(element) {
    this._element = $(element);
    this._optionsContainer = this._element.find(this.constructor.optionsContainerSelector);
  }

  Filter.selector = '.filter';
  Filter.optionsContainerSelector = '> div';
  Filter.hideOptionsClass = 'hide-options';

  Filter.enhance = function() {
    var klass = this;

    return $(klass.selector).each(function() {
      return new klass(this).enhance();
    });
  };

  Filter.prototype.enhance = function() {
    this._buildUI();
    this._bindEvents();
  };

  Filter.prototype._buildUI = function() {
    this._summaryElement = $('<label></label>').
      addClass('summary').
      attr('data-role', 'summary').
      prependTo(this._optionsContainer);

    this._clearSelectionButton = $('<button class=clear></button>').
      text('Clear').
      attr('type', 'button').
      insertAfter(this._summaryElement);

    this._optionsContainer.addClass(this.constructor.hideOptionsClass);
    this._updateSummary();
  };

  Filter.prototype._bindEvents = function() {
    var self = this;

    this._summaryElement.click(function() {
      self._toggleOptions();
    });

    this._clearSelectionButton.click(function() {
      self._clearSelection();
    });

    this._checkboxes().change(function() {
      self._updateSummary();
    });

    $('body').click(function(e) {
      var inFilter = $(e.target).closest(self.constructor.selector).length > 0;

      if (!inFilter) {
        self._allOptionsContainers().addClass(self.constructor.hideOptionsClass);
      }
    });
  };

  Filter.prototype._toggleOptions = function() {
    this._allOptionsContainers().
      not(this._optionsContainer).
      addClass(this.constructor.hideOptionsClass);

    this._optionsContainer.toggleClass(this.constructor.hideOptionsClass);
  };

  Filter.prototype._updateSummary = function() {
    var summary = 'All';
    var checked = this._checkboxes().filter(':checked');

    if (checked.length > 0 && checked.length < this._checkboxes().length) {
      summary = this._labelsFor(checked).join(', ');
    }
    else if (checked.length == 0){
    	summary = 'None'
    }

    this._summaryElement.text(summary);
  };

  Filter.prototype._clearSelection = function() {
    this._checkboxes().each(function() {
      $(this).prop('checked', false);
    });

    this._updateSummary();
  };

  Filter.prototype._checkboxes = function() {
    return this._element.find(':checkbox');
  };

  Filter.prototype._labelsFor = function(inputs) {
    return inputs.map(function() {
      var id = $(this).attr('id');
      return $("label[for='" + id + "']").text();
    }).get();
  };

  Filter.prototype._allOptionsContainers = function() {
    return $(this.constructor.selector + " " + this.constructor.optionsContainerSelector);
  };

  return Filter;
})();

$(function() {
  Filter.enhance();
});
	
	$('.minutes-slider').slider({
		range: true,
		min: 0,
		max: 60,
		values: [0, 20],
		create: function(event, ui) {
			$('.minutes-range').text($('.minutes-slider').slider("values", 0) + " - " + $('.minutes-slider').slider("values", 1));
		},
		change: function(event, ui) {
			$('input#minutes_min').val(ui.values[0]);
			$('input#minutes_max').val(ui.values[1]);
			$('.minutes-range').text(ui.values[0] + " - " + ui.values[1]);
		}
	});
	$('.levels-slider').slider({
		range: true,
		min: 1,
		max: 10,
		values: [1, 10],
		create: function(event, ui) {
			$('.levels-range').text($('.levels-slider').slider("values", 0) + " - " + $('.levels-slider').slider("values", 1));
		},
		change: function(event, ui) {
			$('input#levels_min').val(ui.values[0]);
			$('input#levels_max').val(ui.values[1]);
			$('.levels-range').text(ui.values[0] + " - " + ui.values[1]);
		}
	});	
	
	$('.instruments-select').multiSelect({ keepOrder: true });
	$('.tags-select').multiSelect();
	//quicksearch?

	$('.pieces-search-form').tooltip();

	$('.select-all-countries').click(function(event) {
		if (this.checked) {
			$('.country').each(function() {
				this.checked = true;
			})
		} else {
			$('.country').each(function() {
				this.checked = false;
			})
		}
	})
	$('.select-all-eras').click(function(event) {
		if (this.checked) {
			$('.era').each(function() {
				this.checked = true;
			})
		} else {
			$('.era').each(function() {
				this.checked = false;
			})
		}
	})

});

