angular.module('bmc').directive 'areaDropzone', (draggedElementServ, $compile) ->
	restrict: 'C'
	scope: true
	link: (scope, elm, attrs) ->
		dropElement = ->
			elm.append draggedElementServ.draggedElement
			scope.$emit 'area::elementDropped'

		addElement = -> 
			newElement = $compile(draggedElementServ.getNewDragElement())(scope)
			elm.append newElement

		scope.$on 'area::appendDraggedElement', dropElement
		scope.$on 'area::appendNewElement', addElement
		return