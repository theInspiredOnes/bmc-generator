angular.module('bmc').directive 'postIt', (draggedElementServ) ->
	restrict: 'C'
	scope: true
	template:
		'''
			<button class="post-it__delete" title="Delete"></button>
			<textarea ng-model="data.text"></textarea>
		'''
	link: (scope, elm, attrs) ->
		elm.attr 'draggable', 'true'
		scope.data = {}

		dragStart = (event) ->
			draggedElementServ.draggedElement = elm
			elm.addClass 'post-it--dragged'
			#event.dataTransfer.setData('Text', scope.data.text);
			event.dataTransfer.setData('Text', '');

		dragEnd = -> elm.removeClass 'post-it--dragged'

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$emit 'area::elementDropped'
			elm.after draggedElementServ.draggedElement

		elm.bind 'dragstart', dragStart
		elm.bind 'dragend', dragEnd
		elm.bind 'drop', drop
		return

	controller: ($scope, $element) ->
		deleteMe = -> $element.remove()
		$scope.$on 'postIt::delete', deleteMe
		return