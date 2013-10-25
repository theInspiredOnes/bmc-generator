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
	link: (scope, elm, attrs) ->
		scope.title = attrs.caption

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$broadcast 'area::appendDraggedElement'

		dragOver = (event) ->
			if event.preventDefault then event.preventDefault()
			event.dataTransfer.dropEffect = 'move'
			# not with dragenter event because its unreliable
			elm.addClass 'area--dragover'

		dragLeave = -> elm.removeClass 'area--dragover'
		addElement = -> scope.$broadcast 'area::appendNewElement'
		
		scope.$on 'area::elementDropped', dragLeave
		scope.$on 'area::addNewElement', addElement

		elm.bind 'drop', drop
		elm.bind 'dragover', dragOver
		elm.bind 'dragleave', dragLeave
		return