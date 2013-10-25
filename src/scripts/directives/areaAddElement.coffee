angular.module('bmc').directive 'areaAddElement', ->

	restrict: 'C'

	template: '+'

	link: (scope, element) ->
		addElement = -> scope.$emit 'areaAddElement::addNewElement'
		element.bind 'click', addElement
		return