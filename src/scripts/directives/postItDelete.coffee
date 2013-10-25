angular.module('bmc').directive 'postItDelete', ->
	
	restrict: 'C'

	template: '&times;'

	link: (scope, element, attrs) ->
		deletePostIt = -> scope.$emit 'postItDelete::delete'
		element.bind 'click', deletePostIt
		return