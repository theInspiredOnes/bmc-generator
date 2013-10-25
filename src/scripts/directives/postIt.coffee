angular.module('bmc').directive 'postIt', (draggedElementServ) ->
	
	restrict: 'C'

	scope: true

	template:
		'''
		<button class="post-it__delete" title="Delete"></button>
		<textarea ng-model="data.text"></textarea>
		'''

	link: (scope, element, attrs) ->
		element.attr 'draggable', 'true'
		scope.data = {}

		dragStart = (event) ->
			draggedElementServ.draggedElement = element
			element.addClass 'post-it--dragged'
			#event.dataTransfer.setData('Text', scope.data.text);
			event.dataTransfer.setData('Text', '');

		dragEnd = -> element.removeClass 'post-it--dragged'

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$emit 'postIt::elementDropped'
			element.after draggedElementServ.draggedElement

		element.bind 'dragstart', dragStart
		element.bind 'dragend', dragEnd
		element.bind 'drop', drop
		return

	controller: ($scope, $element) ->
		deleteMe = -> $element.remove()
		# no direct call because remove() must not get a parameter
		$scope.$on 'postItDelete::delete', deleteMe
		return