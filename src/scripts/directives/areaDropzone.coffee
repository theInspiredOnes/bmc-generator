angular.module('bmc').directive 'areaDropzone', (draggedElementServ, $compile) ->
	
	restrict: 'C'

	scope: true

	link: (scope, element, attrs) ->
		dropElement = ->
			element.append draggedElementServ.draggedElement
			scope.$emit 'areaDropzone::elementDropped'

		addElement = -> 
			newElement = $compile(draggedElementServ.getNewDragElement()) scope
			element.append newElement

		scope.$on 'area::appendDraggedElement', dropElement
		scope.$on 'area::appendNewElement', addElement
		return