angular.module('bmc').directive 'postItDelete', ->
	restrict: 'C'
	template: '&times;'
	link: (scope, elm, attrs) ->
		deletePostIt = -> scope.$emit 'postIt::delete'
		elm.bind 'click', deletePostIt
		return