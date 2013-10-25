angular.module('bmc').directive 'areaAddElement', ->
	restrict: 'C'
	template: '+'
	link: (scope, elm) ->
		addElement = -> scope.$emit 'area::addNewElement'
		elm.bind 'click', addElement
		return