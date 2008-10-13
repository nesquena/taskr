$(document).ready(function() {
	// response.task.description
	$('form.new-task').attach(NewTaskForm);
	
	$('a.remove-task').attach(Remote.Link, { type : "DELETE", dataType : 'json', 
		success : function(response) {
		  $('li#task-' + response.id).remove();
		}
	});
});

NewTaskForm = $.klass(Remote.Form, {
	initialize : function($super, options) {
		options = $.extend({ success : $.bind(this._afterSuccess, this), beforeSend : $.bind(this._beforeSend, this)  }, options);
		this._setupElements();
		$super(options);
	},
  _beforeSend : function(request) {
		request.setRequestHeader("Accept", "text/javascript, application/json");
		if (this.elements.taskInput.val() == "") {
			this._updateFlash('Please enter a description');
			return false;
	  }
	},
	_afterSuccess : function(taskItem) {
		this.elements.taskList.append(taskItem);
		$(this.element).clearForm();
    this._updateFlash();
	},
	_updateFlash : function(message) {
		if (message != null) {
			this.elements.taskFlash.html(message);
			this.elements.taskInput.addClass('invalid');
		} else {
			this.elements.taskFlash.html("");
			this.elements.taskInput.removeClass('invalid');
		}
	},
	_setupElements : function() {
		this.elements = {
			taskList : $('ul#tasks'),
			taskFlash : $('#task-flash'),
			taskInput : $('form.new-task input[type=text]')
		};
	}
});