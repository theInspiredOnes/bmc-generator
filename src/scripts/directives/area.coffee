angular.module('bmc').directive 'area', ->
	
	restrict: 'C'

	scope: true

	template:
		'''
		<div class="area__head">
			<input class="area__title" type="text" value="{{title}}"></input>
			<button class="area__add-element" title="Add new element"></button>
		</div>
		<div class="area__dropzone"></div>
		'''

	link: (scope, element, attrs) ->
		scope.title = attrs.caption

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$broadcast 'area::appendDraggedElement'

		dragOver = (event) ->
			if event.preventDefault then event.preventDefault()
			event.dataTransfer.dropEffect = 'move'
			# not with dragenter event because its unreliable
			element.addClass 'area--dragover'

		dragLeave = -> element.removeClass 'area--dragover'

		addElement = -> scope.$broadcast 'area::appendNewElement'
		
		scope.$on 'areaDropzone::elementDropped', dragLeave
		scope.$on 'postIt::elementDropped', dragLeave
		scope.$on 'areaAddElement::addNewElement', addElement

		element.bind 'drop', drop
		element.bind 'dragover', dragOver
		element.bind 'dragleave', dragLeave
		return